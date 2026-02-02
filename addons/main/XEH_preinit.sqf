/*
    STALKER ALife – preInit
    - Register CBA settings
    - Compile functions
    - Define constants
*/


// --- Shared initializations migrated from fn_masterInit.sqf ---
private _settings = "cba_settings.sqf";
private _start = diag_tickTime;
waitUntil {
    !isNil "CBA_fnc_addSetting" || {diag_tickTime - _start > 5}
};
if (isNil "CBA_fnc_addSetting") exitWith {
    diag_log "STALKER ALife: CBA not found - skipping initialization";
};
call compile preprocessFileLineNumbers _settings;

VIC_fnc_debugLog                 = compile preprocessFileLineNumbers ("functions\core\fn_debugLog.sqf");
["preInit"] call VIC_fnc_debugLog;

// Register emission event hooks early
missionNamespace setVariable ["emission_active", false];
["registerEmissionHooks"] call VIC_fnc_debugLog;
["diwako_anomalies_main_blowOutStage", {
    params ["_stage"];
    switch (_stage) do {
        case 1: {
            missionNamespace setVariable ["emission_active", true];
            [] call panic_fnc_onEmissionBuildUp;
            [] call anomalies_fnc_onEmissionBuildUp;
        };
        case 2: {
            missionNamespace setVariable ["emission_active", true];
            [] call panic_fnc_onEmissionStart;
            [] call anomalies_fnc_onEmissionStart;
            [] call mutants_fnc_onEmissionStart;
            [] call chemical_fnc_onEmissionStart;
        };
        case 0: {
            missionNamespace setVariable ["emission_active", false];
            [] call panic_fnc_onEmissionEnd;
            [] call anomalies_fnc_onEmissionEnd;
            [] call mutants_fnc_onEmissionEnd;
            [] call chemical_fnc_onEmissionEnd;
            [] call zombification_fnc_onEmissionEnd;

            [true] call VIC_fnc_cleanupChemicalZones;

            private _radius = ["VSA_emissionChemicalRadius", 300] call VIC_fnc_getSetting;
            private _count  = ["VSA_emissionChemicalCount", 2] call VIC_fnc_getSetting;
            {
                [_x, _radius, _count, -1] call VIC_fnc_spawnRandomChemicalZones;
            } forEach allPlayers;
        };
        default {};
    };
}] call CBA_fnc_addEventHandler;
// --- Custom marker colours -------------------------------------------------

// --- Core/shared functions -------------------------------------------------
