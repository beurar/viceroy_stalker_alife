#include "script_component.hpp"
/*
    STALKER ALife  postInit
*/


["postInit", {
    // ABORT if in Main Menu background ("Intro") or Editor Preview
    if ((missionName select [0, 5]) == "Intro" || is3DEN) exitWith {};

    missionNamespace setVariable ["STALKER_activityRadius", ["VSA_playerNearbyRange", 1500] call FUNC(getSetting)];
    [] call FUNC(registerEmissionHooks);
    if (call FUNC(isAntistasiUltimate) && { ["VSA_disableA3UWeather", false] call FUNC(getSetting) }) then {
        [] call VIC_fnc_disableA3UWeather;
    };
    if (isServer && {isNil "VIC_activityThread"}) then {
        VIC_activityThread = [] spawn {
            sleep 8;
            while {true} do {
                [] call FUNC(updateProximity);
                sleep 6;
            };
        };
    };
    if (["VSA_debugMode", false] call FUNC(getSetting)) then {
        [] call FUNC(setupDebugActions);
        [] remoteExec [QFUNC(markPlayerRanges), 0];
    };
    [] call antistasi_fnc_manageAntistasiEvents;
    
    // Override Diwako's psy wave texture function
    [] spawn {
        sleep 1;
        if (!isNil "diwako_anomalies_main_fnc_showPsyWavesInSky") then {
            systemChat "Viceroy: Overriding diwako_anomalies_main_fnc_showPsyWavesInSky";
            diwako_anomalies_main_fnc_showPsyWavesInSky = compileScript ["\z\viceroy_stalker_alife\addons\main\functions\overrides\fnc_showPsyWavesInSky.sqf"];
        } else {
             systemChat "Viceroy: diwako_anomalies_main_fnc_showPsyWavesInSky IS NIL";
             // Try to force compile it anyway to see if it helps
             diwako_anomalies_main_fnc_showPsyWavesInSky = compileScript ["\z\viceroy_stalker_alife\addons\main\functions\overrides\fnc_showPsyWavesInSky.sqf"];
        };
    };
}] call CBA_fnc_addEventHandler;


// Track units killed during emissions for later zombification
["EntityKilled", {
    params ["_unit"];
    [_unit] call trackDeadForZombify;
    [_unit] call FUNC(markDeathLocation);
}] call CBA_fnc_addEventHandler;

["CBA_SettingChanged", {
    params ["_setting", "_value"];
    if (_setting isEqualTo "VSA_debugMode") then {
        if (hasInterface) then {
            if (_value) then {
                [] call FUNC(setupDebugActions);
                [] call FUNC(markPlayerRanges);
            } else {
                if (!isNil "STALKER_playerRangeMarker" && {STALKER_playerRangeMarker != ""}) then {
                    deleteMarkerLocal STALKER_playerRangeMarker;
                };
                STALKER_playerRangeMarker = "";
                missionNamespace setVariable ["VSA_rangeMarkersActive", false];
            };
        };
    };
}] call CBA_fnc_addEventHandler;
