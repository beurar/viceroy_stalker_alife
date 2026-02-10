#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Rebuilds all map points from scratch and caches the results.
*/


if (!isServer) exitWith { false };

private _roads = [] call FUNC(findRoads);
["STALKER_roads", _roads] call FUNC(saveCache);

private _zones = [] call FUNC(findLandZones);
["STALKER_landZones", _zones] call FUNC(saveCache);

private _rockClusters = [] call FUNC(findRockClusters);
["STALKER_rockClusters", _rockClusters] call FUNC(saveCache);

private _sniperSpots = [] call FUNC(findSniperSpots);
["STALKER_sniperSpots", _sniperSpots] call FUNC(saveCache);

private _swamps = [] call FUNC(findSwamps);
["STALKER_swamps", _swamps] call FUNC(saveCache);

private _beaches = [] call FUNC(findBeachesInMap);
["STALKER_beachSpots", _beaches] call FUNC(saveCache);

private _valleys = [] call FUNC(findValleys);
["STALKER_valleys", _valleys] call FUNC(saveCache);

private _bridges = [] call FUNC(findBridges);
["STALKER_bridges", _bridges] call FUNC(saveCache);

private _crossroads = [] call FUNC(findCrossroads);
["STALKER_crossroads", _crossroads] call FUNC(saveCache);

private _bClusters = [] call FUNC(findBuildingClusters);
["STALKER_buildingClusters", _bClusters] call FUNC(saveCache);

private _wreckPositions = [] call FUNC(findWrecks);
["STALKER_wreckPositions", _wreckPositions] call FUNC(saveCache);

"Map points regenerated" remoteExec ["hint", 0];

true
