/*
    STALKER ALife â€“ clientInit
*/

["clientInit", {
    if (hasInterface && { ["VSA_debugMode", false] call viceroy_stalker_alife_cba_fnc_getSetting }) then {
        [] call viceroy_stalker_alife_core_fnc_setupDebugActions;
    };
    // Request full server state so late-join clients sync runtime arrays and markers
    [] spawn viceroy_stalker_alife_server_fnc_requestServerState;
}] call CBA_fnc_addEventHandler;
