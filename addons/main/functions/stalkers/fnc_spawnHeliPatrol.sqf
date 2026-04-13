#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a military helicopter patrol that flies a circuit around an area.
    Uses Military or Spetznaz faction units as crew.

    Params:
        0: POSITION - center of patrol area
        1: NUMBER   - patrol radius (default 1000)
    Returns:
        BOOL
*/
params ["_center", ["_radius", 1000]];

if (!isServer) exitWith { false };

if (isNil "STALKER_heliPatrols") then { STALKER_heliPatrols = [] };

private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

// Helicopter classnames
private _heliClasses = [
    "B_Heli_Light_01_armed_F",
    "B_Heli_Transport_01_F",
    "I_Heli_light_03_unarmed_F"
];

// Select military faction for crew
private _factions = [] call FUNC(getStalkerFactions);
private _milFactions = _factions select {
    private _name = _x select 0;
    _name == "Military" || _name == "Spetznaz"
};
if (_milFactions isEqualTo []) then { _milFactions = _factions };
private _faction = selectRandom _milFactions;
private _chosenSide = selectRandom (_faction select 1);
private _unitClasses = _faction select 2;
private _factionName = _faction select 0;

// Spawn helicopter at altitude
private _spawnPos = _center getPos [_radius, random 360];
_spawnPos set [2, 150 + random 100];

private _heliClass = selectRandom _heliClasses;
private _grp = createGroup [_chosenSide, true];

private _heli = createVehicle [_heliClass, _spawnPos, [], 0, "FLY"];
_heli setPos _spawnPos;
_heli setDir ([_spawnPos, _center] call BIS_fnc_dirTo);
_heli setVelocityModelSpace [0, 60, 0];

// Create crew
private _pilot = _grp createUnit [selectRandom _unitClasses, _spawnPos, [], 0, "CAN_COLLIDE"];
_pilot assignAsDriver _heli;
_pilot moveInDriver _heli;
[_pilot] joinSilent _grp;

// Copilot/Gunner if available
private _turretSlots = count (allTurrets _heli);
if (_turretSlots > 0) then {
    private _gunner = _grp createUnit [selectRandom _unitClasses, _spawnPos, [], 0, "CAN_COLLIDE"];
    _gunner assignAsGunner _heli;
    _gunner moveInTurret [_heli, [0]];
    [_gunner] joinSilent _grp;
};

// Set behavior
_grp setBehaviour "AWARE";
_grp setCombatMode "YELLOW";
_grp setSpeedMode "NORMAL";

// Create patrol waypoints in a circuit around the center
private _wpCount = 4 + floor random 3;
for "_i" from 0 to (_wpCount - 1) do {
    private _angle = (360 / _wpCount) * _i;
    private _wpPos = _center getPos [_radius, _angle];
    _wpPos set [2, 150 + random 50];
    private _wp = _grp addWaypoint [_wpPos, 50];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed "NORMAL";
    _wp setWaypointCompletionRadius 100;
    if (_i == 0) then { _wp setWaypointBehaviour "AWARE" };
};

// Cycle back to start
private _wpCycle = _grp addWaypoint [_center getPos [_radius, 0], 50];
_wpCycle setWaypointType "CYCLE";

private _anchor = [_center] call FUNC(createProximityAnchor);

private _marker = "";
if (_debug) then {
    _marker = format ["heli_%1", diag_tickTime];
    [_marker, _spawnPos, "ICON", "mil_helicopter", "#(0,0.4,0,1)", 0.8, format ["HeliPatrol-%1", _factionName]] call FUNC(createGlobalMarker);
};

// Entry: [group, helicopter, centerPos, anchor, marker, faction]
STALKER_heliPatrols pushBack [_grp, _heli, _center, _anchor, _marker, _faction];

if (_debug) then {
    systemChat format ["Heli Patrol: %1 spawned, orbiting %2 at %3m radius", _factionName, _center, _radius];
};

true
