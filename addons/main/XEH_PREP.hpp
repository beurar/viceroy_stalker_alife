// ai
SUBPREP(ai,avoidAnomalies);
SUBPREP(ai,avoidAnomalyFields);
SUBPREP(ai,resetAIBehavior);
SUBPREP(ai,toggleFieldAvoid);
SUBPREP(ai,triggerAIPanic);

//// ambushes
SUBPREP(ambushes,manageAmbushes);
SUBPREP(ambushes,spawnAmbushes);
SUBPREP(ambushes,startAmbushManager);

//// anomalies
SUBPREP(anomalies,activateSite);
SUBPREP(anomalies,cleanupAnomalyMarkers);
SUBPREP(anomalies,cycleAnomalyFields);
SUBPREP(anomalies,deactivateSite);
SUBPREP(anomalies,generateFieldName);
SUBPREP(anomalies,manageAnomalyFields);
SUBPREP(anomalies,setupAnomalyFields);
SUBPREP(anomalies,spawnAllAnomalyFields);
SUBPREP(anomalies,spawnBridgeAnomalyFields);
SUBPREP(anomalies,startAnomalyManager);

//// antistasi
SUBPREP(antistasi,completeArtefactHunt);
SUBPREP(antistasi,completeChemSample);
SUBPREP(antistasi,disableWeather);
SUBPREP(antistasi,isAntistasiUltimate);
SUBPREP(antistasi,startArtefactHunt);
SUBPREP(antistasi,startChemSample);
SUBPREP(antistasi,startMutantHunt);
SUBPREP(antistasi,defendTownFromZombies);
SUBPREP(antistasi,startDefendTownFromZombies);
SUBPREP(antistasi,manageAntistasiEvents);

//// blowouts
SUBPREP(blowouts,placeTownSirens);
SUBPREP(blowouts,scheduleBlowouts);
SUBPREP(blowouts,triggerBlowout);
SUBPREP(blowouts,onEmissionBuildUp);
SUBPREP(blowouts,onEmissionEnd);
SUBPREP(blowouts,onEmissionStart);

//// cache
SUBPREP(cache,saveCache);
SUBPREP(cache,loadCache);
SUBPREP(cache,placeCachedMarkers);

//// cba
SUBPREP(cba,getSetting);

//// chemical
SUBPREP(chemical,activateSite);
SUBPREP(chemical,cleanupChemicalZones);
SUBPREP(chemical,deactivateSite);
SUBPREP(chemical,expandValley);
SUBPREP(chemical,findValleyPosition);
SUBPREP(chemical,manageChemicalZones);
SUBPREP(chemical,onEmissionEnd);
SUBPREP(chemical,onEmissionStart);
SUBPREP(chemical,spawnChemicalZone);
SUBPREP(chemical,spawnRandomChemicalZones);
SUBPREP(chemical,spawnValleyChemicalFields);
SUBPREP(chemical,spawnValleyChemicalZones);

//// core
SUBPREP(core,createProximityAnchor);
SUBPREP(core,evalSiteProximity);
SUBPREP(core,findBeachesInMap);
SUBPREP(core,findBridges);
SUBPREP(core,findBuildingClusters);
SUBPREP(core,findBuildingCoverSpot);
SUBPREP(core,findCrossroads);
SUBPREP(core,findHiddenPosition);
SUBPREP(core,findLandPos);
SUBPREP(core,findLandPosition);
SUBPREP(core,findLandZones);
SUBPREP(core,findRandomRoadPosition);
SUBPREP(core,findRoadPosition);
SUBPREP(core,findRoads);
SUBPREP(core,findRockClusters);
SUBPREP(core,findSniperSpots);
SUBPREP(core,findSwamps);
SUBPREP(core,findValleys);
SUBPREP(core,getActiveCellsNearPlayers);
SUBPREP(core,getLandSurfacePosition);
SUBPREP(core,getRandomRoad);
SUBPREP(core,getSurfacePosition);
SUBPREP(core,hasPlayersNearby);
SUBPREP(core,isWaterPosition);
SUBPREP(core,radioMessage);
SUBPREP(core,regenMapPoints);
SUBPREP(core,registerEmissionHooks);
SUBPREP(core,selectWeightedBuilding);
SUBPREP(core,setupDebugActions);
SUBPREP(core,spawnWorker);
SUBPREP(core,togglePerfMetrics);
SUBPREP(core,toggleSiteOverlay);
SUBPREP(core,weightedPick);

//// init
SUBPREP(init,initManagers);
SUBPREP(init,initMap);

//// markers
SUBPREP(markers,createGlobalMarker);
SUBPREP(markers,createLocalMarker);
SUBPREP(markers,markAllBuildings);
SUBPREP(markers,markBeaches);
SUBPREP(markers,markBridges);
SUBPREP(markers,markBuildingClusters);
SUBPREP(markers,markBuildingCoverSpot);
SUBPREP(markers,markDeathLocation);
SUBPREP(markers,markHiddenPosition);
SUBPREP(markers,markLandZones);
SUBPREP(markers,markPlayerRanges);
SUBPREP(markers,markRoads);
SUBPREP(markers,markRockClusters);
SUBPREP(markers,markSitesOverlay);
SUBPREP(markers,markSniperSpots);
SUBPREP(markers,markSwamps);
SUBPREP(markers,markValleys);

//// minefields
SUBPREP(minefields,activateSite);
SUBPREP(minefields,deactivateSite);
SUBPREP(minefields,manageBoobyTraps);
SUBPREP(minefields,manageIEDSites);
SUBPREP(minefields,manageMinefields);
SUBPREP(minefields,registerMinefield);
SUBPREP(minefields,spawnAPERSField);
SUBPREP(minefields,spawnBoobyTraps);
SUBPREP(minefields,spawnIED);
SUBPREP(minefields,spawnIEDSites);
SUBPREP(minefields,spawnMinefieldQueued);
SUBPREP(minefields,spawnMinefields);
SUBPREP(minefields,spawnTripwirePerimeter);
SUBPREP(minefields,startIEDManager);
SUBPREP(minefields,startMinefieldManager);

//// mutants
SUBPREP(mutants,initMutantUnit);
SUBPREP(mutants,isMutantEnabled);
SUBPREP(mutants,manageHabitats);
SUBPREP(mutants,manageHerds);
SUBPREP(mutants,manageHostiles);
SUBPREP(mutants,manageNests);
SUBPREP(mutants,managePredators);
SUBPREP(mutants,onEmissionEnd);
SUBPREP(mutants,onEmissionStart);
SUBPREP(mutants,onMutantKilled);
SUBPREP(mutants,setupMutantHabitats);
SUBPREP(mutants,spawnAcidSmasherNest);
SUBPREP(mutants,spawnAmbientHerds);
SUBPREP(mutants,spawnBehemothNest);
SUBPREP(mutants,spawnBlindDogNest);
SUBPREP(mutants,spawnBloodsuckerNest);
SUBPREP(mutants,spawnBoarNest);
SUBPREP(mutants,spawnCachedHabitats);
SUBPREP(mutants,spawnCatNest);
SUBPREP(mutants,spawnControllerNest);
SUBPREP(mutants,spawnCorruptorNest);
SUBPREP(mutants,spawnFleshNest);
SUBPREP(mutants,spawnHabitatHunters);
SUBPREP(mutants,spawnIzlomNest);
SUBPREP(mutants,spawnMutantGroup);
SUBPREP(mutants,spawnMutantNest);
SUBPREP(mutants,spawnPredatorAttack);
SUBPREP(mutants,spawnPseudodogNest);
SUBPREP(mutants,spawnPseudogiantNest);
SUBPREP(mutants,spawnSmasherNest);
SUBPREP(mutants,spawnSnorkNest);
SUBPREP(mutants,updateProximity);

//// necroplague
SUBPREP(necroplague,scheduleNecroplague);
SUBPREP(necroplague,triggerNecroplague);

//// panic
SUBPREP(panic,onEmissionBuildUp);
SUBPREP(panic,onEmissionEnd);
SUBPREP(panic,onEmissionStart);

//// spooks
SUBPREP(spooks,manageSpookZones);
SUBPREP(spooks,setupSpookZones);
SUBPREP(spooks,spawnSpookZone);

//// stalkers
SUBPREP(stalkers,findCampBuilding);
SUBPREP(stalkers,findDynamicSniperSpots);
SUBPREP(stalkers,debugSpawnSnipers);
SUBPREP(stalkers,getStalkerFactions);
SUBPREP(stalkers,manageSnipers);
SUBPREP(stalkers,sniperAssaultLogic);
SUBPREP(stalkers,manageStalkerCamps);
SUBPREP(stalkers,manageWanderers);
SUBPREP(stalkers,spawnAmbientStalkers);
SUBPREP(stalkers,spawnFlareTripwires);
SUBPREP(stalkers,spawnSmartFlarePerimeter);
SUBPREP(stalkers,spawnSniper);
SUBPREP(stalkers,sniperScan);
SUBPREP(stalkers,spawnStalkerCamp);
SUBPREP(stalkers,spawnStalkerCamps);
SUBPREP(stalkers,startCampManager);
SUBPREP(stalkers,startSniperManager);

/// server
SUBPREP(server,applyServerState);
SUBPREP(server,callServer);
SUBPREP(server,callServerHelper);
SUBPREP(server,getServerMetrics);
SUBPREP(server,requestServerState);
SUBPREP(server,remoteReturn);
SUBPREP(server,sendServerState);

//// smart_terrains
SUBPREP(smart_terrains,scanMap);
SUBPREP(smart_terrains,findVantagePoints);

//// storms
SUBPREP(storms,schedulePsyStorms);
SUBPREP(storms,triggerPsyStorm);

//// wrecks
SUBPREP(wrecks,findWrecks);
SUBPREP(wrecks,manageWrecks);
SUBPREP(wrecks,markWrecks);
SUBPREP(wrecks,spawnAbandonedVehicles);

//// zombification
SUBPREP(zombification,onEmissionEnd);
SUBPREP(zombification,spawnZombiesFromQueue);
SUBPREP(zombification,trackDeadForZombify);
