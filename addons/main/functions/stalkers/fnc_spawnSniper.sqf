#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a single sniper at one of the nearest cached sniper spots.
    The unit garrisons that position using lambs_wp_fnc_taskGarrison.

    Params:
        0: POSITION - center position to search from (default: position of the caller)
*/

params [["_center", [0,0,0]]];


if (!isServer) exitWith {};

if (isNil "STALKER_snipers") then { STALKER_snipers = [] };

if (isNil "STALKER_sniperSpots" || {STALKER_sniperSpots isEqualTo []}) exitWith {
};

private _sorted = STALKER_sniperSpots apply { [_center distance2D _x, _x] };
_sorted sort true;
private _candidates = [];
{
    _candidates pushBack (_x select 1);
    if (count _candidates >= 5) exitWith {};
} forEach _sorted;

private _spot = selectRandom _candidates;
if (isNil {_spot}) exitWith {
};

private _spotAGL = ASLToAGL _spot;

// Find a building position to place the sniper on
private _bld = nearestBuilding _spotAGL;
private _spawnPos = _spotAGL;
if (!isNull _bld && { _spotAGL distance _bld < 30 }) then {
    private _bPos = _bld buildingPos -1;
    private _upper = _bPos select { (_x select 2) > 2.5 };
    if (_upper isNotEqualTo []) then {
        _spawnPos = selectRandom _upper;
    };
};

private _grp = createGroup east;
private _unit = _grp createUnit ["O_sniper_F", _spawnPos, [], 0, "CAN_COLLIDE"];
_unit setPosATL _spawnPos;

// Lock sniper in place to prevent falling
_unit disableAI "PATH";
_unit disableAI "FSM";
_unit forceSpeed 0;
_unit setUnitPos "MIDDLE";
_unit setVariable ["VIC_isSniper", true];
_unit setVariable ["VIC_sniperAnchor", _spawnPos];
_unit allowFleeing 0;
_unit enableAI "TARGET";
_unit enableAI "AUTOTARGET";
_unit enableAI "ANIM";

// Position watchdog
_unit spawn {
    private _anchor = _this getVariable ["VIC_sniperAnchor", []];
    if (_anchor isEqualTo []) exitWith {};
    while { alive _this && _this getVariable ["VIC_isSniper", false] } do {
        if (_this distance _anchor > 2) then {
            _this setPosATL _anchor;
        };
        sleep 5;
    };
};

[_unit] call FUNC(sniperScan);
[_spotAGL, 6, 4] call FUNC(spawnTripwirePerimeter);

private _anchor = [_spotAGL] call FUNC(createProximityAnchor);

private _marker = "";
if (["VSA_debugMode", false] call FUNC(getSetting)) then {
    _marker = format ["snp_%1", diag_tickTime];
    [_marker, _spotAGL, "ICON", "mil_ambush", "#(1,0,0,1)", 0.6, "Sniper"] call FUNC(createGlobalMarker);
};

STALKER_snipers pushBack [_grp, _spotAGL, _anchor, _marker, true];

