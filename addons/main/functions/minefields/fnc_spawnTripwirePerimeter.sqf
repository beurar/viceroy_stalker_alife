#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns tripwire mines at tactical positions around a defended position.
    Targets doorways, paths between structures, gaps in walls/fences, and
    natural choke points formed by terrain objects. Falls back to cover-object
    placement when no structures are nearby.

    Params:
        0: POSITION - center position
        1: NUMBER   - radius of the perimeter (default 25)
        2: NUMBER   - minimum mines to spawn (default 6)
        3: NUMBER   - maximum mines to spawn (default same as min)
    Returns:
        ARRAY - spawned mine objects
*/
params ["_center", ["_radius", 25], ["_minCount", 6], ["_maxCount", -1]];

if (!isServer) exitWith { [] };

if (_maxCount < _minCount) then { _maxCount = _minCount };
private _targetCount = _minCount + floor random (1 + _maxCount - _minCount);
private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

private _mineType = ["APERSMine", "APERSTripMine"] select (isClass ((configFile >> "CfgVehicles") >> "APERSTripMine"));
private _objs = [];
private _usedPositions = [];

// Helper: check minimum separation from already-placed mines
private _fnc_tooClose = {
    params ["_pos", "_minDist"];
    private _close = false;
    { if (_x distance2D _pos < _minDist) exitWith { _close = true } } forEach _usedPositions;
    _close
};

// --- PHASE 1: Building doorways ---
// Doorways are ground-floor building positions (Z < 1.5) near the building edge
private _buildings = nearestObjects [_center, ["House", "Building", "Ruins"], _radius * 1.3];
{
    if (count _objs >= _targetCount) exitWith {};
    private _bld = _x;
    private _bldPos = getPosATL _bld;
    private _bBox = boundingBoxReal _bld;
    private _bldRadius = (vectorMagnitude [(_bBox select 1 select 0) - (_bBox select 0 select 0), (_bBox select 1 select 1) - (_bBox select 0 select 1), 0]) / 2;
    private _allPos = _bld buildingPos -1;

    // Ground floor positions near the perimeter of the bounding box = likely doorways
    private _doorCandidates = _allPos select {
        (_x select 2) < 1.5 && { _x distance2D _bldPos > (_bldRadius * 0.5) }
    };

    {
        if (count _objs >= _targetCount) exitWith {};
        private _doorPos = _x;
        // Place mine 1.5m outside the doorway, facing inward
        private _outDir = _bldPos getDir _doorPos;
        private _minePos = _doorPos getPos [1.5, _outDir];
        _minePos set [2, 0];
        _minePos = [_minePos] call FUNC(findLandPos);
        if (isNil "_minePos" || { _minePos isEqualTo [] }) then { continue };
        if ([_minePos, 3] call _fnc_tooClose) then { continue };

        private _mine = createMine [_mineType, _minePos, [], 0];
        _mine setDir (_outDir + 180);
        _objs pushBack _mine;
        _usedPositions pushBack _minePos;

        if (_debug) then {
            private _m = format ["tw_door_%1_%2", diag_tickTime, _forEachIndex];
            [_m, _minePos, "ICON", "mil_triangle", "#(1,0.5,0,1)", 0.2, "TW-Door"] call FUNC(createGlobalMarker);
        };
    } forEach _doorCandidates;
} forEach _buildings;

// --- PHASE 2: Gaps between walls, fences, and structures ---
// Choke points form where two solid objects are 2-8m apart
private _barriers = nearestTerrainObjects [_center, ["WALL", "FENCE", "HIDE"], _radius * 1.2];
_barriers append (_buildings apply { _x });
private _processed = [];
{
    if (count _objs >= _targetCount) exitWith {};
    private _objA = _x;
    private _posA = getPosATL _objA;
    {
        if (count _objs >= _targetCount) exitWith {};
        private _objB = _x;
        if (_objA isEqualTo _objB) then { continue };
        private _pair = [_objA, _objB];
        _pair sort true;
        if (_pair in _processed) then { continue };
        _processed pushBack _pair;

        private _posB = getPosATL _objB;
        private _gap = _posA distance2D _posB;

        // Sweet spot: gap wide enough to walk through, narrow enough to be a choke
        if (_gap > 2 && _gap < 8) then {
            private _mid = [(_posA select 0 + _posB select 0) / 2, (_posA select 1 + _posB select 1) / 2, 0];
            _mid = [_mid] call FUNC(findLandPos);
            if (isNil "_mid" || { _mid isEqualTo [] }) then { continue };
            if ([_mid, 3] call _fnc_tooClose) then { continue };

            private _wireDir = [_posA, _posB] call BIS_fnc_dirTo;
            private _mine = createMine [_mineType, _mid, [], 0];
            _mine setDir _wireDir;
            _objs pushBack _mine;
            _usedPositions pushBack _mid;

            if (_debug) then {
                private _m = format ["tw_gap_%1_%2", diag_tickTime, _forEachIndex];
                [_m, _mid, "ICON", "mil_triangle", "#(1,0.5,0,1)", 0.2, "TW-Gap"] call FUNC(createGlobalMarker);
            };
        };
    } forEach _barriers;
} forEach _barriers;

// --- PHASE 3: Paths and trails ---
// Place mines on roads/paths that lead toward the position
private _roads = _center nearRoads _radius;
{
    if (count _objs >= _targetCount) exitWith {};
    private _roadPos = getPos _x;
    if ([_roadPos, 5] call _fnc_tooClose) then { continue };
    // Only use roads that are approach routes (not tangential)
    private _approachDir = _center getDir _roadPos;
    private _info = getRoadInfo _x;
    // _info select 7 = connected roads - use first to determine road bearing
    private _connRoads = roadsConnectedTo _x;
    if (_connRoads isEqualTo []) then { continue };
    private _roadDir = _roadPos getDir (getPos (_connRoads select 0));
    // Road must roughly point toward center (within 45 degrees)
    private _angleDiff = abs (_approachDir - _roadDir);
    if (_angleDiff > 180) then { _angleDiff = 360 - _angleDiff };
    if (_angleDiff > 45 && _angleDiff < 135) then { continue };

    private _minePos = _roadPos getPos [(random 2) - 1, _roadDir + 90];
    _minePos set [2, 0];
    private _mine = createMine [_mineType, _minePos, [], 0];
    _mine setDir (_roadDir + 90);
    _objs pushBack _mine;
    _usedPositions pushBack _minePos;

    if (_debug) then {
        private _m = format ["tw_road_%1_%2", diag_tickTime, _forEachIndex];
        [_m, _minePos, "ICON", "mil_triangle", "#(1,0.5,0,1)", 0.2, "TW-Path"] call FUNC(createGlobalMarker);
    };
} forEach _roads;

// --- PHASE 4: Cover-object anchored tripwires (fill remaining count) ---
// Stretch wires between trees, rocks, bushes that are along approach routes
if (count _objs < _targetCount) then {
    private _coverObjs = nearestTerrainObjects [_center, ["TREE", "SMALL TREE", "BUSH", "ROCK"], _radius * 1.2];

    // Sort by distance from center — closer objects are better defensive positions
    _coverObjs = [_coverObjs, [], { _x distance2D _center }, "ASCEND"] call BIS_fnc_sortBy;

    {
        if (count _objs >= _targetCount) exitWith {};
        private _objPos = getPosATL _x;
        if (_objPos distance2D _center < 3) then { continue };
        if ([_objPos, 3] call _fnc_tooClose) then { continue };

        // Place mine on the approach side (between object and center)
        private _dirToCenter = _objPos getDir _center;
        private _minePos = _objPos getPos [1, _dirToCenter];
        _minePos set [2, 0];
        _minePos = [_minePos] call FUNC(findLandPos);
        if (isNil "_minePos" || { _minePos isEqualTo [] }) then { continue };

        private _mine = createMine [_mineType, _minePos, [], 0];
        _mine setDir _dirToCenter;
        _objs pushBack _mine;
        _usedPositions pushBack _minePos;

        if (_debug) then {
            private _m = format ["tw_cov_%1_%2", diag_tickTime, _forEachIndex];
            [_m, _minePos, "ICON", "mil_triangle", "#(1,0.5,0,1)", 0.2, "TW-Cover"] call FUNC(createGlobalMarker);
        };
    } forEach _coverObjs;
};

_objs
