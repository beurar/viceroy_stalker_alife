/*
    Finds tactical sniper positions around a center position.
    Searches for high building positions and terrain vantage points.

    Params:
        0: ARRAY - Center position (AGL/ASL)
        1: NUMBER - Minimum distance from center
        2: NUMBER - Maximum distance from center
    
    Returns:
        ARRAY of POSITIONs (AGL)
*/
params ["_center", "_minDist", "_maxDist"];

private _debug = ["VSA_debugMode", false] call VIC_fnc_getSetting;
if (_debug) then {
    ["findDynamicSniperSpots", _this] call VIC_fnc_debugLog;
};

private _spots = [];
// Ensure [x,y,z] from whatever input (object or array)
private _refPos = _center call BIS_fnc_position; 

// 1. Find High Building Positions
// Search radius reduced to 400m for performance (nearestObjects is expensive).
private _buildings = nearestObjects [_refPos, ["House", "Building", "Ruins"], _maxDist min 400];

private _counter = 0;
{
    _counter = _counter + 1;
    if (_counter % 50 == 0) then { sleep 0.001; };
    
    if (_x distance2D _refPos > _minDist) then {
        // rapid check for building height bounding box to avoid listing positions for small sheds
        private _bBox = boundingBoxReal _x;
        private _height = abs ((_bBox select 1 select 2) - (_bBox select 0 select 2));
        
        if (_height > 6) then { // Only check buildings taller than 6m
            private _bPos = _x buildingPos -1;
            private _candidates = [];
            private _bCenter = getPosATL _x;
            
            {
                // Check height relative to ground
                if ((_x select 2) > 5) then { // At least 5m up
                     _candidates pushBack _x;
                };
            } forEach _bPos;
            
            if (_candidates isNotEqualTo []) then {
                 // Sort by score: Favor Height AND Edge placement
                 // Score = Height + (Distance from Building Center)
                 // This pushes them to balconies/edges rather than internal stairwells
                 
                 private _bestPos = _candidates select 0;
                 private _bestScore = -1;
                 
                 {
                     private _distEdge = _x distance2D _bCenter;
                     private _h = _x select 2;
                     
                     // Weighted score: 1m height = 1 point. 1m from center = 1.5 points.
                     private _score = _h + (_distEdge * 1.5);
                     
                     if (_score > _bestScore) then {
                         _bestScore = _score;
                         _bestPos = _x;
                     };
                 } forEach _candidates;
                 
                 _spots pushBack _bestPos;
            };
        };
    };
} forEach _buildings;

// 2. Find Terrain Vantage Points (Hilltops/Cliffs)
// We use selectBestPlaces as a heuristic for hills and open meadows (clear lines of sight)
// "hills" favors high ground, "meadow" favors open ground.
private _terrainSpots = selectBestPlaces [_refPos, _maxDist, "(2 * hills) + meadow - forest - houses", 25, 20];
{
    _x params ["_pos", "_value"];
    _pos = [_pos select 0, _pos select 1];
    _pos set [2, 0]; // AGL 0
    
    // Check if it fits distance criteria (selectBestPlaces is square/circle area, need to verify min dist)
    if (_pos distance2D _refPos > _minDist && _pos distance2D _refPos <= _maxDist) then {
        
        // Check elevation: Is it higher than the player/center?
        private _zCenter = getTerrainHeightASL _refPos;
        private _zSpot = getTerrainHeightASL _pos;
        
        // We want positions that have a command of the terrain, preferably higher than the player
        if (_zSpot > _zCenter + 10) then { 
             _spots pushBack _pos;
        };
    };
} forEach _terrainSpots;

if (_debug) then {
    ["findDynamicSniperSpots: Raw Candidates", count _spots] call VIC_fnc_debugLog;
};

// --- Optimization: Filter & Consolidate Spots ---
// Sort by height (descending) so we process the highest positions first
// _spots contains [x,y,z]. Sort by Z index (2)
_spots = [_spots, [], { _x select 2 }, "DESCEND"] call BIS_fnc_sortBy;

private _finalSpots = [];
private _consolidationDist = 300;

{
    private _candidate = _x;
    private _tooClose = false;
    
    // Check against already accepted better spots
    {
        if (_candidate distance2D _x < _consolidationDist) exitWith { _tooClose = true; };
    } forEach _finalSpots;
    
    if (!_tooClose) then {
        _finalSpots pushBack _candidate;
    };
} forEach _spots;

// Shuffle the final high-quality spots to not always pick the absolute best one (variety)
_finalSpots = _finalSpots call BIS_fnc_arrayShuffle;
if (count _finalSpots > 10) then {
    _finalSpots resize 10;
};

if (_debug) then {
    ["findDynamicSniperSpots: Final Spots", count _finalSpots] call VIC_fnc_debugLog;
};

_finalSpots
