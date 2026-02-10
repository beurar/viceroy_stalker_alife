#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts the minefield management loop. Debug use only.
*/

if (!isServer) exitWith {};

if (missionNamespace getVariable ["VIC_minefieldManagerRunning", false]) exitWith {};
missionNamespace setVariable ["VIC_minefieldManagerRunning", true];

[] spawn {
    while { missionNamespace getVariable ["VIC_minefieldManagerRunning", false] } do {
        [] call FUNC(manageMinefields);
        [] call FUNC(manageBoobyTraps);
        sleep 6;
    };
};

true
