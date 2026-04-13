#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    STALKER ALife serverInit
    Server-only bootstrap and world initialization
*/

// Global arrays and managers

// Map bootstrap
// [] call FUNC(initMap); // Moved inside spawn


// --- Global kill tracking --------------------------------------------------
[
    "EntityKilled",
    {
        params ["_unit"];
        [_unit] call trackDeadForZombify;
        [_unit] call FUNC(markDeathLocation);
    }
] call CBA_fnc_addEventHandler;

[] call FUNC(watchBlowoutWorldLights);

