#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns flare tripwires at tactical approach points around a camp.
    Targets doorways, gaps between objects, paths, and natural choke points
    so the camp gets realistic early-warning coverage.

    Params:
        0: POSITION - center position
        1: NUMBER   - radius of the perimeter (default 25)
        2: NUMBER   - number of tripwires (default 6)
    Returns:
        ARRAY - spawned mine objects
*/
params ["_center", ["_radius", 25], ["_count", 6]];

if (!isServer) exitWith { [] };

private _debug = ["VSA_debugMode", false] call FUNC(getSetting);
private _mineType = ["APERSMine", "APERSTripMine"] select (isClass ((configFile >> "CfgVehicles") >> "APERSTripMine"));
private _objs = [];
private _usedPositions = [];

private _fnc_tooClose = {
    params ["_pos", "_minDist"];
    private _close = false;
    { if (_x distance2D _pos < _minDist) exitWith { _close = true } } forEach _usedPositions;
    _close
};

private _fnc_placeFlare = {
    params ["_pos", "_dir", "_label"];
    private _mine = createMine [_mineType, _pos, [], 0];
    _mine setDir _dir;
    _mine addEventHandler ["Explosion", { "F_40mm_White" createVehicle getPosATL (_this select 0) }];
    _objs pushBack _mine;
    _usedPositions pushBack _pos;
    if (_debug) then {
        private _m = format ["flr_%1_%2", diag_tickTime, count _objs];
        [_m, _pos, "ICON", "mil_warning", "#(1,1,0,1)", 0.2, _label] call FUNC(createGlobalMarker);
    };
};

// --- PHASE 1: Gaps between cover objects (natural choke points) ---
private _coverObjs = nearestTerrainObjects [_center, ["TREE", "SMALL TREE", "BUSH", "ROCK", "WALL", "FENCE"], _radius * 1.2];
private _processed = [];
{
    if (count _objs >= _count) exitWith {};
    private _objA = _x;
    private _posA = getPosATL _objA;
    if (_posA distance2D _center < 2) then { continue };
    {
        if (count _objs >= _count) exitWith {};
        private _objB = _x;
        if (_objA isEqualTo _objB) then { continue };
        private _pair = [_objA, _objB];
        _pair sort true;
        if (_pair in _processed) then { continue };
        _processed pushBack _pair;

        private _posB = getPosATL _objB;
        private _gap = _posA distance2D _posB;

        if (_gap > 1.5 && _gap < 6) then {
            private _mid = [(_posA select 0 + _posB select 0) / 2, (_posA select 1 + _posB select 1) / 2, 0];
            if ([_mid, 3] call _fnc_tooClose) then { continue };
            private _wireDir = [_posA, _posB] call BIS_fnc_dirTo;
            [_mid, _wireDir, "Flare-Gap"] call _fnc_placeFlare;
        };
    } forEach _coverObjs;
} forEach _coverObjs;

// --- PHASE 2: Building doorways ---
private _buildings = nearestObjects [_center, ["House", "Building", "Ruins"], _radius * 1.3];
{
    if (count _objs >= _count) exitWith {};
    private _bld = _x;
    private _bldPos = getPosATL _bld;
    private _allPos = _bld buildingPos -1;
    private _bBox = boundingBoxReal _bld;
    private _bldRadius = (vectorMagnitude [(_bBox select 1 select 0) - (_bBox select 0 select 0), (_bBox select 1 select 1) - (_bBox select 0 select 1), 0]) / 2;

    private _doorCandidates = _allPos select {
        (_x select 2) < 1.5 && { _x distance2D _bldPos > (_bldRadius * 0.5) }
    };
    {
        if (count _objs >= _count) exitWith {};
        private _doorPos = _x;
        private _outDir = _bldPos getDir _doorPos;
        private _minePos = _doorPos getPos [1.5, _outDir];
        _minePos set [2, 0];
        if ([_minePos, 3] call _fnc_tooClose) then { continue };
        [_minePos, _outDir + 180, "Flare-Door"] call _fnc_placeFlare;
    } forEach _doorCandidates;
} forEach _buildings;

// --- PHASE 3: Approach-side of remaining cover objects ---
if (count _objs < _count) then {
    private _sorted = [_coverObjs, [], { _x distance2D _center }, "ASCEND"] call BIS_fnc_sortBy;
    {
        if (count _objs >= _count) exitWith {};
        private _objPos = getPosATL _x;
        if (_objPos distance2D _center < 2) then { continue };
        if ([_objPos, 3] call _fnc_tooClose) then { continue };

        private _dirToCenter = _objPos getDir _center;
        private _minePos = _objPos getPos [1, _dirToCenter];
        _minePos set [2, 0];
        [_minePos, _dirToCenter, "Flare-Cover"] call _fnc_placeFlare;
    } forEach _sorted;
};

// --- PHASE 4: Fill remaining with approach-route placements ---
if (count _objs < _count) then {
    private _roads = _center nearRoads _radius;
    {
        if (count _objs >= _count) exitWith {};
        private _roadPos = getPos _x;
        if ([_roadPos, 4] call _fnc_tooClose) then { continue };
        private _connRoads = roadsConnectedTo _x;
        if (_connRoads isEqualTo []) then { continue };
        private _roadDir = _roadPos getDir (getPos (_connRoads select 0));
        private _minePos = _roadPos getPos [(random 1.5) - 0.75, _roadDir + 90];
        _minePos set [2, 0];
        [_minePos, _roadDir + 90, "Flare-Path"] call _fnc_placeFlare;
    } forEach _roads;
};

_objs
