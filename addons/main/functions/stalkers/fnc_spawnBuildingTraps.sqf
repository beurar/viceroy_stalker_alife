#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Places building traps in nearby buildings. When a player approaches,
    zombies or enemy stalkers spawn inside to ambush them.

    Params:
        0: POSITION - center position to search from
        1: NUMBER   - search radius (default 300)
        2: NUMBER   - number of traps to place (default -1, uses setting)
    Returns:
        BOOL
*/
params ["_center", ["_radius", 300], ["_count", -1]];

if (!isServer) exitWith { false };

if (["VSA_enableBuildingTraps", true] call FUNC(getSetting) isEqualTo false) exitWith { false };

if (_count < 0) then { _count = ["VSA_buildingTrapCount", 5] call FUNC(getSetting) };

if (isNil "STALKER_buildingTraps") then { STALKER_buildingTraps = [] };

private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

// Find suitable buildings: multi-story or large enough to hide in
private _buildings = nearestObjects [_center, ["House", "Building"], _radius];
_buildings = _buildings select {
    private _bPos = _x buildingPos -1;
    count _bPos >= 3
};

if (_buildings isEqualTo []) exitWith { false };

// Shuffle to distribute randomly
_buildings = _buildings call BIS_fnc_arrayShuffle;

private _spawned = 0;

{
    if (_spawned >= _count) exitWith {};
    private _bld = _x;
    private _bldPos = getPosATL _bld;

    // Skip if too close to an existing building trap
    private _tooClose = false;
    {
        if ((_x select 0) distance2D _bldPos < 80) exitWith { _tooClose = true };
    } forEach STALKER_buildingTraps;
    if (_tooClose) then { continue };

    private _positions = _bld buildingPos -1;
    if (_positions isEqualTo []) then { continue };

    // Pick spawn positions inside the building (prefer interior/upper floors)
    private _interiorPos = _positions select { (_x select 2) > 0.5 };
    if (_interiorPos isEqualTo []) then { _interiorPos = _positions };

    // Determine trap type: zombie or stalker
    private _useZombies = random 1 < (["VSA_buildingTrapZombieChance", 0.5] call FUNC(getSetting));

    // Pick a faction for stalker traps
    private _faction = [];
    if (!_useZombies) then {
        private _factions = [] call FUNC(getStalkerFactions);
        private _hostileFactions = _factions select {
            private _sides = _x select 1;
            opfor in _sides
        };
        if (_hostileFactions isEqualTo []) then { _hostileFactions = _factions };
        _faction = selectRandom _hostileFactions;
    };

    private _anchor = [_bldPos] call FUNC(createProximityAnchor);

    private _marker = "";
    if (_debug) then {
        _marker = format ["btrap_%1", diag_tickTime + _spawned];
        private _label = ["StalkerTrap", "ZombieTrap"] select (_useZombies);
        private _color = ["#(1,0.5,0,1)", "#(0.6,0,0,1)"] select (_useZombies);
        [_marker, _bldPos, "ICON", "mil_warning", _color, 0.6, _label] call FUNC(createGlobalMarker);
    };

    // Determine unit count (2-5)
    private _unitCount = 2 + floor random 4;
    _unitCount = _unitCount min (count _interiorPos);

    // Select spawn positions (no duplicates)
    private _spawnPositions = [];
    private _available = +_interiorPos;
    for "_i" from 1 to _unitCount do {
        if (_available isEqualTo []) exitWith {};
        private _p = selectRandom _available;
        _spawnPositions pushBack _p;
        _available = _available - [_p];
    };

    // Entry: [buildingPos, anchor, spawnPositions, marker, active, group, useZombies, faction]
    STALKER_buildingTraps pushBack [_bldPos, _anchor, _spawnPositions, _marker, false, grpNull, _useZombies, _faction];
    _spawned = _spawned + 1;
} forEach _buildings;

true
