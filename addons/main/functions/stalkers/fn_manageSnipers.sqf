/*
    Handles spawned sniper units. Snipers are removed when their
    spawns when players are nearby and despawns when they leave.
    STALKER_snipers entries: [group, position, anchor, marker, active]
*/

// ["manageSnipers"] call VIC_fnc_debugLog;

if (!isServer) exitWith {};
if (isNil "STALKER_snipers") exitWith {};

private _range = missionNamespace getVariable ["STALKER_activityRadius", 1500];
private _debug = ["VSA_debugMode", false] call VIC_fnc_getSetting;

// --- DYNAMIC GENERATION ---
// Run generation check periodically (every 60s approx)
private _lastGen = missionNamespace getVariable ["STALKER_lastSniperGen", 0];
if (diag_tickTime - _lastGen > 60) then {
    missionNamespace setVariable ["STALKER_lastSniperGen", diag_tickTime];

    // Pre-calc factions for this generation cycle
    private _factionsAll = [] call VIC_fnc_getStalkerFactions;
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
                 private _spots = [getPos _player, 500, 1000] call VIC_fnc_findDynamicSniperSpots;
                 
                 // Add up to 2 new spots per cycle per player
                 private _added = 0;
                 {
                     if (_added >= 2) exitWith {};
                     
                     // Ensure not too close to existing
                     private _pos = _x;
                     private _tooClose = { (_x select 2) distance2D _pos < 300 } count STALKER_snipers > 0;
                     
                     if (!_tooClose) then {
                         private _anchor = [_pos] call VIC_fnc_createProximityAnchor;
                         
                         private _marker = "";
                         if (_debug) then {
                             _marker = format ["snp_dyn_%1", diag_tickTime + _forEachIndex];
                             [_marker, _pos, "ICON", "mil_ambush", "#(1,0,0,1)", 0.6, "Sniper"] call VIC_fnc_createGlobalMarker;
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
        private _newActive = [_anchor,_range,_active] call VIC_fnc_evalSiteProximity;

        if (_newActive) then {
            // ACTIVATE
            if (isNull _snpGrp || { units _snpGrp isEqualTo [] }) then {
                
                // 1. SELECT FACTION
                // Use stored faction if available, or pick new one (legacy support)
                private _chosenFaction = _siteFaction;
                if (_chosenFaction isEqualTo []) then {
                    private _factions = [] call VIC_fnc_getStalkerFactions;
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
                
                // 2. SPAWN SNIPER (1-2)
                _snpGrp = createGroup [_chosenSide, true];
                
                private _sniperCount = (floor random 2) + 1; // 1 or 2
                
                for "_i" from 1 to _sniperCount do {
                    private _type = selectRandom _snipers;
                    
                    // Improved Spawning: Avoid stacking on the same pixel
                    private _spawnPos = _pos;
                    if (_i > 1) then {
                         // Try to find another building position if possible
                         private _bld = nearestBuilding _pos;
                         if (!isNull _bld && { _pos distance _bld < 5 }) then {
                            private _bldPos = _bld buildingPos -1;
                             // Find one that is high up but different from first
                             // Assuming _pos is already a high one.
                             private _avail = _bldPos select { _x distance _pos > 2 && (_x select 2) > 3 };
                             if (_avail isNotEqualTo []) then {
                                 _spawnPos = selectRandom _avail;
                             } else {
                                 // Just minimal offset
                                 _spawnPos = _pos getPos [1.5, random 360];
                             };
                         } else {
                             // Terrain offset
                             _spawnPos = _pos getPos [2 + (random 1), random 360];
                         };
                    };
                    
                    private _unit = _snpGrp createUnit [_type, _spawnPos, [], 0, "CAN_COLLIDE"];
                    _unit setPosATL _spawnPos;
                    [_unit] joinSilent _snpGrp; // Force side adherence
                    
                    // Sniper Setup
                    _unit disableAI "PATH";
                    _unit forceSpeed 0;
                    _unit setSkill 1;
                    
                    // Allow stance changes, but start standing for better visibility
                    _unit setUnitPos "UP"; 
                    _unit spawn { sleep 10; _this setUnitPos "AUTO"; }; 
                    
                    _unit setVariable ["VIC_isSniper", true];
                    _unit allowFleeing 0; // Don't run away
                    
                    // Ensure they can turn
                    _unit enableAI "TARGET";
                    _unit enableAI "AUTOTARGET"; 
                    _unit enableAI "ANIM";

                    [_unit] call VIC_fnc_sniperScan;
                };
                
                // 3. SPAWN GROUND TEAM (2-4)
                _grdGrp = createGroup [_chosenSide, true];
                
                private _groundCount = (floor random 3) + 2; 
                
                // Find safe ground position near base
                private _groundCenter = [_pos select 0, _pos select 1, 0];
                private _safePos = [_groundCenter, 0, 80, 2, 0, 20, 0] call BIS_fnc_findSafePos;
                
                for "_i" from 1 to _groundCount do {
                     private _type = selectRandom _assaults;
                     private _unit = _grdGrp createUnit [_type, _safePos, [], 5, "NONE"];
                     [_unit] joinSilent _grdGrp; // Force side adherence
                     _unit setSkill (0.5 + (random 0.3));
                     _unit setUnitPos "AUTO";
                };

                [_pos, 200, 30] call VIC_fnc_spawnSmartFlarePerimeter;
                
                // 4. GROUP BEHAVIOR
                _snpGrp setBehaviour "COMBAT"; _snpGrp setCombatMode "RED";
                _grdGrp setBehaviour "AWARE";  _grdGrp setCombatMode "YELLOW";
                
                // Start Assault Logic passing both groups
                [_snpGrp, _grdGrp] call VIC_fnc_sniperAssaultLogic;
            };
            if (_marker != "") then { _marker setMarkerAlpha 1; };
        } else {
            // DEACTIVATE
            if (!isNull _snpGrp) then { { deleteVehicle _x } forEach units _snpGrp; deleteGroup _snpGrp; _snpGrp = grpNull; };
            if (!isNull _grdGrp) then { { deleteVehicle _x } forEach units _grdGrp; deleteGroup _grdGrp; _grdGrp = grpNull; };
            
            if (_marker != "") then { _marker setMarkerAlpha 0.2; };
        };
        
        // Update entry
        STALKER_snipers set [_forEachIndex, [_snpGrp, _grdGrp, _pos, _anchor, _marker, _newActive, _siteFaction]];
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

true
