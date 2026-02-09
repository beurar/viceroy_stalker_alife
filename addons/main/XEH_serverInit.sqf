/*
    STALKER ALife Ã¢â‚¬â€œ serverInit
    Server-only bootstrap and world initialization
*/



["postInit", {
    // ABORT if in Main Menu background ("Intro") or Editor Preview
    if ((missionName select [0, 5]) == "Intro" || is3DEN) exitWith {};

    // Global arrays and managers
    drg_activeSpookZones = [];
    STALKER_activeSpooks = [];
    STALKER_activeHerds      = [];
    STALKER_activeHostiles   = [];
    STALKER_activePredators  = [];
    STALKER_mutantNests      = [];
    STALKER_anomalyFields    = [];
    STALKER_minefields       = [];
    STALKER_boobyTraps       = [];
    STALKER_iedSites         = [];
    STALKER_panicGroups      = [];
    STALKER_wanderers        = [];

    // Map bootstrap
    [] call viceroy_stalker_alife_init_fnc_initMap;

    // HEAVY INIT: Run in background to prevent load-screen freeze
    [] spawn {
        sleep 1; // Allow game to finish loading screen

        // --- Minefields, IEDs, Booby Traps ---
        private _center = [0,0,0];
        private _worldSize = worldSize;
        [_center, _worldSize] call viceroy_stalker_alife_minefields_fnc_spawnMinefields;
        [_center, _worldSize] call viceroy_stalker_alife_minefields_fnc_spawnIEDSites;
        [_center, _worldSize] call viceroy_stalker_alife_minefields_fnc_spawnBoobyTraps;


        // --- Wrecks ---
        private _wreckCount = ["VSA_wreckCount", 10] call viceroy_stalker_alife_cba_fnc_getSetting;
        [_wreckCount] call viceroy_stalker_alife_wrecks_fnc_spawnAbandonedVehicles;

        // --- Anomalies ---
        [_center, _worldSize, 1] call viceroy_stalker_alife_anomalies_fnc_spawnAllAnomalyFields;
        [1] call viceroy_stalker_alife_anomalies_fnc_spawnBridgeAnomalyFields;

        // --- Managers ---
        [] call viceroy_stalker_alife_init_fnc_initManagers;
    };

    // --- Activity / proximity thread ---
    missionNamespace setVariable [
        "STALKER_activityRadius",
        ["VSA_playerNearbyRange", 1500] call viceroy_stalker_alife_cba_fnc_getSetting
    ];

    [] call viceroy_stalker_alife_core_fnc_registerEmissionHooks;

    if (isNil "VIC_activityThread") then {
        VIC_activityThread = [] spawn {
            sleep 8;
            while { true } do {
                [] call viceroy_stalker_alife_mutants_fnc_updateProximity;
                sleep 6;
            };
        };
    };

    if (["VSA_debugMode", false] call viceroy_stalker_alife_cba_fnc_getSetting) then {
        [] call viceroy_stalker_alife_core_fnc_setupDebugActions;
        [] remoteExec ["viceroy_stalker_alife_markers_fnc_markPlayerRanges", 0];
    };

}] call CBA_fnc_addEventHandler;

// --- Global kill tracking --------------------------------------------------
[
    "EntityKilled",
    {
        params ["_unit"];
        [_unit] call viceroy_stalker_alife_zombification_fnc_trackDeadForZombify;
        [_unit] call viceroy_stalker_alife_markers_fnc_markDeathLocation;
    }
] call CBA_fnc_addEventHandler;
