#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Caches all map positions required by STALKER ALife systems.
*/



if (!isServer) exitWith { false };

// Load cached data when available to avoid expensive scans
// Note: Road caching (STALKER_roads) removed in favor of dynamic 'nearRoads' checks

// Land zones are optional but load if present
private _zones = ["STALKER_landZones"] call FUNC(loadCache);
if (!isNil {_zones} && {_zones isEqualType [] && {count _zones == 0}}) then {
    _zones = [] call FUNC(findLandZones);
    ["STALKER_landZones", _zones] call FUNC(saveCache);
};

private _rockClusters = ["STALKER_rockClusters"] call FUNC(loadCache);
if (isNil {_rockClusters} || {_rockClusters isEqualTo []}) then {
    _rockClusters = [] call FUNC(findRockClusters);
    ["STALKER_rockClusters", _rockClusters] call FUNC(saveCache);
};

private _sniperSpots = ["STALKER_sniperSpots"] call FUNC(loadCache);
if (isNil {_sniperSpots} || {_sniperSpots isEqualTo []}) then {
    _sniperSpots = [] call FUNC(findSniperSpots);
    ["STALKER_sniperSpots", _sniperSpots] call FUNC(saveCache);
};

private _swamps = ["STALKER_swamps"] call FUNC(loadCache);
if (isNil {_swamps} || {_swamps isEqualTo []}) then {
    _swamps = [] call FUNC(findSwamps);
    ["STALKER_swamps", _swamps] call FUNC(saveCache);
};

private _beaches = ["STALKER_beachSpots"] call FUNC(loadCache);
if (isNil {_beaches} || {_beaches isEqualTo []}) then {
    _beaches = [] call FUNC(findBeachesInMap);
    ["STALKER_beachSpots", _beaches] call FUNC(saveCache);
};

private _valleys = ["STALKER_valleys"] call FUNC(loadCache);
if (isNil {_valleys} || {_valleys isEqualTo []}) then {
    _valleys = [] call FUNC(findValleys);
    ["STALKER_valleys", _valleys] call FUNC(saveCache);
};

private _bridges = ["STALKER_bridges"] call FUNC(loadCache);
if (isNil {_bridges} || {_bridges isEqualTo []}) then {
    _bridges = [] call FUNC(findBridges);
    ["STALKER_bridges", _bridges] call FUNC(saveCache);
};

private _crossroads = ["STALKER_crossroads"] call FUNC(loadCache);
if (isNil {_crossroads} || {_crossroads isEqualTo []}) then {
    _crossroads = [] call FUNC(findCrossroads);
    ["STALKER_crossroads", _crossroads] call FUNC(saveCache);
};

// Building clusters are cached as arrays of positions
private _bClusterPositions = ["STALKER_buildingClusters"] call FUNC(loadCache);
if (isNil {_bClusterPositions} || {_bClusterPositions isEqualTo []}) then {
    _bClusterPositions = [] call FUNC(findBuildingClusters);
    ["STALKER_buildingClusters", _bClusterPositions] call FUNC(saveCache);
}; 

private _wreckPositions = ["STALKER_wreckPositions"] call FUNC(loadCache);
if (isNil {_wreckPositions} || {_wreckPositions isEqualTo []}) then {
    _wreckPositions = [] call FUNC(findWrecks);
    ["STALKER_wreckPositions", _wreckPositions] call FUNC(saveCache);
};
if (isNil "STALKER_wrecks") then { STALKER_wrecks = []; };
{
    private _near = nearestObjects [_x, ["AllVehicles","Static"], 5];
    {
        private _type = toLower typeOf _x;
        private _model = toLower ((getModelInfo _x) select 0);
        if (("wreck" in _type) || { "wrecks" in _model }) exitWith {
            STALKER_wrecks pushBackUnique _x;
        };
    } forEach _near;
} forEach _wreckPositions;

// Load or generate mutant habitats
private _habData = ["STALKER_mutantHabitatData"] call FUNC(loadCache);
if (isNil {_habData} || {_habData isEqualTo []}) then {
    [] call FUNC(setupMutantHabitats);
    _habData = missionNamespace getVariable ["STALKER_mutantHabitatData", []];
    ["STALKER_mutantHabitatData", _habData] call FUNC(saveCache);
} else {
    [_habData] call FUNC(spawnCachedHabitats);
};

// Automatically display cached points when debug mode is active
if (["VSA_debugMode", false] call FUNC(getSetting)) then {
    // Marker autogeneration disabled in production. Use placeCachedMarkers for debugging.
};

"STALKER ALife initialization complete" remoteExec ["hint", 0];

true
