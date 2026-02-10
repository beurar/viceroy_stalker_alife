#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Finds mostly evenly distributed land positions across the map using a grid search.
    Each grid cell tries to locate one valid land position using FUNC(findLandPos).

    Params:
        0: NUMBER - grid step size in meters (default: 1000)

    Returns:
        ARRAY of POSITIONs - Land positions in AGL coordinates
*/
params [["_step", 1000]]; // Default grid step is 1km


private _zones = []; // Initialize array to store found land positions
private _half = _step / 2; // offset to center of grid cell

// Iterate through X coordinates of the map
for "_x" from 0 to worldSize step _step do {
    // Iterate through Y coordinates of the map
    for "_y" from 0 to worldSize step _step do {
        // Calculate the center point of the current grid cell
        private _center = [_x + _half, _y + _half, 0];
        
        // Try to find a valid land position within this cell
        // _center: search origin
        // _half: search radius (half the step size prevents significant overlap)
        // 10: presumably max gradient or similar constraint
        private _pos = [_center, _half, 10] call FUNC(findLandPos);
        
        // Handle nil return from search function
        if (isNil {_pos}) then { _pos = [] };
        
        // If a valid position was found, add it to our list
        if (_pos isNotEqualTo []) then {
            _zones pushBack _pos;
        };
    };
};

// Cache results for later use
if (isNil "STALKER_landZones") then { STALKER_landZones = [] };
// Add new unique zones to global cache
{ STALKER_landZones pushBackUnique _x } forEach _zones;

_zones // Return the local list of found zones
