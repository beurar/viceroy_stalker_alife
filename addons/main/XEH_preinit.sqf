#include "script_component.hpp"
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

/*
    STALKER ALife â€“ preInit
    - Register Hooks
*/

// Register emission event hooks early
missionNamespace setVariable ["emission_active", false];
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

            [true] call FUNC(cleanupChemicalZones);

            private _radius = ["VSA_emissionChemicalRadius", 300] call FUNC(getSetting);
            private _count  = ["VSA_emissionChemicalCount", 2] call FUNC(getSetting);
            {
                [_x, _radius, _count, -1] call FUNC(spawnRandomChemicalZones);
            } forEach allPlayers;
        };
        default {};
    };
}] call CBA_fnc_addEventHandler;
