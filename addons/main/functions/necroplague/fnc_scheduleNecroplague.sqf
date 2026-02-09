#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Periodically triggers necroplague attacks.

    Params:
        0: NUMBER - minimum delay between attacks in seconds (default 1800)
        1: NUMBER - maximum delay between attacks in seconds (default 3600)
*/
params [["_minDelay",1800],["_maxDelay",3600]];


if (!isServer) exitWith {};
if (["VSA_enableNecroplague", true] call viceroy_stalker_alife_cba_fnc_getSetting isEqualTo false) exitWith {};

_minDelay = ["VSA_necroMinDelay", _minDelay] call viceroy_stalker_alife_cba_fnc_getSetting;
_maxDelay = ["VSA_necroMaxDelay", _maxDelay] call viceroy_stalker_alife_cba_fnc_getSetting;
private _zPerHorde = ["VSA_necroZombies",5] call viceroy_stalker_alife_cba_fnc_getSetting;
private _hordeCount = ["VSA_necroHordes",2] call viceroy_stalker_alife_cba_fnc_getSetting;

[_minDelay,_maxDelay,_zPerHorde,_hordeCount] spawn {
    params ["_min","_max","_z","_count"];
    private _next = time + (_min + random (_max - _min));
    while {true} do {
        if (time >= _next) then {
            [_z,_count] call viceroy_stalker_alife_necroplague_fnc_triggerNecroplague;
            _next = time + (_min + random (_max - _min));
        };
        sleep 10;
    };
};
