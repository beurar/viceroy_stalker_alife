#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Disables the Antistasi persistent weather script when the mod is loaded.

    Returns:
        BOOL - true if any weather scripts were disabled
*/

if !(call FUNC(isAntistasiUltimate)) exitWith {false};
if (!isServer) exitWith {false};


private _changed = false;

// Disable Antistasi persistent weather script if present
if (!isNil "AU_persistentWeather") then {
    missionNamespace setVariable ["AU_persistentWeather", nil];
    _changed = true;
};

_changed
