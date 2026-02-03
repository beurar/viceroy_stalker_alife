/*
    Returns a random road position using stochastic sampling.
    
    Returns:
        POSITION - road position [x, y, z]
*/

private _pos = nil;
// Try up to 100 times to find a road segment
for "_i" from 1 to 100 do {
    private _rnd = [worldSize / 2, worldSize / 2, 0] getPos [random (worldSize * 0.7), random 360];
    private _list = _rnd nearRoads 500;
    if (_list isNotEqualTo []) exitWith {
        _pos = getPosATL (selectRandom _list);
    };
};

// Fallback: Return map center if we are incredibly unlucky (or map has no roads)
if (isNil "_pos") then { _pos = [worldSize/2, worldSize/2, 0] };
_pos
