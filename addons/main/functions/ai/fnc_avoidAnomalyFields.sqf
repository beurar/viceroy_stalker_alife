#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    File: fn_avoidAnomalyFields.sqf
    Author: Viceroy's STALKER ALife
    Description:
        Causes AI units to keep clear of anomaly field areas.
    Parameter(s): none
*/



if (!isServer) exitWith {
};
if (["VSA_enableAIBehaviour", true] call FUNC(getSetting) isEqualTo false) exitWith {
};
if !(missionNamespace getVariable ["VSA_fieldAvoidEnabled", true]) exitWith {
};
if (["VSA_aiNightOnly", false] call FUNC(getSetting) && { dayTime > 5 && dayTime < 20 }) exitWith {
};
if (isNil "STALKER_anomalyFields") exitWith {
};

private _chance = ["VSA_aiAnomalyAvoidChance", 50] call FUNC(getSetting);
private _buffer = ["VSA_aiAnomalyAvoidRange", 20] call FUNC(getSetting);

private _fields = STALKER_anomalyFields apply { [ _x select 0, _x select 2 ] };
if (_fields isEqualTo []) exitWith {
};

{
    if (random 100 >= _chance) then { continue; };
    private _unit = _x;
    if (!alive _unit || {isPlayer _unit}) then { continue; };

    private _field = [];
    {
        _x params ["_c","_r"];
        if (_unit distance _c < (_r + _buffer)) exitWith { _field = [_c, _r] };
    } forEach _fields;

    if (_field isNotEqualTo []) then {
        _field params ["_center","_radius"];
        private _dir = _unit getDir _center;
        private _dest = (getPosATL _unit) getPos [(_radius + _buffer) * 1.2, _dir + 180];
        _unit doMove _dest;
    };
} forEach allUnits;


true
