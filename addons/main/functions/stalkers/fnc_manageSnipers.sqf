#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Handles spawned sniper units. Snipers are removed when their
    spawns when players are nearby and despawns when they leave.
    STALKER_snipers entries: [group, position, anchor, marker, active]
*/


if (!isServer) exitWith {};
if (isNil "STALKER_snipers") exitWith {};

private _range = missionNamespace getVariable ["STALKER_activityRadius", 1500];
private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

// --- DYNAMIC GENERATION ---
// Run generation check periodically (every 60s approx)
private _lastGen = missionNamespace getVariable ["STALKER_lastSniperGen", 0];
if (diag_tickTime - _lastGen > 60) then {
    missionNamespace setVariable ["STALKER_lastSniperGen", diag_tickTime];

    // Pre-calc factions for this generation cycle
    private _factionsAll = [] call FUNC(getStalkerFactions);
    private _validFactionsGen = _factionsAll select { 
            private _sides = _x select 1;
            independent in _sides || opfor in _sides
    };
    if (_validFactionsGen isEqualTo []) then { _validFactionsGen = _factionsAll; };
    
    {
        sleep 0.1; // Yield between players to prevent frame stutter
        private _player = _x;
        // Only generate for players on foot or in slow vehicles
        if (speed _player < 80) then {
             // Check density
             private _nearbySnipers = {
                (_x select 2) distance2D _player < 1200
             } count STALKER_snipers;
             
             if (_nearbySnipers < 4) then { // Target: ~4 potential snipers in 1.2km radius
                 private _spots = [getPos _player, 500, 1000] call FUNC(findDynamicSniperSpots);
                 
                 // Add up to 2 new spots per cycle per player
                 private _added = 0;
                 {
                     if (_added >= 2) exitWith {};
                     
                     // Ensure not too close to existing
                     private _pos = _x;
                     private _tooClose = { (_x select 2) distance2D _pos < 300 } count STALKER_snipers > 0;
                     
                     if (!_tooClose) then {
                         private _anchor = [_pos] call FUNC(createProximityAnchor);
                         
                         private _marker = "";
                         if (_debug) then {
                             _marker = format ["snp_dyn_%1", diag_tickTime + _forEachIndex];
                             [_marker, _pos, "ICON", "mil_ambush", "#(1,0,0,1)", 0.6, "Sniper"] call FUNC(createGlobalMarker);
                         };
                         
                         private _siteFaction = selectRandom _validFactionsGen;

                         // Store [sniperGroup, assaultGroup, position, anchor, marker, active, faction]
                         STALKER_snipers pushBack [grpNull, grpNull, _pos, _anchor, _marker, false, _siteFaction];
                         _added = _added + 1;
                     };
                 } forEach _spots;
             };
        };
    } forEach allPlayers;
};


// --- UPDATE & CLEANUP ---

private _toDeleteIndices = [];

{
    _x params ["_snpGrp", "_grdGrp", "_pos", "_anchor", "_marker", "_active", ["_siteFaction", []]];

    // Cleanup Logic: Far from all players?
    private _nearAny = { _x distance2D _pos < 2500 } count allPlayers > 0;
    
    if (!_nearAny) then {
        // Mark for deletion
        _toDeleteIndices pushBack _forEachIndex;
        
        // Cleanup objects
        if (!isNull _snpGrp) then { { deleteVehicle _x } forEach units _snpGrp; deleteGroup _snpGrp; };
        if (!isNull _grdGrp) then { { deleteVehicle _x } forEach units _grdGrp; deleteGroup _grdGrp; };
        
        deleteVehicle _anchor;
        if (_marker != "") then { deleteMarker _marker; };
        
    } else {
        // Normal proximity update
        private _newActive = [_anchor,_range,_active] call FUNC(evalSiteProximity);

        if (_newActive) then {
            // ACTIVATE
            if (isNull _snpGrp || { units _snpGrp isEqualTo [] }) then {
                
                // 1. SELECT FACTION
                // Use stored faction if available, or pick new one (legacy support)
                private _chosenFaction = _siteFaction;
                if (_chosenFaction isEqualTo []) then {
                    private _factions = [] call FUNC(getStalkerFactions);
                    private _validFactions = _factions select { 
                        private _sides = _x select 1;
                        independent in _sides || opfor in _sides
                    };
                    if (_validFactions isEqualTo []) then { _validFactions = _factions; };
                    _chosenFaction = selectRandom _validFactions;
                    _siteFaction = _chosenFaction; // Save for next time
                };

                private _chosenSide = selectRandom (_chosenFaction select 1);
                
                private _unitClasses = _chosenFaction select 2;
                
                // Filter Roles
                private _snipers = _unitClasses select { ["sniper", _x] call BIS_fnc_inString || ["sharpshooter", _x] call BIS_fnc_inString };
                if (_snipers isEqualTo []) then { _snipers = ["O_sniper_F"]; };
                
                private _assaults = _unitClasses - _snipers;
                if (_assaults isEqualTo []) then { _assaults = ["O_Soldier_F"]; };
                

                // 2. SPAWN SNIPERS
                _snpGrp = createGroup [_chosenSide, true];
                
                // Determine capacity based on building positions
                private _bld = nearestBuilding _pos;
                private _maxSnipers = 0;
                private _bldPos = [];
                
                if (!isNull _bld && { _pos distance _bld < 30 }) then {
                    _bldPos = _bld buildingPos -1;
                    // Filter: Upper floors only (Z > 2.5m) to avoid ground floor camping
                    private _upperPos = _bldPos select { (_x select 2) > 2.5 };
                    if (_upperPos isNotEqualTo []) then {
                        _bldPos = _upperPos;
                    };
                    
                    if (count _bldPos > 0) then {
                        _maxSnipers = (count _bldPos) min 4; 
                    };
                };
                
                // ABORT IF NO VALID BUILDING (Safety Check)
                if (isNull _bld || _maxSnipers == 0) exitWith {
                    // Cleanup this site immediately so it can regenerate elsewhere
                    deleteVehicle _anchor;
                    if (_marker != "") then { deleteMarker _marker; };
                    STALKER_snipers set [_forEachIndex, "DELETE_ME"]; 
                    if (!isNull _snpGrp) then { deleteGroup _snpGrp; };
                    if (!isNull _grdGrp) then { deleteGroup _grdGrp; };
                };

                // Randomize count (1 to Max)
                private _sniperCount = (floor random _maxSnipers) + 1;
                
                for "_i" from 1 to _sniperCount do {
                    private _type = selectRandom _snipers;
                    private _spawnPos = [0,0,0];
                    
                    if (_bldPos isNotEqualTo []) then {
                        _spawnPos = selectRandom _bldPos; 
                        _bldPos = _bldPos - [_spawnPos]; // Remove used spot
                    };
                    
                    if (_spawnPos isEqualTo [0,0,0]) exitWith {}; // Safety
                    
                    private _unit = _snpGrp createUnit [_type, _spawnPos, [], 0, "CAN_COLLIDE"];
                    _unit setPosATL _spawnPos;
                    [_unit] joinSilent _snpGrp; 
                    
                    // Sniper Setup
                    _unit disableAI "PATH";
                    _unit forceSpeed 0;
                    _unit setSkill 1;
                    _unit setUnitPos "UP"; 
                    _unit spawn { sleep 10; _this setUnitPos "AUTO"; }; 
                    
                    _unit setVariable ["VIC_isSniper", true];
                    _unit allowFleeing 0; 
                    
                    _unit enableAI "TARGET";
                    _unit enableAI "AUTOTARGET"; 
                    _unit enableAI "ANIM";

                    [_unit] call FUNC(sniperScan);
                };
                
                // 3. SPAWN GROUND TEAM (2-4)
                _grdGrp = createGroup [_chosenSide, true];
                
                private _groundCount = (floor random 3) + 2; 
                private _groundCenter = [_pos select 0, _pos select 1, 0];
                private _safePos = [_groundCenter, 0, 80, 2, 0, 20, 0] call BIS_fnc_findSafePos;
                
                for "_i" from 1 to _groundCount do {
                     private _type = selectRandom _assaults;
                     private _unit = _grdGrp createUnit [_type, _safePos, [], 5, "NONE"];
                     [_unit] joinSilent _grdGrp; 
                     _unit setSkill (0.5 + (random 0.3));
                     _unit setUnitPos "AUTO";
                };

                // Spawn Perimeter (passing owner side now)
                [_pos, 200, 15, [_snpGrp, _grdGrp], _chosenSide] spawn FUNC(spawnSmartFlarePerimeter);
                
                // 4. GROUP BEHAVIOR
                _snpGrp setBehaviour "COMBAT"; _snpGrp setCombatMode "RED";
                _grdGrp setBehaviour "AWARE";  _grdGrp setCombatMode "YELLOW";
                
                // Start Assault Logic passing both groups
                [_snpGrp, _grdGrp] call FUNC(sniperAssaultLogic);
            };
            if (_marker != "") then { _marker setMarkerAlpha 1; };
        } else {
            // DEACTIVATE
            if (!isNull _snpGrp) then { { deleteVehicle _x } forEach units _snpGrp; deleteGroup _snpGrp; _snpGrp = grpNull; };
            if (!isNull _grdGrp) then { { deleteVehicle _x } forEach units _grdGrp; deleteGroup _grdGrp; _grdGrp = grpNull; };
            
            if (_marker != "") then { _marker setMarkerAlpha 0.2; };
        };
        
        // Update entry
        if ((STALKER_snipers select _forEachIndex) isEqualType []) then {
            STALKER_snipers set [_forEachIndex, [_snpGrp, _grdGrp, _pos, _anchor, _marker, _newActive, _siteFaction]];
        };
    };
} forEach STALKER_snipers;

// Remove deleted entries
if (_toDeleteIndices isNotEqualTo []) then {
    // deleteAt alters indices, so delete from end to start
    _toDeleteIndices sort false;
    private _reverseIndices = [];
    { _reverseIndices pushBack _x } forEach _toDeleteIndices;
    reverse _reverseIndices;
    
    {
        STALKER_snipers deleteAt _x;
    } forEach _reverseIndices;
};

// Also cleanup "DELETE_ME" markers (created during failed spawn)
for "_i" from (count STALKER_snipers - 1) to 0 step -1 do {
    if ((STALKER_snipers select _i) isEqualTo "DELETE_ME") then {
        STALKER_snipers deleteAt _i;
    };
};

true
