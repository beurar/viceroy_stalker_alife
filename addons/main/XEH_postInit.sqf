/*
    STALKER ALife  postInit
*/


["postInit", {
    // ABORT if in Main Menu background ("Intro") or Editor Preview
    if ((missionName select [0, 5]) == "Intro" || is3DEN) exitWith {};

    missionNamespace setVariable ["STALKER_activityRadius", ["VSA_playerNearbyRange", 1500] call viceroy_stalker_alife_cba_fnc_getSetting];
    [] call viceroy_stalker_alife_core_fnc_registerEmissionHooks;
    if (call viceroy_stalker_alife_antistasi_fnc_isAntistasiUltimate && { ["VSA_disableA3UWeather", false] call viceroy_stalker_alife_cba_fnc_getSetting }) then {
        [] call VIC_fnc_disableA3UWeather;
    };
    if (isServer && {isNil "VIC_activityThread"}) then {
        VIC_activityThread = [] spawn {
            sleep 8;
            while {true} do {
                [] call viceroy_stalker_alife_mutants_fnc_updateProximity;
                sleep 6;
            };
        };
    };
    if (["VSA_debugMode", false] call viceroy_stalker_alife_cba_fnc_getSetting) then {
        [] call viceroy_stalker_alife_core_fnc_setupDebugActions;
        [] remoteExec ["viceroy_stalker_alife_markers_fnc_markPlayerRanges", 0];
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
    [_unit] call viceroy_stalker_alife_zombification_fnc_trackDeadForZombify;
    [_unit] call viceroy_stalker_alife_markers_fnc_markDeathLocation;
}] call CBA_fnc_addEventHandler;

["CBA_SettingChanged", {
    params ["_setting", "_value"];
    if (_setting isEqualTo "VSA_debugMode") then {
        if (hasInterface) then {
            if (_value) then {
                [] call viceroy_stalker_alife_core_fnc_setupDebugActions;
                [] call viceroy_stalker_alife_markers_fnc_markPlayerRanges;
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
