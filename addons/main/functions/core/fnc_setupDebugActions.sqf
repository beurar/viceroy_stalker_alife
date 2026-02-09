#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Adds interaction actions to the player for triggering major
    STALKER ALife systems. Only runs when VSA_debugMode is enabled.
*/

if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["VSA_debugActionsAdded", false]) exitWith {};
missionNamespace setVariable ["VSA_debugActionsAdded", true];

// --- Spawning Actions ---
player addAction ["<t color='#00FFFF'>[DEBUG] Force Psy Sky Override</t>", {
    systemChat "Attempting manual override of Psy Sky texture...";
    diwako_anomalies_main_fnc_showPsyWavesInSky = compileScript ["\z\viceroy_stalker_alife\addons\main\functions\overrides\fnc_showPsyWavesInSky.sqf"];
    if (isNil "diwako_anomalies_main_fnc_showPsyWavesInSky") then {
        systemChat "Override FAILED: Variable is still nil.";
    } else {
        systemChat "Override SUCCESS: Function reassigned.";
    };
}];

player addAction ["<t color='#ff0000'>Spawn Psy-Storm</t>", {
    private _dur = ["VSA_stormDuration", 180] call viceroy_stalker_alife_cba_fnc_getSetting;
    private _lStart = ["VSA_stormLightningStart", 6] call viceroy_stalker_alife_cba_fnc_getSetting;
    private _lEnd   = ["VSA_stormLightningEnd", 12] call viceroy_stalker_alife_cba_fnc_getSetting;
    private _dStart = ["VSA_stormDischargeStart", 6] call viceroy_stalker_alife_cba_fnc_getSetting;
    private _dEnd   = ["VSA_stormDischargeEnd", 12] call viceroy_stalker_alife_cba_fnc_getSetting;
    if (isServer) then {
        [_dur, _lStart, _lEnd, _dStart, _dEnd] call viceroy_stalker_alife_storms_fnc_triggerPsyStorm;
    } else {
        [_dur, _lStart, _lEnd, _dStart, _dEnd] remoteExec ["viceroy_stalker_alife_storms_fnc_triggerPsyStorm", 2];
    };
}];
player addAction ["<t color='#ff0000'>Trigger Blowout</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_blowouts_fnc_triggerBlowout;
    } else {
        [] remoteExec ["viceroy_stalker_alife_blowouts_fnc_triggerBlowout", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Chemical Zone</t>", {
    if (isServer) then {
        [getPos player, 100] call viceroy_stalker_alife_chemical_fnc_spawnChemicalZone;
    } else {
        [getPos player, 100] remoteExec ["viceroy_stalker_alife_chemical_fnc_spawnChemicalZone", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Random Chemicals</t>", {
    if (isServer) then {
        [getPos player, 200] call viceroy_stalker_alife_chemical_fnc_spawnRandomChemicalZones;
    } else {
        [getPos player, 200] remoteExec ["viceroy_stalker_alife_chemical_fnc_spawnRandomChemicalZones", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Valley Chemicals</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_chemical_fnc_spawnValleyChemicalFields;
    } else {
        [] remoteExec ["viceroy_stalker_alife_chemical_fnc_spawnValleyChemicalFields", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Stable Fields</t>", {
    for "_i" from 1 to 100 do {
        private _pos = [random worldSize, random worldSize, 0];
        if (isServer) then {
            [_pos, 1000, 1] call viceroy_stalker_alife_anomalies_fnc_spawnAllAnomalyFields;
        } else {
            [_pos, 1000, 1] remoteExec ["viceroy_stalker_alife_anomalies_fnc_spawnAllAnomalyFields", 2];
        };
    };
}];
player addAction ["<t color='#ff0000'>Spawn Unstable Fields</t>", {
    for "_i" from 1 to 100 do {
        private _pos = [random worldSize, random worldSize, 0];
        if (isServer) then {
            [_pos, 1000, 0] call viceroy_stalker_alife_anomalies_fnc_spawnAllAnomalyFields;
        } else {
            [_pos, 1000, 0] remoteExec ["viceroy_stalker_alife_anomalies_fnc_spawnAllAnomalyFields", 2];
        };
    };
}];
// --- Cycle/Manager Actions ---
player addAction ["<t color='#0000ff'>Cycle Anomaly Fields</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_anomalies_fnc_cycleAnomalyFields;
    } else {
        [] remoteExec ["viceroy_stalker_alife_anomalies_fnc_cycleAnomalyFields", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Mutant Group</t>", {
    if (isServer) then {
        [getPos player] call viceroy_stalker_alife_mutants_fnc_spawnMutantGroup;
    } else {
        [getPos player] remoteExec ["viceroy_stalker_alife_mutants_fnc_spawnMutantGroup", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Spook Zone</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_spooks_fnc_spawnSpookZone;
    } else {
        [] remoteExec ["viceroy_stalker_alife_spooks_fnc_spawnSpookZone", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Zombies From Queue</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_zombification_fnc_spawnZombiesFromQueue;
    } else {
        [] remoteExec ["viceroy_stalker_alife_zombification_fnc_spawnZombiesFromQueue", 2];
    };
}];
player addAction ["<t color='#ff0000'>Trigger Necroplague</t>", {
    private _z = ["VSA_necroZombies",5] call viceroy_stalker_alife_cba_fnc_getSetting;
    private _h = ["VSA_necroHordes",2] call viceroy_stalker_alife_cba_fnc_getSetting;
    if (isServer) then {
        [_z, _h, true] call viceroy_stalker_alife_necroplague_fnc_triggerNecroplague;
    } else {
        [_z, _h, true] remoteExec ["viceroy_stalker_alife_necroplague_fnc_triggerNecroplague", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Ambient Herds</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_mutants_fnc_spawnAmbientHerds;
    } else {
        [] remoteExec ["viceroy_stalker_alife_mutants_fnc_spawnAmbientHerds", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Ambient Stalkers</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_stalkers_fnc_spawnAmbientStalkers;
    } else {
        [] remoteExec ["viceroy_stalker_alife_stalkers_fnc_spawnAmbientStalkers", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Stalker Camps</t>", {
    if (isServer) then {
        [getPos player, 300] call viceroy_stalker_alife_stalkers_fnc_spawnStalkerCamps;
    } else {
        [getPos player, 300] remoteExec ["viceroy_stalker_alife_stalkers_fnc_spawnStalkerCamps", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Sniper</t>", {
    if (isServer) then {
        [getPos player] call viceroy_stalker_alife_stalkers_fnc_spawnSniper;
    } else {
        [getPos player] remoteExec ["viceroy_stalker_alife_stalkers_fnc_spawnSniper", 2];
    };
}];
player addAction ["<t color='#ff0000'>DEBUG: Force Generate Snipers</t>", {
    if (isServer) then {
        [player] call viceroy_stalker_alife_stalkers_fnc_debugSpawnSnipers;
    } else {
        [player] remoteExec ["viceroy_stalker_alife_stalkers_fnc_debugSpawnSnipers", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Predator Attack</t>", {
    if (isServer) then {
        [player] call viceroy_stalker_alife_mutants_fnc_spawnPredatorAttack;
    } else {
        [player] remoteExec ["viceroy_stalker_alife_mutants_fnc_spawnPredatorAttack", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Habitat Hunters</t>", {
    if (isServer) then {
        [player] call viceroy_stalker_alife_mutants_fnc_spawnHabitatHunters;
    } else {
        [player] remoteExec ["viceroy_stalker_alife_mutants_fnc_spawnHabitatHunters", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Minefields</t>", {
    private _center = [worldSize / 2, worldSize / 2, 0];
    private _radius = worldSize;
    if (isServer) then {
        [_center, _radius] call viceroy_stalker_alife_minefields_fnc_spawnMinefields;
    } else {
        [_center, _radius] remoteExec ["viceroy_stalker_alife_minefields_fnc_spawnMinefields", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn IED Sites</t>", {
    if (isServer) then {
        [getPos player, 300] call viceroy_stalker_alife_minefields_fnc_spawnIEDSites;
    } else {
        [getPos player, 300] remoteExec ["viceroy_stalker_alife_minefields_fnc_spawnIEDSites", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Booby Traps</t>", {
    if (isServer) then {
        [getPos player, 200] call viceroy_stalker_alife_minefields_fnc_spawnBoobyTraps;
    } else {
        [getPos player, 200] remoteExec ["viceroy_stalker_alife_minefields_fnc_spawnBoobyTraps", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Ambush</t>", {
    if (isServer) then {
        [getPos player, 300] call viceroy_stalker_alife_ambushes_fnc_spawnAmbushes;
    } else {
        [getPos player, 300] remoteExec ["viceroy_stalker_alife_ambushes_fnc_spawnAmbushes", 2];
    };
}];
player addAction ["<t color='#0000ff'>Cycle Habitats</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_mutants_fnc_manageHabitats;
    } else {
        [] remoteExec ["viceroy_stalker_alife_mutants_fnc_manageHabitats", 2];
    };
}];
player addAction ["<t color='#0000ff'>Trigger AI Panic</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_ai_fnc_triggerAIPanic;
    } else {
        [] remoteExec ["viceroy_stalker_alife_ai_fnc_triggerAIPanic", 2];
    };
}];
player addAction ["<t color='#0000ff'>Reset AI Behaviour</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_ai_fnc_resetAIBehavior;
    } else {
        [] remoteExec ["viceroy_stalker_alife_ai_fnc_resetAIBehavior", 2];
    };
}];
player addAction ["<t color='#0000ff'>Toggle Field Avoidance</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_ai_fnc_toggleFieldAvoid;
    } else {
        [] remoteExec ["viceroy_stalker_alife_ai_fnc_toggleFieldAvoid", 2];
    };
}];
// --- Cache Actions ---
player addAction ["<t color='#ffff00'>Cache Map Wrecks</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_wrecks_fnc_findWrecks;
    } else {
        [] remoteExec ["viceroy_stalker_alife_wrecks_fnc_findWrecks", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Sniper Spots</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_findSniperSpots;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findSniperSpots", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Roads</t>", {
    if (isServer) then {
        private _data = ["STALKER_roads"] call viceroy_stalker_alife_cache_fnc_loadCache;
        if (isNil {_data}) then {
            _data = [] call viceroy_stalker_alife_core_fnc_findRoads;
            ["STALKER_roads", _data] call viceroy_stalker_alife_cache_fnc_saveCache;
        };
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findRoads", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Crossroads</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_findCrossroads;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findCrossroads", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Bridges</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_findBridges;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findBridges", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Valleys</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_findValleys;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findValleys", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Beach Spots</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_findBeachesInMap;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findBeachesInMap", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Swamps</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_findSwamps;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findSwamps", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Land Zones</t>", {
    if (isServer) then {
        private _data = ["STALKER_landZones"] call viceroy_stalker_alife_cache_fnc_loadCache;
        if (isNil {_data}) then {
            _data = [] call viceroy_stalker_alife_core_fnc_findLandZones;
            ["STALKER_landZones", _data] call viceroy_stalker_alife_cache_fnc_saveCache;
        };
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_findLandZones", 2];
    };
}];

player addAction ["<t color='#ffff00'>Place Cached Markers</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_cache_fnc_placeCachedMarkers;
    } else {
        [] remoteExec ["viceroy_stalker_alife_cache_fnc_placeCachedMarkers", 2];
    };
}];

player addAction ["<t color='#00ff00'>Regenerate Map Points</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_core_fnc_regenMapPoints;
    } else {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_regenMapPoints", 2];
    };
}];

player addAction ["<t color='#00ff00'>Load Cache and Init Managers</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_init_fnc_initMap;
        [] call viceroy_stalker_alife_init_fnc_initManagers;
    } else {
        [] remoteExec ["viceroy_stalker_alife_init_fnc_initMap", 2];
        [] remoteExec ["viceroy_stalker_alife_init_fnc_initManagers", 2];
    };
}];


// --- Diagnostic overlays ---
player addAction ["<t color='#00ff0f'>Toggle Site Overlay</t>", {
    if (isServer) then {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_toggleSiteOverlay", 2];
    } else {
        [] call viceroy_stalker_alife_core_fnc_toggleSiteOverlay;
    };
}];
player addAction ["<t color='#00ff0f'>Toggle Perf Metrics (chat)</t>", {
    if (isServer) then {
        [] remoteExec ["viceroy_stalker_alife_core_fnc_togglePerfMetrics", 2];
    } else {
        [] call viceroy_stalker_alife_core_fnc_togglePerfMetrics;
    };
}];
player addAction ["<t color='#00ff0f'>Resync Server State</t>", {
    if (isServer) then {
        [] call viceroy_stalker_alife_server_fnc_sendServerState;
    } else {
        [] call viceroy_stalker_alife_server_fnc_requestServerState;
    };
}];

true
