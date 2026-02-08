/*
    STALKER ALife â€“ clientInit
*/

["clientInit", {
    if (hasInterface && { ["VSA_debugMode", false] call VIC_fnc_getSetting }) then {
        [] call VIC_fnc_setupDebugActions;
    };
    // Request full server state so late-join clients sync runtime arrays and markers
    [] spawn VIC_fnc_requestServerState;
}] call CBA_fnc_addEventHandler;
