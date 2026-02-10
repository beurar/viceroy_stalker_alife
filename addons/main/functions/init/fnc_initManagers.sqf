#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts background manager systems for STALKER ALife.
*/


// Starts background manager systems when auto init is enabled.

if (!isServer) exitWith { false };

// Only start managers automatically when configured to do so
if !( ["VSA_autoInit", false] call FUNC(getSetting) ) exitWith {
    false
};

[] call FUNC(startMinefieldManager);
[] call FUNC(startIEDManager);
[] call FUNC(startAmbushManager);
[] call FUNC(startSniperManager);
[] call FUNC(startCampManager);
[] call FUNC(startAnomalyManager);
[] spawn {
    while { true } do {
        [] call FUNC(manageWanderers);
        [] call FUNC(manageSpookZones);
        sleep 6;
    };
};
[] spawn {
    while { true } do {
        [] call FUNC(manageWrecks);
        sleep 6;
    };
};
[] spawn {
    while { true } do {
        [] call FUNC(manageChemicalZones);
        sleep 6;
    };
};
[] spawn {
    while { true } do {
        [] call FUNC(manageHabitats);
        [] call FUNC(manageHerds);
        [] call FUNC(manageHostiles);
        [] call FUNC(manageNests);
        [] call FUNC(managePredators);
        sleep 6;
    };
};
[] spawn {
    sleep 8;
    while { true } do {
        [] call FUNC(updateProximity);
        sleep 6;
    };
};

true
