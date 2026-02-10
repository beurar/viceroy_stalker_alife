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
    private _dur = ["VSA_stormDuration", 180] call FUNC(getSetting);
    private _lStart = ["VSA_stormLightningStart", 6] call FUNC(getSetting);
    private _lEnd   = ["VSA_stormLightningEnd", 12] call FUNC(getSetting);
    private _dStart = ["VSA_stormDischargeStart", 6] call FUNC(getSetting);
    private _dEnd   = ["VSA_stormDischargeEnd", 12] call FUNC(getSetting);
    if (isServer) then {
        [_dur, _lStart, _lEnd, _dStart, _dEnd] call FUNC(triggerPsyStorm);
    } else {
        [_dur, _lStart, _lEnd, _dStart, _dEnd] remoteExec ["FUNC(triggerPsyStorm)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Trigger Blowout</t>", {
    if (isServer) then {
        [] call FUNC(triggerBlowout);
    } else {
        [] remoteExec ["FUNC(triggerBlowout)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Chemical Zone</t>", {
    if (isServer) then {
        [getPos player, 100] call FUNC(spawnChemicalZone);
    } else {
        [getPos player, 100] remoteExec ["FUNC(spawnChemicalZone)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Random Chemicals</t>", {
    if (isServer) then {
        [getPos player, 200] call FUNC(spawnRandomChemicalZones);
    } else {
        [getPos player, 200] remoteExec ["FUNC(spawnRandomChemicalZones)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Valley Chemicals</t>", {
    if (isServer) then {
        [] call FUNC(spawnValleyChemicalFields);
    } else {
        [] remoteExec ["FUNC(spawnValleyChemicalFields)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Stable Fields</t>", {
    for "_i" from 1 to 100 do {
        private _pos = [random worldSize, random worldSize, 0];
        if (isServer) then {
            [_pos, 1000, 1] call FUNC(spawnAllAnomalyFields);
        } else {
            [_pos, 1000, 1] remoteExec ["FUNC(spawnAllAnomalyFields)", 2];
        };
    };
}];
player addAction ["<t color='#ff0000'>Spawn Unstable Fields</t>", {
    for "_i" from 1 to 100 do {
        private _pos = [random worldSize, random worldSize, 0];
        if (isServer) then {
            [_pos, 1000, 0] call FUNC(spawnAllAnomalyFields);
        } else {
            [_pos, 1000, 0] remoteExec ["FUNC(spawnAllAnomalyFields)", 2];
        };
    };
}];
// --- Cycle/Manager Actions ---
player addAction ["<t color='#0000ff'>Cycle Anomaly Fields</t>", {
    if (isServer) then {
        [] call FUNC(cycleAnomalyFields);
    } else {
        [] remoteExec ["FUNC(cycleAnomalyFields)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Mutant Group</t>", {
    if (isServer) then {
        [getPos player] call FUNC(spawnMutantGroup);
    } else {
        [getPos player] remoteExec ["FUNC(spawnMutantGroup)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Spook Zone</t>", {
    if (isServer) then {
        [] call FUNC(spawnSpookZone);
    } else {
        [] remoteExec ["FUNC(spawnSpookZone)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Zombies From Queue</t>", {
    if (isServer) then {
        [] call FUNC(spawnZombiesFromQueue);
    } else {
        [] remoteExec ["FUNC(spawnZombiesFromQueue)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Trigger Necroplague</t>", {
    private _z = ["VSA_necroZombies",5] call FUNC(getSetting);
    private _h = ["VSA_necroHordes",2] call FUNC(getSetting);
    if (isServer) then {
        [_z, _h, true] call FUNC(triggerNecroplague);
    } else {
        [_z, _h, true] remoteExec ["FUNC(triggerNecroplague)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Ambient Herds</t>", {
    if (isServer) then {
        [] call FUNC(spawnAmbientHerds);
    } else {
        [] remoteExec ["FUNC(spawnAmbientHerds)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Ambient Stalkers</t>", {
    if (isServer) then {
        [] call FUNC(spawnAmbientStalkers);
    } else {
        [] remoteExec ["FUNC(spawnAmbientStalkers)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Stalker Camps</t>", {
    if (isServer) then {
        [getPos player, 300] call FUNC(spawnStalkerCamps);
    } else {
        [getPos player, 300] remoteExec ["FUNC(spawnStalkerCamps)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Sniper</t>", {
    if (isServer) then {
        [getPos player] call FUNC(spawnSniper);
    } else {
        [getPos player] remoteExec ["FUNC(spawnSniper)", 2];
    };
}];
player addAction ["<t color='#ff0000'>DEBUG: Force Generate Snipers</t>", {
    if (isServer) then {
        [player] call FUNC(debugSpawnSnipers);
    } else {
        [player] remoteExec ["FUNC(debugSpawnSnipers)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Predator Attack</t>", {
    if (isServer) then {
        [player] call FUNC(spawnPredatorAttack);
    } else {
        [player] remoteExec ["FUNC(spawnPredatorAttack)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Habitat Hunters</t>", {
    if (isServer) then {
        [player] call FUNC(spawnHabitatHunters);
    } else {
        [player] remoteExec ["FUNC(spawnHabitatHunters)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Minefields</t>", {
    private _center = [worldSize / 2, worldSize / 2, 0];
    private _radius = worldSize;
    if (isServer) then {
        [_center, _radius] call FUNC(spawnMinefields);
    } else {
        [_center, _radius] remoteExec ["FUNC(spawnMinefields)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn IED Sites</t>", {
    if (isServer) then {
        [getPos player, 300] call FUNC(spawnIEDSites);
    } else {
        [getPos player, 300] remoteExec ["FUNC(spawnIEDSites)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Booby Traps</t>", {
    if (isServer) then {
        [getPos player, 200] call FUNC(spawnBoobyTraps);
    } else {
        [getPos player, 200] remoteExec ["FUNC(spawnBoobyTraps)", 2];
    };
}];
player addAction ["<t color='#ff0000'>Spawn Ambush</t>", {
    if (isServer) then {
        [getPos player, 300] call FUNC(spawnAmbushes);
    } else {
        [getPos player, 300] remoteExec ["FUNC(spawnAmbushes)", 2];
    };
}];
player addAction ["<t color='#0000ff'>Cycle Habitats</t>", {
    if (isServer) then {
        [] call FUNC(manageHabitats);
    } else {
        [] remoteExec ["FUNC(manageHabitats)", 2];
    };
}];
player addAction ["<t color='#0000ff'>Trigger AI Panic</t>", {
    if (isServer) then {
        [] call FUNC(triggerAIPanic);
    } else {
        [] remoteExec ["FUNC(triggerAIPanic)", 2];
    };
}];
player addAction ["<t color='#0000ff'>Reset AI Behaviour</t>", {
    if (isServer) then {
        [] call FUNC(resetAIBehavior);
    } else {
        [] remoteExec ["FUNC(resetAIBehavior)", 2];
    };
}];
player addAction ["<t color='#0000ff'>Toggle Field Avoidance</t>", {
    if (isServer) then {
        [] call FUNC(toggleFieldAvoid);
    } else {
        [] remoteExec ["FUNC(toggleFieldAvoid)", 2];
    };
}];
// --- Cache Actions ---
player addAction ["<t color='#ffff00'>Cache Map Wrecks</t>", {
    if (isServer) then {
        [] call FUNC(findWrecks);
    } else {
        [] remoteExec ["FUNC(findWrecks)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Sniper Spots</t>", {
    if (isServer) then {
        [] call FUNC(findSniperSpots);
    } else {
        [] remoteExec ["FUNC(findSniperSpots)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Roads</t>", {
    if (isServer) then {
        private _data = ["STALKER_roads"] call FUNC(loadCache);
        if (isNil {_data}) then {
            _data = [] call FUNC(findRoads);
            ["STALKER_roads", _data] call FUNC(saveCache);
        };
    } else {
        [] remoteExec ["FUNC(findRoads)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Crossroads</t>", {
    if (isServer) then {
        [] call FUNC(findCrossroads);
    } else {
        [] remoteExec ["FUNC(findCrossroads)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Bridges</t>", {
    if (isServer) then {
        [] call FUNC(findBridges);
    } else {
        [] remoteExec ["FUNC(findBridges)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Valleys</t>", {
    if (isServer) then {
        [] call FUNC(findValleys);
    } else {
        [] remoteExec ["FUNC(findValleys)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Beach Spots</t>", {
    if (isServer) then {
        [] call FUNC(findBeachesInMap);
    } else {
        [] remoteExec ["FUNC(findBeachesInMap)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Swamps</t>", {
    if (isServer) then {
        [] call FUNC(findSwamps);
    } else {
        [] remoteExec ["FUNC(findSwamps)", 2];
    };
}];
player addAction ["<t color='#ffff00'>Cache Land Zones</t>", {
    if (isServer) then {
        private _data = ["STALKER_landZones"] call FUNC(loadCache);
        if (isNil {_data}) then {
            _data = [] call FUNC(findLandZones);
            ["STALKER_landZones", _data] call FUNC(saveCache);
        };
    } else {
        [] remoteExec ["FUNC(findLandZones)", 2];
    };
}];

player addAction ["<t color='#ffff00'>Place Cached Markers</t>", {
    if (isServer) then {
        [] call FUNC(placeCachedMarkers);
    } else {
        [] remoteExec ["FUNC(placeCachedMarkers)", 2];
    };
}];

player addAction ["<t color='#00ff00'>Regenerate Map Points</t>", {
    if (isServer) then {
        [] call FUNC(regenMapPoints);
    } else {
        [] remoteExec ["FUNC(regenMapPoints)", 2];
    };
}];

player addAction ["<t color='#00ff00'>Load Cache and Init Managers</t>", {
    if (isServer) then {
        [] call FUNC(initMap);
        [] call FUNC(initManagers);
    } else {
        [] remoteExec ["FUNC(initMap)", 2];
        [] remoteExec ["FUNC(initManagers)", 2];
    };
}];


// --- Diagnostic overlays ---
player addAction ["<t color='#00ff0f'>Toggle Site Overlay</t>", {
    if (isServer) then {
        [] remoteExec ["FUNC(toggleSiteOverlay)", 2];
    } else {
        [] call FUNC(toggleSiteOverlay);
    };
}];
player addAction ["<t color='#00ff0f'>Toggle Perf Metrics (chat)</t>", {
    if (isServer) then {
        [] remoteExec ["FUNC(togglePerfMetrics)", 2];
    } else {
        [] call FUNC(togglePerfMetrics);
    };
}];
player addAction ["<t color='#00ff0f'>Resync Server State</t>", {
    if (isServer) then {
        [] call FUNC(sendServerState);
    } else {
        [] call FUNC(requestServerState);
    };
}];

true
