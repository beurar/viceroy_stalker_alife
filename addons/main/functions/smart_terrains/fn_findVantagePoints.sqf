#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Author: Viceroy
    Description:
    Finds high ground / vantage points in a given radius.
    Focuses purely on terrain elevation, not buildings.
    
    Arguments:
    0: ARRAY - Center Position
    1: NUMBER - Radius
    
    Return Value:
    ARRAY - List of positions
*/

params ["_center", "_radius"];

private _spots = [];
private _searchRadius = _radius;

// Use selectBestPlaces to find hills
private _terrainSpots = selectBestPlaces [_center, _searchRadius, "(2 * hills) + meadow - forest", 25, 20];

{
    _x params ["_pos", "_value"];
    _pos = [_pos select 0, _pos select 1];
    _pos set [2, 0];
    
    // Check elevation relative to center
    private _zCenter = getTerrainHeightASL _center;
    private _zSpot = getTerrainHeightASL _pos;
    
    if (_zSpot > _zCenter + 15) then { // Significantly higher
        _spots pushBack _pos;
    };
} forEach _terrainSpots;

_spots
