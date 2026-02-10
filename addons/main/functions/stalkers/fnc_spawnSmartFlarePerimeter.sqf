#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a smart perimeter of mines (AT, AP, Tripwires) around a position.
    Creates defensive corridors based on local structures using a Polygon hull.
    
    Params:
        0: POSITION - Center position
        1: NUMBER - Radius (default 200)
        2: NUMBER - Spacing (default 15m)
        3: ARRAY - Friendly Groups to reveal mines to (Optional)
        4: SIDE - Owner Side (Optional, Default EAST)
        
    Returns:
        ARRAY of Objects (Mines)
*/
params ["_center", ["_radius", 200], ["_spacing", 15], ["_friendlyGroups", []], ["_side", east]];

// PREVENTION: If called in unscheduled environment (init/triggers), spawn it to allow suspension/sleeping.
if (!canSuspend) exitWith {
    _this spawn FUNC(spawnSmartFlarePerimeter);
    []
};

if (!isServer) exitWith { [] };


// 1. ANALYZE AREA & BUILD POLYGON
private _nearBuildings = nearestObjects [_center, ["House", "Building", "Ruins", "Wall"], _radius * 0.8];

// If too few buildings, use a simple box around center
private _polygon = [];
private _minPeriDist = 100; // Minimum distance from center for any vertex

if (count _nearBuildings < 3) then {
    private _bck = _minPeriDist;
    _polygon = [
        (_center getPos [_bck, 45]),
        (_center getPos [_bck, 135]),
        (_center getPos [_bck, 225]),
        (_center getPos [_bck, 315])
    ];
} else {
    // 1a. Collect all building positions (Centroid calc)
    private _avgX = 0; private _avgY = 0;
    {
        _avgX = _avgX + ((getPos _x) select 0);
        _avgY = _avgY + ((getPos _x) select 1);
    } forEach _nearBuildings;
    
    _avgX = _avgX / (count _nearBuildings);
    _avgY = _avgY / (count _nearBuildings);
    private _centroid = [_avgX, _avgY, 0];
    
    // 1b. Sort buildings radially around centroid
    // Data: [angle, obj]
    private _sortedData = _nearBuildings apply { [_centroid getDir (getPos _x), _x] };
    _sortedData sort true;
    
    // 1c. Create Polygon Vertices (with dynamic buffer to ensure 100m+)
    {
        _x params ["_angle", "_obj"];
        
        // Push vertex out by 30m OR to ensure min distance
        private _dist = _centroid distance2D _obj;
        private _pushDist = 30;
        
        // If (dist + push) < 100, we need more push
        if ((_dist + _pushDist) < _minPeriDist) then {
            _pushDist = _minPeriDist - _dist;
        };
        
        private _pos = (getPos _obj) getPos [_pushDist, _angle];
        _pos set [2, 0];
        _polygon pushBack _pos;
    } forEach _sortedData;
};

// 2. VISUALIZE POLYGON
if (["VSA_debugMode", false] call FUNC(getSetting)) then {
    for "_i" from 0 to (count _polygon - 1) do {
        private _p1 = _polygon select _i;
        private _p2 = _polygon select ((_i + 1) % (count _polygon));
        private _mid = [((_p1 select 0)+(_p2 select 0))/2, ((_p1 select 1)+(_p2 select 1))/2, 0];
        private _dist = _p1 distance2D _p2;
        private _dir = _p1 getDir _p2;
        
        private _m = createMarker [format ["flr_poly_%1_%2", diag_tickTime, _i], _mid];
        _m setMarkerShapeLocal "RECTANGLE";
        _m setMarkerBrushLocal "Solid";
        _m setMarkerColorLocal "ColorGreen";
        _m setMarkerDirLocal _dir;
        _m setMarkerSizeLocal [0.5, _dist / 2];
        _m setMarkerAlpha 0.5;
    };
};

private _objs = [];
private _schedCounter = 0;

// 3. PROCESS EDGES (Specific Rules)
for "_i" from 0 to (count _polygon - 1) do {
     private _p1 = _polygon select _i;
     private _p2 = _polygon select ((_i + 1) % (count _polygon));
     
     // Yield
     _schedCounter = _schedCounter + 1;
     if (_schedCounter % 2 == 0) then { sleep 0.001; };
     
     // 3a. Determine Lethality of Edge
     // 66% Lethal, 34% Non-Lethal
     private _isLethal = (random 1) < 0.66;
     
     // 3b. Scan Corridor (Chunked Pattern to prevent freezing)
     private _edgeDir = _p1 getDir _p2;
     private _edgeDist = _p1 distance2D _p2;
     
     private _validProps = [];
     private _scanStep = 25; 
     private _scanCount = ceil (_edgeDist / _scanStep);
     
     // Chunked search along the line
     for "_m" from 0 to _scanCount do {
         sleep 0.001; // Mandatory yield per chunk
         private _scanPos = _p1 getPos [(_m * _scanStep) min _edgeDist, _edgeDir];
         private _chunkObjs = nearestTerrainObjects [_scanPos, ["TREE", "SMALL TREE", "BUSH", "WALL", "FENCE", "ROCK"], 20];
         {
             if !(_x in _validProps) then { _validProps pushBack _x; };
         } forEach _chunkObjs;
     };
     
     // Filter: Must be within 10m of the mathematical line segment
     // Loop with Yields to prevent freezing on large object counts
     private _corridorProps = [];
     
     {
         if (_forEachIndex % 20 == 0) then { sleep 0.001; };
         
         private _objPos = getPos _x; 
         // Distance Point to Line Segment implementation
         // 2D Cross Product Magnitude: |(x2-x1)(y1-y0) - (x1-x0)(y2-y1)| / dist
         private _num = abs ( ((_p2 select 0) - (_p1 select 0)) * ((_objPos select 1) - (_p1 select 1)) - ((_p1 select 0) - (_objPos select 0)) * ((_p2 select 1) - (_p1 select 1)) );
         
         if (_edgeDist > 0) then {
             private _d = _num / _edgeDist;
             if (_d < 10) then { _corridorProps pushBack _x; };
         };
     } forEach _validProps;
     
     // Sort props along the line (distance from Start Point _p1)
     private _sortArr = _corridorProps apply { [_p1 distance2D _x, _x] };
     _sortArr sort true;
     _corridorProps = _sortArr apply { _x select 1 };
     
     // 3c. TRIPWIRE CONNECTION (Solid Line)
     if (count _corridorProps >= 2) then {
         for "_k" from 0 to (count _corridorProps - 2) do {
             private _objA = _corridorProps select _k;
             private _objB = _corridorProps select (_k + 1);
             
             // If distance is reasonable for a tripwire (max 20m)
             private _distObjs = _objA distance2D _objB;
             
             if (_distObjs > 2 && _distObjs < 22) then {
                 // Place Tripwire at A, aiming at B
                 private _minePos = getPos _objA;
                 private _wireDir = _objA getDir _objB; 
                 
                 // FIX: Offset slightly away from structure to avoid clipping inside it (0.8m towards B)
                 _minePos = _minePos getPos [0.8, _wireDir];
                 // FIX: Force Z to 0 to ensure it sits on ground, not in tree branches
                 _minePos set [2, 0];
                 
                 private _mineType = "APERSTripMine"; 
                 private _color = "ColorRed";
                 
                 if (!_isLethal) then {
                     if (isClass (configFile >> "CfgVehicles" >> "ACE_FlareTripMine")) then {
                         _mineType = "ACE_FlareTripMine";
                         _color = "ColorYellow";
                     };
                 };
                 
                 private _mine = createMine [_mineType, _minePos, [], 0];
                 _mine setDir (_wireDir + 90);
                 _objs pushBack _mine;
                 
                 if (["VSA_debugMode", false] call FUNC(getSetting)) then {
                     private _m = createMarker [format ["flr_tw_%1_%2_%3", diag_tickTime, _i, _k], _minePos];
                     _m setMarkerTypeLocal "mil_dot"; _m setMarkerColorLocal _color; _m setMarkerTextLocal "TW"; _m setMarkerSize [0.5,0.5];
                 };
             };
         };
     };
     
     // 3d. OPEN GROUND (Regular intervals)
     private _segCount = ceil (_edgeDist / _spacing);
     private _segStep = _edgeDist / _segCount;
     
     for "_k" from 0 to (_segCount) do {
         
         // Anti-Freeze Yield
         if (_k % 3 == 0) then { sleep 0.001; };

         private _pt = _p1 getPos [_k * _segStep, _edgeDir];
         
         // SKIP if covered by our tripwire props (simple distance check)
         private _tooClose = { _x distance2D _pt < 4 } count _corridorProps > 0;
         if (_tooClose) then { continue; };
         
         // IS ROAD?
         if (isOnRoad _pt) then {
             private _roads = _pt nearRoads 10;
             if (_roads isNotEqualTo []) then {
                 private _road = _roads select 0;
                 private _existingMines = (getPos _road) nearObjects ["MineBase", 8];
                 
                 if (_existingMines isEqualTo []) then {
                     if (_isLethal) then {
                         // LETHAL -> AT MINE
                         private _m = createMine ["ATMine", getPos _road, [], 0];
                         _m setDir (_edgeDir);
                         _objs pushBack _m;
                     } else {
                         // NON-LETHAL -> IED (Hostile Vehicle Only)
                         // Fixed class name
                         private _iedType = "IEDLandSmall_F"; 
                         private _m = createMine [_iedType, getPos _road, [], 0];
                         _objs pushBack _m;
                         
                         // Create Trigger
                         private _trg = createTrigger ["EmptyDetector", getPos _road, false];
                         _trg setTriggerArea [8, 8, 0, false];
                         _trg setTriggerActivation ["ANY", "PRESENT", false];
                         _trg setVariable ["VIC_ownerSide", _side];
                         _trg setVariable ["VIC_ied", _m];
                         
                         _trg setTriggerStatements [
                            "(thisList findIf { side _x != (thisTrigger getVariable 'VIC_ownerSide') && (_x isKindOf 'LandVehicle') } > -1)",
                            "private _ied = thisTrigger getVariable 'VIC_ied'; if (!isNull _ied) then { _ied setDamage 1; }; deleteVehicle thisTrigger;",
                            ""
                         ];
                     };
                 };
             };
         } else {
             // OPEN GROUND -> FILL GAPS
             private _isStructureNear = nearestTerrainObjects [_pt, ["TREE", "WALL", "HOUSE"], 4] isNotEqualTo [];
             
             if (!_isStructureNear) then {
                 private _minePos = _pt getPos [(random 6) - 3, _edgeDir + 90];
                 _minePos = [_minePos, 5] call FUNC(findLandPos);
                 if (isNil "_minePos" || {_minePos isEqualTo []}) then { continue; };
                 
                 private _type = ["APERSMine", "APERSBoundingMine"] select (random 1 > 0.5);
                 
                 private _m = createMine [_type, _minePos, [], 0];
                 _objs pushBack _m;
                 
                  if (["VSA_debugMode", false] call FUNC(getSetting)) then {
                     private _m = createMarker [format ["flr_ap_%1_%2_%3", diag_tickTime, _i, _k], _minePos];
                     _m setMarkerTypeLocal "mil_dot"; _m setMarkerColorLocal "ColorOrange"; _m setMarkerSize [0.4,0.4];
                 };
             };
         };
     };
};

if (_friendlyGroups isNotEqualTo []) then {
    {
        private _grp = _x;
        if (!isNull _grp) then {
             { _grp revealMine _x } forEach _objs;
        };
    } forEach _friendlyGroups;
};

_objs
