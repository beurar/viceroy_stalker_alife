#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Author: Viceroy
    Description:
    Scans the map for Smart Terrains (Sniper Nests, Anomalies, Haunted Areas) and marks them.
    Stores results in global variable VSA_SmartTerrains.
    
    Command:
    [] call VIC_fnc_scanMap;
*/

scriptName "VIC_fnc_scanMap";

if (!canSuspend) exitWith { 
    systemChat "Running Smart Terrain Scan in background...";
    [] spawn VIC_fnc_scanMap; 
};

systemChat "--- Starting Smart Terrain Scan ---";
diag_log "VSA: Starting Smart Terrain Scan";

// 1. Cleanup old markers and data
private _oldMarkers = allMapMarkers select { _x find "Smart_" == 0 };
{ deleteMarker _x } forEach _oldMarkers;
VSA_SmartTerrains = [];

private _worldSize = worldSize;
private _centerMap = [_worldSize/2, _worldSize/2];

// ---------------------------------------------------------
// Phase 1: Scan Existing Locations for Tactical Positions
// ---------------------------------------------------------
systemChat "Phase 1: Analyzing Settlements...";

private _locations = nearestLocations [_centerMap, ["NameCity", "NameCityCapital", "NameVillage", "NameLocal", "Hill", "ViewPoint"], _worldSize * 1.5];

{
    private _locPos = locationPosition _x;
    private _locName = text _x;
    private _locType = type _x;
    
    // -- Find Sniper/Vantage Points overlapping this location --
    // We look for positions that overlook this location (300-600m away)
    private _spots = [_locPos, 300, 600] call VIC_fnc_findDynamicSniperSpots;
    
    // Group close spots to avoid clutter
    private _clusters = [];
    {
        private _spot = _x;
        private _added = false;
        {
            _x params ["_cPos", "_cCount"];
            if (_spot distance2D _cPos < 50) exitWith {
                _x set [1, _cCount + 1];
                _added = true;
            };
        } forEach _clusters;
        
        if (!_added) then {
            _clusters pushBack [_spot, 1];
        };
    } forEach _spots;
    
    // Mark the best clusters
    {
        _x params ["_cPos", "_cCount"];
        if (_cCount >= 1) then { // Threshold
            private _radius = 50;
            private _id = format ["Smart_Sniper_%1_%2", _locName, _forEachIndex];
            
            // Marker for Area
            private _marker = createMarker [_id, _cPos];
            _marker setMarkerShape "ELLIPSE";
            _marker setMarkerSize [_radius, _radius];
            _marker setMarkerBrush "SolidBorder";
            _marker setMarkerColor "ColorRed";
            _marker setMarkerAlpha 0.3;
            
            // Marker for Icon
            private _icon = createMarker [_id + "_icon", _cPos];
            _icon setMarkerType "mil_triangle";
            _icon setMarkerColor "ColorRed";
            _icon setMarkerText format ["Sniper Nest (%1)", _locName];
            
            VSA_SmartTerrains pushBack ["SniperNest", _cPos, _radius, format ["Overlook %1", _locName]];
        };
    } forEach _clusters;
    
    sleep 0.05; // Yield
} forEach _locations;


// ---------------------------------------------------------
// Phase 2: Grid Scan for Wilderness Features
// ---------------------------------------------------------
systemChat "Phase 2: Scanning Wilderness...";

private _gridStep = 800; // 800m grid
private _countX = floor (_worldSize / _gridStep);

for "_xi" from 0 to _countX do {
    for "_yi" from 0 to _countX do {
        private _pos = [_xi * _gridStep, _yi * _gridStep];
        if (surfaceIsWater _pos) then { continue; };
        
        // -- 2a. Anomalous Zones (Open, flat, remote) --
        // Use selectBestPlaces to check terrain type
        private _meadowCheck = selectBestPlaces [_pos, 100, "(meadow + 2*trees) * (1 - houses)", 50, 1];
        
        if (_meadowCheck isNotEqualTo []) then {
            // Check remoteness (dist to nearest city)
            private _nearCity = nearestLocation [_pos, "NameCity"];
            if ((locationPosition _nearCity) distance2D _pos > 1000) then {
                
                // Random chance to be an anomaly field if conditions met
                // (In a real tool we might check for specific terrain objects or flatness)
                if (random 100 < 15) then { 
                    private _radius = 80;
                    private _id = format ["Smart_Anomaly_%1_%2", _xi, _yi];
                    
                    private _marker = createMarker [_id, _pos];
                    _marker setMarkerShape "ELLIPSE";
                    _marker setMarkerSize [_radius, _radius];
                    _marker setMarkerBrush "DiagGrid";
                    _marker setMarkerColor "ColorOrange";
                    _marker setMarkerAlpha 0.5;
                    
                    private _icon = createMarker [_id + "_icon", _pos];
                    _icon setMarkerType "mil_warning";
                    _icon setMarkerColor "ColorOrange";
                    _icon setMarkerText "Potential Anomaly Field";
                    
                    VSA_SmartTerrains pushBack ["AnomalyField", _pos, _radius, "Wilderness Field"];
                };
            };
        };
        
        // -- 2b. Haunted Areas (Ruins, remote) --
        private _ruins = nearestTerrainObjects [_pos, ["Ruins", "Church", "Chapel", "Watertower"], 400];
        if (count _ruins > 0) then {
             private _centerRuins = [0,0,0];
             { _centerRuins = _centerRuins vectorAdd (getPos _x) } forEach _ruins;
             _centerRuins = _centerRuins vectorMultiply (1 / count _ruins);
             
             // Check if we already marked near here
             private _alreadyMarked = false;
             {
                _x params ["_type", "_mPos"];
                if (_type == "HauntedArea" && (_mPos distance2D _centerRuins < 500)) exitWith { _alreadyMarked = true; };
             } forEach VSA_SmartTerrains;
             
             if (!_alreadyMarked) then {
                 private _radius = 100;
                 private _id = format ["Smart_Haunt_%1_%2", _xi, _yi];
                 
                 private _marker = createMarker [_id, _centerRuins];
                 _marker setMarkerShape "ELLIPSE";
                 _marker setMarkerSize [_radius, _radius];
                 _marker setMarkerBrush "Cross";
                 _marker setMarkerColor "ColorGUER"; // Greenish
                 
                 private _icon = createMarker [_id + "_icon", _centerRuins];
                 _icon setMarkerType "loc_Ruins";
                 _icon setMarkerColor "ColorGUER";
                 _icon setMarkerText "Haunted Grounds";
                 
                 VSA_SmartTerrains pushBack ["HauntedArea", _centerRuins, _radius, "Ruins"];
             };
        };

        sleep 0.01; // Yield
    };
};

systemChat format ["Scan Complete. Found %1 Smart Terrains.", count VSA_SmartTerrains];
["SmartTerrain", format ["Scan finished. %1 terrains found.", count VSA_SmartTerrains]] call BIS_fnc_logFormat;

// Copy to clipboard for easy extraction
copyToClipboard str VSA_SmartTerrains;
systemChat "Data copied to clipboard.";
