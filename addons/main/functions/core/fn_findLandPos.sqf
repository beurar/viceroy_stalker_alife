/*
    Returns a land position around the given centre using BIS_fnc_randomPos.
    The original search logic has been replaced entirely by the BIS helper.

    Params
    â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      0: ARRAY centrePos        â€“ centre of search area (ASL or ATL)
      1: NUMBER searchRadius    â€“ metres (default 1000)
      2: NUMBER minWaterDist    â€“ unused, kept for API compatibility
      3: NUMBER maxSlopeDeg     â€“ unused, kept for API compatibility
      4: ARRAY  blacklistPos    â€“ unused, kept for API compatibility
      5: NUMBER clearanceRad    â€“ unused, kept for API compatibility
      6: NUMBER maxAttempts     â€“ unused, kept for API compatibility

    Returns
    â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      ARRAY positionATL         â€“ random land position
      []                        â€“ if none found
*/
params [
    ["_centrePos",   [0,0,0],   [[]]  ],
    ["_radius",         1000,   [0]   ],
    ["_minWaterDist",     30,   [0]   ],
    ["_maxSlope",         30,   [0]   ],
    ["_blacklist",        [],   [[]]  ],
    ["_clearanceRad",      5,   [0]   ],
    ["_maxAttempts",     200,   [0]   ]
];

// suppress unused variable warnings
private _dummy = [_minWaterDist, _maxSlope, _blacklist, _clearanceRad, _maxAttempts];
_dummy;

private _p = [[[ _centrePos, _radius ]], ["water"]] call BIS_fnc_randomPos;
if ((_p isEqualTo [0,0]) || { _p isEqualTo [0,0,0] }) exitWith { [] };

// ensure the position lies within map bounds
private _px = _p select 0;
private _py = _p select 1;
if (_px < 0 || { _py < 0 } || { _px > worldSize } || { _py > worldSize }) exitWith { [] };

_p
