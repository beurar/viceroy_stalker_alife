#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Returns a land position around the given centre using BIS_fnc_randomPos.
    The original search logic has been replaced entirely by the BIS helper.

    Params
    Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
      0: ARRAY centrePos        Ã¢â‚¬â€œ centre of search area (ASL or ATL)
      1: NUMBER searchRadius    Ã¢â‚¬â€œ metres (default 1000)
      2: NUMBER minWaterDist    Ã¢â‚¬â€œ unused, kept for API compatibility
      3: NUMBER maxSlopeDeg     Ã¢â‚¬â€œ unused, kept for API compatibility
      4: ARRAY  blacklistPos    Ã¢â‚¬â€œ unused, kept for API compatibility
      5: NUMBER clearanceRad    Ã¢â‚¬â€œ unused, kept for API compatibility
      6: NUMBER maxAttempts     Ã¢â‚¬â€œ unused, kept for API compatibility

    Returns
    Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
      ARRAY positionATL         Ã¢â‚¬â€œ random land position
      []                        Ã¢â‚¬â€œ if none found
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
