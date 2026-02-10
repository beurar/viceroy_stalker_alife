#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
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
    [] call FUNC(initMap);

    // HEAVY INIT: Run in background to prevent load-screen freeze
    [] spawn {
        sleep 1; // Allow game to finish loading screen

        // --- Minefields, IEDs, Booby Traps ---
        private _center = [0,0,0];
        private _worldSize = worldSize;
        [_center, _worldSize] call FUNC(spawnMinefields);
        [_center, _worldSize] call FUNC(spawnIEDSites);
        [_center, _worldSize] call FUNC(spawnBoobyTraps);


        // --- Wrecks ---
        private _wreckCount = ["VSA_wreckCount", 10] call FUNC(getSetting);
        [_wreckCount] call FUNC(spawnAbandonedVehicles);

        // --- Anomalies ---
        [_center, _worldSize, 1] call FUNC(spawnAllAnomalyFields);
        [1] call FUNC(spawnBridgeAnomalyFields);

        // --- Managers ---
        [] call FUNC(initManagers);
    };

    // --- Activity / proximity thread ---
    missionNamespace setVariable [
        "STALKER_activityRadius",
        ["VSA_playerNearbyRange", 1500] call FUNC(getSetting)
    ];

    [] call FUNC(registerEmissionHooks);

    if (isNil "VIC_activityThread") then {
        VIC_activityThread = [] spawn {
            sleep 8;
            while { true } do {
                [] call FUNC(updateProximity);
                sleep 6;
            };
        };
    };

    if (["VSA_debugMode", false] call FUNC(getSetting)) then {
        [] call FUNC(setupDebugActions);
        [] remoteExec ["FUNC(markPlayerRanges)", 0];
    };

}] call CBA_fnc_addEventHandler;

// --- Global kill tracking --------------------------------------------------
[
    "EntityKilled",
    {
        params ["_unit"];
        [_unit] call trackDeadForZombify;
        [_unit] call FUNC(markDeathLocation);
    }
] call CBA_fnc_addEventHandler;
