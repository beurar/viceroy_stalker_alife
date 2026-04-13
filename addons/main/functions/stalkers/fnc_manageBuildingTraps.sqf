#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Manages building trap sites. Spawns hostile units inside buildings when
    a player approaches, despawns when all players leave.
    STALKER_buildingTraps entries:
        [buildingPos, anchor, spawnPositions, marker, active, group, useZombies, faction]
*/

if (!isServer) exitWith {};
if (isNil "STALKER_buildingTraps") exitWith {};

private _range = missionNamespace getVariable ["STALKER_activityRadius", 1500];
private _triggerRange = ["VSA_buildingTrapTriggerRange", 30] call FUNC(getSetting);
private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

for "_idx" from 0 to (count STALKER_buildingTraps - 1) do {
    private _entry = STALKER_buildingTraps select _idx;
    if (!(_entry isEqualType [])) then { continue };

    _entry params ["_pos", "_anchor", "_spawnPositions", "_marker", "_active", "_grp", "_useZombies", "_faction"];

    // Cleanup: too far from all players
    private _nearAny = false;
    { if (_x distance2D _pos < 2500) exitWith { _nearAny = true } } forEach allPlayers;

    if (!_nearAny) then {
        // Full cleanup
        if (!isNull _grp) then {
            { deleteVehicle _x } forEach units _grp;
            deleteGroup _grp;
        };
        deleteVehicle _anchor;
        if (_marker != "") then { deleteMarker _marker };
        STALKER_buildingTraps set [_idx, "DELETE_ME"];
        continue;
    };

    // Check close proximity for trigger
    private _playerClose = false;
    { if (_x distance2D _pos < _triggerRange) exitWith { _playerClose = true } } forEach allPlayers;

    if (_playerClose) then {
        // ACTIVATE
        if (!_active || { isNull _grp || { units _grp isEqualTo [] } }) then {
            // Spawn units
            if (_useZombies) then {
                // Zombie trap
                private _zombieClasses = ["WBK_Zombie1", "WBK_Zombie2", "WBK_Zombie3"];
                _grp = createGroup [east, true];
                {
                    private _type = selectRandom _zombieClasses;
                    private _unit = _grp createUnit [_type, _x, [], 0, "CAN_COLLIDE"];
                    _unit setPosATL _x;
                    [_unit] joinSilent _grp;
                    _unit setUnitPos "UP";
                } forEach _spawnPositions;
                _grp setBehaviour "COMBAT";
                _grp setCombatMode "RED";
            } else {
                // Stalker trap - use faction data from getStalkerFactions
                if (_faction isEqualTo []) then {
                    private _factions = [] call FUNC(getStalkerFactions);
                    private _hostileFactions = _factions select {
                        private _sides = _x select 1;
                        opfor in _sides
                    };
                    if (_hostileFactions isEqualTo []) then { _hostileFactions = _factions };
                    _faction = selectRandom _hostileFactions;
                };

                private _chosenSide = selectRandom (_faction select 1);
                private _unitClasses = _faction select 2;

                _grp = createGroup [_chosenSide, true];
                {
                    private _type = selectRandom _unitClasses;
                    private _unit = _grp createUnit [_type, _x, [], 0, "CAN_COLLIDE"];
                    _unit setPosATL _x;
                    [_unit] joinSilent _grp;
                    _unit setSkill (0.4 + random 0.4);
                    _unit setUnitPos "UP";
                } forEach _spawnPositions;

                // Defensive behavior
                _grp setBehaviour "COMBAT";
                _grp setCombatMode "RED";

                private _hasLambs = !isNil "lambs_wp_fnc_taskGarrison";
                if (_hasLambs) then {
                    [_grp, _pos, 30, [], true, true] call lambs_wp_fnc_taskGarrison;
                } else {
                    private _wp = _grp addWaypoint [_pos, 10];
                    _wp setWaypointType "GUARD";
                    _wp setWaypointBehaviour "COMBAT";
                };
            };

            if (_debug) then {
                private _label = ["STALKER TRAP ACTIVE", "ZOMBIE TRAP ACTIVE"] select (_useZombies);
                systemChat format ["Building Trap: %1 at %2", _label, _pos];
            };
        };

        if (_marker != "") then { _marker setMarkerAlpha 1 };
        STALKER_buildingTraps set [_idx, [_pos, _anchor, _spawnPositions, _marker, true, _grp, _useZombies, _faction]];
    } else {
        // Check outer proximity for despawn
        private _newActive = [_anchor, _range, _active] call FUNC(evalSiteProximity);

        if (!_newActive && _active) then {
            // DEACTIVATE
            if (!isNull _grp) then {
                { deleteVehicle _x } forEach units _grp;
                deleteGroup _grp;
                _grp = grpNull;
            };
            if (_marker != "") then { _marker setMarkerAlpha 0.2 };
        };

        STALKER_buildingTraps set [_idx, [_pos, _anchor, _spawnPositions, _marker, _newActive, _grp, _useZombies, _faction]];
    };
};

// Cleanup deleted entries
for "_i" from (count STALKER_buildingTraps - 1) to 0 step -1 do {
    if ((STALKER_buildingTraps select _i) isEqualTo "DELETE_ME") then {
        STALKER_buildingTraps deleteAt _i;
    };
};

true
