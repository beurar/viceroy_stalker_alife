/*
    STALKER ALife â€“ clientInit
*/
#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"

["CBA_SettingsInitialized", {
    if (hasInterface && { ["VSA_debugMode", false] call FUNC(getSetting) }) then {
        [] call FUNC(setupDebugActions);
    };
    // Request full server state so late-join clients sync runtime arrays and markers
    [] spawn FUNC(requestServerState);
}] call CBA_fnc_addEventHandler;
