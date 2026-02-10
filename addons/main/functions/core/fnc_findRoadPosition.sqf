#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Finds a valid road position near a specified position.

    Params:
        0: POSITION - The center position to search around
        1: SCALAR   - Radius to search within (e.g., 300)
        2: SCALAR   - Max number of attempts (e.g., 20)

    Returns:
        POSITION - Road position [x, y, z], or nil if none found
*/
params ["_centerPos", ["_radius", 300], ["_maxTries", 20]];
_maxTries; // parameter kept for backward compatibility

// Optimized: Use native nearRoads command instead of legacy caching
private _list = _centerPos nearRoads _radius;
if (_list isNotEqualTo []) exitWith { getPosATL (selectRandom _list) };

// Fallback if no roads found in radius
[] call FUNC(getRandomRoad)


