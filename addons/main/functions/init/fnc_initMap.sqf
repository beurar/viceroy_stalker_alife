#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Caches all map positions required by STALKER ALife systems.
*/



if (!isServer) exitWith { false };

// Load cached data when available to avoid expensive scans
// Note: Road caching (STALKER_roads) removed in favor of dynamic 'nearRoads' checks

// Land zones are optional but load if present
private _zones = ["STALKER_landZones"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (!isNil {_zones} && {_zones isEqualType [] && {count _zones == 0}}) then {
    _zones = [] call viceroy_stalker_alife_core_fnc_findLandZones;
    ["STALKER_landZones", _zones] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _rockClusters = ["STALKER_rockClusters"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_rockClusters} || {_rockClusters isEqualTo []}) then {
    _rockClusters = [] call viceroy_stalker_alife_core_fnc_findRockClusters;
    ["STALKER_rockClusters", _rockClusters] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _sniperSpots = ["STALKER_sniperSpots"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_sniperSpots} || {_sniperSpots isEqualTo []}) then {
    _sniperSpots = [] call viceroy_stalker_alife_core_fnc_findSniperSpots;
    ["STALKER_sniperSpots", _sniperSpots] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _swamps = ["STALKER_swamps"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_swamps} || {_swamps isEqualTo []}) then {
    _swamps = [] call viceroy_stalker_alife_core_fnc_findSwamps;
    ["STALKER_swamps", _swamps] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _beaches = ["STALKER_beachSpots"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_beaches} || {_beaches isEqualTo []}) then {
    _beaches = [] call viceroy_stalker_alife_core_fnc_findBeachesInMap;
    ["STALKER_beachSpots", _beaches] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _valleys = ["STALKER_valleys"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_valleys} || {_valleys isEqualTo []}) then {
    _valleys = [] call viceroy_stalker_alife_core_fnc_findValleys;
    ["STALKER_valleys", _valleys] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _bridges = ["STALKER_bridges"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_bridges} || {_bridges isEqualTo []}) then {
    _bridges = [] call viceroy_stalker_alife_core_fnc_findBridges;
    ["STALKER_bridges", _bridges] call viceroy_stalker_alife_cache_fnc_saveCache;
};

private _crossroads = ["STALKER_crossroads"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_crossroads} || {_crossroads isEqualTo []}) then {
    _crossroads = [] call viceroy_stalker_alife_core_fnc_findCrossroads;
    ["STALKER_crossroads", _crossroads] call viceroy_stalker_alife_cache_fnc_saveCache;
};

// Building clusters are cached as arrays of positions
private _bClusterPositions = ["STALKER_buildingClusters"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_bClusterPositions} || {_bClusterPositions isEqualTo []}) then {
    _bClusterPositions = [] call viceroy_stalker_alife_core_fnc_findBuildingClusters;
    ["STALKER_buildingClusters", _bClusterPositions] call viceroy_stalker_alife_cache_fnc_saveCache;
}; 

private _wreckPositions = ["STALKER_wreckPositions"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_wreckPositions} || {_wreckPositions isEqualTo []}) then {
    _wreckPositions = [] call viceroy_stalker_alife_wrecks_fnc_findWrecks;
    ["STALKER_wreckPositions", _wreckPositions] call viceroy_stalker_alife_cache_fnc_saveCache;
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
private _habData = ["STALKER_mutantHabitatData"] call viceroy_stalker_alife_cache_fnc_loadCache;
if (isNil {_habData} || {_habData isEqualTo []}) then {
    [] call viceroy_stalker_alife_mutants_fnc_setupMutantHabitats;
    _habData = missionNamespace getVariable ["STALKER_mutantHabitatData", []];
    ["STALKER_mutantHabitatData", _habData] call viceroy_stalker_alife_cache_fnc_saveCache;
} else {
    [_habData] call viceroy_stalker_alife_mutants_fnc_spawnCachedHabitats;
};

// Automatically display cached points when debug mode is active
if (["VSA_debugMode", false] call viceroy_stalker_alife_cba_fnc_getSetting) then {
    // Marker autogeneration disabled in production. Use placeCachedMarkers for debugging.
};

"STALKER ALife initialization complete" remoteExec ["hint", 0];

true
