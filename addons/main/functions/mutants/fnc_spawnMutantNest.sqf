#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a generic mutant nest with the given unit class.
    Params:
        0: POSITION - nest location
        1: STRING - unit class to spawn
*/
params ["_pos", "_class"];

_pos = [_pos] call FUNC(findLandPosition);
if (isNil {_pos} || {_pos isEqualTo []}) exitWith {
};

if (!isServer) exitWith {
};

if (["VSA_enableMutants", true] call FUNC(getSetting) isEqualTo false) exitWith {
};

if (isNil "STALKER_mutantNests") then { STALKER_mutantNests = []; };

private _max = ["VSA_maxMutantNests", 3] call FUNC(getSetting);
if ((count STALKER_mutantNests) >= _max) exitWith {
};

private _nightOnly = ["VSA_nestsNightOnly", true] call FUNC(getSetting);
if (_nightOnly && {dayTime > 5 && dayTime < 20}) exitWith {
};

private _grp = createGroup east;
for "_i" from 1 to 3 do {
    private _u = _grp createUnit [_class, _pos, [], 0, "FORM"];
    [_u] call FUNC(initMutantUnit);
};
private _nestObj = "Land_Campfire_F" createVehicle _pos;

[_pos] call FUNC(createProximityAnchor);

STALKER_mutantNests pushBack [_nestObj, _grp, _pos, _class];

[_grp, _pos] call BIS_fnc_taskDefend;

