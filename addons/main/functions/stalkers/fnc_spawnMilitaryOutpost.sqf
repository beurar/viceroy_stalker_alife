#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a military outpost at the given position.
    The outpost garrison detects nearby players and calls in off-map
    airstrikes when a target is spotted. Only Military or Spetznaz
    factions are used.

    Params:
        0: POSITION - center of the outpost

    Creates entry in STALKER_militaryOutposts:
        [group, vehicles, centerPos, anchor, marker, faction, lastStrikeTime]
*/
params ["_pos"];

if (!isServer) exitWith {};

if (isNil "STALKER_militaryOutposts") then { STALKER_militaryOutposts = [] };

// Minimum spacing between outposts
private _spacing = 500;
private _tooClose = false;
{
    if (_pos distance2D (_x select 2) < _spacing) exitWith { _tooClose = true };
} forEach STALKER_militaryOutposts;
if (_tooClose) exitWith {
    systemChat "Military outpost too close to existing outpost";
};

// Select Military or Spetznaz faction
private _factions = [] call FUNC(getStalkerFactions);
private _milFactions = _factions select { (_x select 0) in ["Military", "Spetznaz"] };
if (_milFactions isEqualTo []) exitWith {
    systemChat "No military factions available";
};
private _faction = selectRandom _milFactions;
private _factionName = _faction select 0;
private _side = selectRandom (_faction select 1);
private _classes = _faction select 2;

private _grp = createGroup _side;

// Spawn 6-10 garrison units
private _unitCount = 6 + floor random 5;
for "_i" from 1 to _unitCount do {
    private _cls = selectRandom _classes;
    private _unitPos = _pos getPos [random 8, random 360];
    _grp createUnit [_cls, _unitPos, [], 0, "FORM"];
};

// Place static weapons (1-2 HMGs)
private _vehicles = [];
private _hmgCount = 1 + floor random 2;
for "_i" from 1 to _hmgCount do {
    private _hmgPos = _pos getPos [8 + random 6, (_i * 120) + random 40];
    private _hmg = "I_HMG_01_high_F" createVehicle _hmgPos;
    _hmg setDir ((_hmgPos getDir _pos) + 180);
    _vehicles pushBack _hmg;

    // Assign a unit to man the static weapon
    if (count units _grp > _i) then {
        private _gunner = (units _grp) select _i;
        _gunner moveInGunner _hmg;
    };
};

// Place a parked vehicle
private _vehClasses = ["d3s_uaz_2315", "d3s_uaz_2315D", "d3s_gaz66_TENT", "d3s_BRDM_2"];
private _vehPos = _pos getPos [12 + random 5, random 360];
private _veh = (selectRandom _vehClasses) createVehicle _vehPos;
_veh setDir random 360;
_vehicles pushBack _veh;

// Fortifications - sandbag walls
private _fortCount = 3 + floor random 3;
for "_i" from 1 to _fortCount do {
    private _angle = (_i / _fortCount) * 360;
    private _fPos = _pos getPos [10 + random 4, _angle];
    private _fort = "Land_BagFence_Long_F" createVehicle _fPos;
    _fort setDir (_fPos getDir _pos);
    _fort enableSimulationGlobal true;
};

// Set up LAMBS defend task
if (isClass (configFile >> "CfgPatches" >> "lambs_danger")) then {
    [_grp, _pos, 80, [], true, true] call lambs_wp_fnc_taskCamp;
} else {
    [_grp, _pos] call BIS_fnc_taskDefend;
};

// Set combat posture
_grp setBehaviourStrong "AWARE";
_grp setCombatMode "YELLOW";

// Tripwire perimeter
[_pos, 20, 6, 12] call FUNC(spawnTripwirePerimeter);

// Proximity anchor for activation/deactivation
private _anchor = [_pos] call FUNC(createProximityAnchor);

// Debug marker
private _marker = "";
if (["VSA_debugMode", false] call FUNC(getSetting)) then {
    _marker = format ["outpost_%1", diag_tickTime];
    [_marker, _pos, "ICON", "mil_triangle", VIC_colorMilitary, 0.4, format ["Outpost (%1)", _factionName], [1,1], true] call FUNC(createGlobalMarker);
};

// Store entry: lastStrikeTime starts at 0 so first strike can fire immediately
private _entry = [_grp, _vehicles, _pos, _anchor, _marker, _factionName, 0];
STALKER_militaryOutposts pushBack _entry;

// Spawn the detection + airstrike watchdog
_entry spawn {
    params ["_grp", "_vehicles", "_pos", "_anchor", "_marker", "_factionName", "_lastStrikeTime"];
    private _strikeCooldown = 120;
    private _detectRange = 300;
    private _strikeDelay = 8;

    while { !isNull _grp && { (units _grp select { alive _x }) isNotEqualTo [] } } do {
        sleep 5;

        // Check if any unit in the group has spotted a player
        private _spottedPlayer = objNull;
        {
            private _unit = _x;
            if (alive _unit) then {
                {
                    if (_unit knowsAbout _x >= 1.5 && { _unit distance _x < _detectRange }) exitWith {
                        _spottedPlayer = _x;
                    };
                } forEach allPlayers;
            };
            if (!isNull _spottedPlayer) exitWith {};
        } forEach (units _grp);

        if (isNull _spottedPlayer) then { continue };

        // Check cooldown
        if (diag_tickTime - _lastStrikeTime < _strikeCooldown) then { continue };

        // Radio warning
        private _msg = format [
            "%1 outpost: 'Command, we have visual on hostiles at grid %2. Requesting fire mission!'",
            _factionName,
            mapGridPosition _spottedPlayer
        ];
        [_msg] remoteExec ["systemChat", 0];

        sleep _strikeDelay;

        // Call in actual CAS run with RHS Su-25 Frogfoot
        private _strikePos = getPosATL _spottedPlayer;

        // Pick RHS Su-25 class (RHSAFRF preferred, GREF fallback)
        private _planeClass = "";
        {
            if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith {
                _planeClass = _x;
            };
        } forEach ["rhs_Su25SM_vvsc", "rhs_Su25SM_vvs", "rhsgref_cdf_su25"];

        if (_planeClass == "") then { _planeClass = "B_Plane_CAS_01_dynamicLoadout_F" };

        // Spawn the aircraft 3km out at 300m altitude, heading toward target
        private _inboundDir = random 360;
        private _spawnDist = 3000;
        private _alt = 300;
        private _spawnPos = _strikePos getPos [_spawnDist, _inboundDir + 180];
        _spawnPos set [2, _alt];

        private _casGrp = createGroup east;
        private _plane = createVehicle [_planeClass, _spawnPos, [], 0, "FLY"];
        _plane setDir (_spawnPos getDir _strikePos);
        _plane setVelocityModelSpace [0, 80, 0];
        _plane flyInHeight _alt;

        private _pilot = _casGrp createUnit [selectRandom _classes, _spawnPos, [], 0, "CARGO"];
        _pilot moveInDriver _plane;

        // Inbound radio call
        private _msg2 = format [
            "%1 outpost: 'Copy, aircraft inbound on heading %2. Danger close!'",
            _factionName,
            round (_spawnPos getDir _strikePos)
        ];
        [_msg2] remoteExec ["systemChat", 0];

        // SAD waypoint at target so the AI attacks what it sees
        private _wpAttack = _casGrp addWaypoint [_strikePos, 0];
        _wpAttack setWaypointType "SAD";
        _wpAttack setWaypointBehaviour "COMBAT";
        _wpAttack setWaypointCombatMode "RED";
        _wpAttack setWaypointSpeed "FULL";
        _wpAttack setWaypointCompletionRadius 200;

        // Egress waypoint past target so it flies through
        private _egressPos = _strikePos getPos [_spawnDist, _inboundDir];
        _egressPos set [2, _alt];
        private _wpEgress = _casGrp addWaypoint [_egressPos, 0];
        _wpEgress setWaypointType "MOVE";
        _wpEgress setWaypointSpeed "FULL";

        // Cleanup the aircraft once it reaches egress or after 90s
        [_plane, _casGrp, _egressPos] spawn {
            params ["_p", "_g", "_egress"];
            private _timeout = diag_tickTime + 90;
            waitUntil {
                sleep 3;
                !alive _p
                || { _p distance2D _egress < 500 }
                || { diag_tickTime > _timeout }
            };
            sleep 5;
            { deleteVehicle _x } forEach units _g;
            deleteVehicle _p;
            deleteGroup _g;
        };

        _lastStrikeTime = diag_tickTime;

        // Update stored entry
        {
            if ((_x select 2) isEqualTo _pos) exitWith {
                _x set [6, _lastStrikeTime];
            };
        } forEach STALKER_militaryOutposts;
    };
};

systemChat format ["Military outpost (%1) spawned at %2", _factionName, _pos];
