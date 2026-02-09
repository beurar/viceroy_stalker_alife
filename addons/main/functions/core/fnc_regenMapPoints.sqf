#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Rebuilds all map points from scratch and caches the results.
*/


if (!isServer) exitWith { false };

private _roads = [] call viceroy_stalker_alife_core_fnc_findRoads;
["STALKER_roads", _roads] call viceroy_stalker_alife_cache_fnc_saveCache;

private _zones = [] call viceroy_stalker_alife_core_fnc_findLandZones;
["STALKER_landZones", _zones] call viceroy_stalker_alife_cache_fnc_saveCache;

private _rockClusters = [] call viceroy_stalker_alife_core_fnc_findRockClusters;
["STALKER_rockClusters", _rockClusters] call viceroy_stalker_alife_cache_fnc_saveCache;

private _sniperSpots = [] call viceroy_stalker_alife_core_fnc_findSniperSpots;
["STALKER_sniperSpots", _sniperSpots] call viceroy_stalker_alife_cache_fnc_saveCache;

private _swamps = [] call viceroy_stalker_alife_core_fnc_findSwamps;
["STALKER_swamps", _swamps] call viceroy_stalker_alife_cache_fnc_saveCache;

private _beaches = [] call viceroy_stalker_alife_core_fnc_findBeachesInMap;
["STALKER_beachSpots", _beaches] call viceroy_stalker_alife_cache_fnc_saveCache;

private _valleys = [] call viceroy_stalker_alife_core_fnc_findValleys;
["STALKER_valleys", _valleys] call viceroy_stalker_alife_cache_fnc_saveCache;

private _bridges = [] call viceroy_stalker_alife_core_fnc_findBridges;
["STALKER_bridges", _bridges] call viceroy_stalker_alife_cache_fnc_saveCache;

private _crossroads = [] call viceroy_stalker_alife_core_fnc_findCrossroads;
["STALKER_crossroads", _crossroads] call viceroy_stalker_alife_cache_fnc_saveCache;

private _bClusters = [] call viceroy_stalker_alife_core_fnc_findBuildingClusters;
["STALKER_buildingClusters", _bClusters] call viceroy_stalker_alife_cache_fnc_saveCache;

private _wreckPositions = [] call viceroy_stalker_alife_wrecks_fnc_findWrecks;
["STALKER_wreckPositions", _wreckPositions] call viceroy_stalker_alife_cache_fnc_saveCache;

"Map points regenerated" remoteExec ["hint", 0];

true
