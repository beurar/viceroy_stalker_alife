#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts the sniper management loop. Debug use only.
*/

if (!isServer) exitWith {};

if (missionNamespace getVariable ["VIC_sniperManagerRunning", false]) exitWith {};
missionNamespace setVariable ["VIC_sniperManagerRunning", true];

// Initialize timer to NOW, preventing immediate execution on start (Wait 60s)
missionNamespace setVariable ["STALKER_lastSniperGen", diag_tickTime];

[] spawn {
    while { missionNamespace getVariable ["VIC_sniperManagerRunning", false] } do {
        [] call viceroy_stalker_alife_stalkers_fnc_manageSnipers;
        sleep 6;
    };
};

true
