#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts background manager systems for STALKER ALife.
*/


// Starts background manager systems when auto init is enabled.

if (!isServer) exitWith { false };

// Only start managers automatically when configured to do so
if !( ["VSA_autoInit", false] call viceroy_stalker_alife_cba_fnc_getSetting ) exitWith {
    false
};

[] call viceroy_stalker_alife_minefields_fnc_startMinefieldManager;
[] call viceroy_stalker_alife_minefields_fnc_startIEDManager;
[] call viceroy_stalker_alife_ambushes_fnc_startAmbushManager;
[] call viceroy_stalker_alife_stalkers_fnc_startSniperManager;
[] call viceroy_stalker_alife_stalkers_fnc_startCampManager;
[] call viceroy_stalker_alife_anomalies_fnc_startAnomalyManager;
[] spawn {
    while { true } do {
        [] call viceroy_stalker_alife_stalkers_fnc_manageWanderers;
        [] call viceroy_stalker_alife_spooks_fnc_manageSpookZones;
        sleep 6;
    };
};
[] spawn {
    while { true } do {
        [] call viceroy_stalker_alife_wrecks_fnc_manageWrecks;
        sleep 6;
    };
};
[] spawn {
    while { true } do {
        [] call viceroy_stalker_alife_chemical_fnc_manageChemicalZones;
        sleep 6;
    };
};
[] spawn {
    while { true } do {
        [] call viceroy_stalker_alife_mutants_fnc_manageHabitats;
        [] call viceroy_stalker_alife_mutants_fnc_manageHerds;
        [] call viceroy_stalker_alife_mutants_fnc_manageHostiles;
        [] call viceroy_stalker_alife_mutants_fnc_manageNests;
        [] call viceroy_stalker_alife_mutants_fnc_managePredators;
        sleep 6;
    };
};
[] spawn {
    sleep 8;
    while { true } do {
        [] call viceroy_stalker_alife_mutants_fnc_updateProximity;
        sleep 6;
    };
};

true
