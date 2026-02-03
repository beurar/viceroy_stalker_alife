/*
    Finds a valid road position near a random point on the map.

    Params:
        0: SCALAR - Search radius around the random point (e.g., 300)
        1: SCALAR - Max number of attempts (e.g., 20)

    Returns:
        POSITION - Road position [x, y, z], or nil if none found
*/
params [["_radius", 300], ["_maxTries", 20]];

private _result = nil;
private _attempt = 0;

while { _attempt < _maxTries } do {
    private _randomPos = [] call BIS_fnc_randomPos;
    if ((_randomPos isEqualTo [0,0]) || { _randomPos isEqualTo [0,0,0] }) then {
        _attempt = _attempt + 1;
        continue;
    };
    
    // Optimized: Use native nearRoads
    private _list = _randomPos nearRoads _radius;
    if (_list isNotEqualTo []) exitWith {
        _result = getPosATL (selectRandom _list);
    };

    _attempt = _attempt + 1;
};

_result
