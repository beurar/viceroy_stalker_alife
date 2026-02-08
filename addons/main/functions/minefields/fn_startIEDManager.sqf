#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts the IED management loop. Debug use only.
*/

if (!isServer) exitWith {};

if (missionNamespace getVariable ["VIC_IEDManagerRunning", false]) exitWith {};
missionNamespace setVariable ["VIC_IEDManagerRunning", true];

[] spawn {
    while { missionNamespace getVariable ["VIC_IEDManagerRunning", false] } do {
        [] call VIC_fnc_manageIEDSites;
        sleep 6;
    };
};

true
