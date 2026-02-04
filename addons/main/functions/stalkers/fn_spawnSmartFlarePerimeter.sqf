/*
    Spawns a smart perimeter of mines (AT, AP, Tripwires) around a position.
    Creates defensive corridors based on local structures.
    
    Params:
        0: POSITION - Center position
        1: NUMBER - Radius (default 200)
        2: NUMBER - Spacing (default 15m)
        3: ARRAY - Friendly Groups to reveal mines to (Optional)
        
    Returns:
        ARRAY of Objects (Mines)
*/
params ["_center", ["_radius", 200], ["_spacing", 15], ["_friendlyGroups", []]];

if (!isServer) exitWith { [] };

["spawnSmartFlarePerimeter", _this] call VIC_fnc_debugLog;

// 1. ANALYZE AREA EXTENTS (Bounding Box)
private _nearBuildings = nearestObjects [_center, ["House", "Building", "Ruins", "Wall"], _radius * 0.8];
private _minX = (_center select 0) - 20; private _maxX = (_center select 0) + 20;
private _minY = (_center select 1) - 20; private _maxY = (_center select 1) + 20;

if (_nearBuildings isNotEqualTo []) then {
    _minX = 999999; _maxX = -999999;
    _minY = 999999; _maxY = -999999;
    {
        // Use boundingBoxReal for better precision
        private _bbr = boundingBoxReal _x;
        
        // Check all 4 corners of the BBox in world space (roughly)
        private _corners = [
            _x modelToWorld [_bbr select 0 select 0, _bbr select 0 select 1, 0],
            _x modelToWorld [_bbr select 1 select 0, _bbr select 1 select 1, 0],
            _x modelToWorld [_bbr select 0 select 0, _bbr select 1 select 1, 0],
            _x modelToWorld [_bbr select 1 select 0, _bbr select 0 select 1, 0]
        ];
        
        {
            _minX = _minX min (_x select 0);
            _maxX = _maxX max (_x select 0);
            _minY = _minY min (_x select 1);
            _maxY = _maxY max (_x select 1);
        } forEach _corners;
    } forEach _nearBuildings;
};

// Add defensive buffer (20m corridor outside the buildings)
private _buffer = 20;
_minX = _minX - _buffer; _maxX = _maxX + _buffer;
_minY = _minY - _buffer; _maxY = _maxY + _buffer;

// Define 4 Corners & Edges
private _p1 = [_minX, _minY, 0]; // BL
private _p2 = [_maxX, _minY, 0]; // BR
private _p3 = [_maxX, _maxY, 0]; // TR
private _p4 = [_minX, _maxY, 0]; // TL

// Edges: [Start, End, Label]
private _allEdges = [
    [_p1, _p2, "South"],
    [_p2, _p3, "East"],
    [_p3, _p4, "North"],
    [_p4, _p1, "West"]
];

// 2. VISUALIZE SAFE ZONE (Green)
if (["VSA_debugMode", false] call VIC_fnc_getSetting) then {
    private _markerZone = format ["flr_zone_%1", diag_tickTime];
    createMarker [_markerZone, _center];
    _markerZone setMarkerShape "RECTANGLE";
    _markerZone setMarkerBrush "SolidBorder";
    _markerZone setMarkerColor "ColorGreen";
    
    private _w = (_maxX - _minX);
    private _h = (_maxY - _minY);
    _markerZone setMarkerSize [_w / 2, _h / 2];
    _markerZone setMarkerAlpha 0.3;
    
    private _trueCenter = [(_minX + _maxX)/2, (_minY + _maxY)/2];
    _markerZone setMarkerPos _trueCenter;
};

// 3. SELECT EDGES (Random 1 to 4)
private _selectedEdges = _allEdges call BIS_fnc_arrayShuffle;
private _edgeCount = (floor random 4) + 1; // 1-4
_selectedEdges resize _edgeCount;

private _objs = [];
private _schedCounter = 0;

// 4. POPULATE MINES
{
    _x params ["_start", "_end", "_label"];
    
    private _dist = _start distance2D _end;
    private _segCount = ceil (_dist / _spacing);
    private _segStep = _dist / _segCount;
    private _edgeDir = _start getDir _end;
    
    // Visualize Edge Corridor (Red)
    if (["VSA_debugMode", false] call VIC_fnc_getSetting) then {
        private _mid = [((_start select 0)+(_end select 0))/2, ((_start select 1)+(_end select 1))/2, 0];
        private _markerLine = format ["flr_corr_%1_%2", diag_tickTime, _forEachIndex];
        createMarker [_markerLine, _mid];
        _markerLine setMarkerShape "RECTANGLE";
        _markerLine setMarkerBrush "Solid";
        _markerLine setMarkerColor "ColorRed";
        _markerLine setMarkerDir _edgeDir;
        _markerLine setMarkerSize [10, _dist / 2]; // 20m wide (10 radius)
        _markerLine setMarkerAlpha 0.2;
    };
    
    for "_k" from 0 to (_segCount) do {
        
        // Yield Check
        _schedCounter = _schedCounter + 1;
        if (_schedCounter % 5 == 0) then { sleep 0.001; };

        // Point on perimeter line
        private _pt = _start getPos [_k * _segStep, _edgeDir];
        
        // Randomize laterally within the 20m corridor (+/- 10m)
        private _offset = (random 10) - 5; 
        private _minePos = _pt getPos [_offset, _edgeDir + 90];
        _minePos set [2, 0];
        
        // Determine Mine Type
        private _mineClass = "APERSBoundingMine"; 
        private _mineDir = 0;
        private _debugColor = "ColorOrange";
        private _visWireDir = -1;
        
        // RULE 1: ROAD -> AT MINE
        if (isOnRoad _minePos) then {
            _mineClass = "ATMine";
            _debugColor = "ColorBlack";
            private _roads = _minePos nearRoads 10;
            if (_roads isNotEqualTo []) then {
                _minePos = getPos (_roads select 0);
                _mineDir = getDir (_roads select 0);
            };
        } else {
            // Check Surroundings
            private _nearObjs = nearestTerrainObjects [_minePos, ["TREE", "SMALL TREE", "BUSH", "WALL", "FENCE", "ROCK", "HOUSE"], 6];
            
            // RULE 2: NEAR STRUCTURE -> TRIPWIRE
            if (_nearObjs isNotEqualTo []) then {
                private _obj = _nearObjs select 0;
                
                // Snap mine closer to structure if very close
                 if ((getPos _obj) distance2D _minePos < 4) then {
                     _minePos = getPos _obj;
                     // Ensure slight offset from center
                     _minePos = _minePos getPos [0.8, random 360];
                 };
                 
                 // Type: APERS or Flare Tripwire (50/50 Chance)
                 _mineClass = "APERSTripMine";
                 _debugColor = "ColorRed";
                 
                 if ((random 1 > 0.5) && {isClass (configFile >> "CfgVehicles" >> "ACE_FlareTripMine")}) then {
                     _mineClass = "ACE_FlareTripMine"; 
                     _debugColor = "ColorYellow";
                 };
                 
                 // Orientation: ALIGN WITH PERIMETER
                 // Wire runs parallel to _edgeDir. 
                 // Mine must be Perpendicular to Wire (approx).
                 _mineDir = _edgeDir + 90;
                 _visWireDir = _edgeDir;
                 
            } else {
                // RULE 3: OPEN GROUND -> BOUNDING / APERS
                if (random 1 > 0.5) then {
                    _mineClass = "APERSBoundingMine";
                    _debugColor = "ColorOrange";
                } else {
                    _mineClass = "APERSMine";
                    _debugColor = "ColorOrange";
                };
                _mineDir = random 360;
            };
        };
        
        // Ensure position is on land (radius 5m)
        _minePos = [_minePos, 5] call VIC_fnc_findLandPos;
        if (isNil "_minePos" || {_minePos isEqualTo []}) then { continue; };
        
        private _mine = createMine [_mineClass, _minePos, [], 0];
        _mine setDir _mineDir;
        
        // RULE: REVEAL TO FRIENDLIES
        if (_friendlyGroups isNotEqualTo []) then {
            {
                if (!isNull _x) then { _x revealMine _mine; };
            } forEach _friendlyGroups;
        };
        
        _objs pushBack _mine;
        
        // Debug Marker
        if (["VSA_debugMode", false] call VIC_fnc_getSetting) then {
            private _marker = format ["flr_m_%1_%2", diag_tickTime, _schedCounter];
            [_marker, _minePos, "ICON", "mil_dot", _debugColor, 0.4, ""] call VIC_fnc_createGlobalMarker;
            
            if (_visWireDir != -1) then {
                 private _markerLine = format ["flr_l_%1_%2", diag_tickTime, _schedCounter];
                 createMarker [_markerLine, _minePos];
                 _markerLine setMarkerShape "RECTANGLE";
                 _markerLine setMarkerBrush "Solid";
                 _markerLine setMarkerColor _debugColor;
                 _markerLine setMarkerDir _visWireDir; 
                 _markerLine setMarkerSize [0.1, 2.5]; 
                 _markerLine setMarkerAlpha 0.6;
            };
        };
    };
    
} forEach _selectedEdges;

_objs
