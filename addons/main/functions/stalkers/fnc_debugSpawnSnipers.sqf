#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Debug function to force generation of sniper spots around a position
    and spawn them immediately with markers.
    
    Params:
        0: OBJECT/POSITION - location
*/
params ["_target"];

if (!isServer) exitWith {};

private _pos = _target call BIS_fnc_position;
private _spots = [_pos, 100, 1000] call FUNC(findDynamicSniperSpots);

["DebugSniper", format ["Found %1 spots near %2", count _spots, _pos]] call BIS_fnc_logFormat;
if (hasInterface) then {
    systemChat format ["Found %1 sniper spots.", count _spots];
};

{
     private _sPos = _x;
     // Visualize
     private _marker = format ["snp_debug_%1", diag_tickTime + _forEachIndex];
     [_marker, _sPos, "ICON", "mil_ambush", "#(1,0,0,1)", 0.8, "Debug Sniper"] call FUNC(createGlobalMarker);
     
     // Spawn immediately
     private _grp = createGroup east;
     
     // 1. SELECT FACTION
    private _factions = [] call FUNC(getStalkerFactions);
    private _validFactions = _factions select { 
            private _sides = _x select 1;
            independent in _sides || opfor in _sides
    };
    if (_validFactions isEqualTo []) then { _validFactions = _factions; };
    private _chosenFaction = selectRandom _validFactions;
    private _chosenSide = selectRandom (_chosenFaction select 1);
    
    private _unitClasses = _chosenFaction select 2;
    
    // Filter Roles
    private _snipers = _unitClasses select { ["sniper", _x] call BIS_fnc_inString || ["sharpshooter", _x] call BIS_fnc_inString };
    if (_snipers isEqualTo []) then { _snipers = ["O_sniper_F"]; };
    
    private _assaults = _unitClasses - _snipers;
    if (_assaults isEqualTo []) then { _assaults = ["O_Soldier_F"]; };
    
    // 2. SPAWN SNIPER (1-2)
    private _snpGrp = createGroup [_chosenSide, true];
    private _sniperCount = (floor random 2) + 1; // 1 or 2
    
    for "_i" from 1 to _sniperCount do {
        private _type = selectRandom _snipers;
        private _spawnPos = if (_i == 1) then { _sPos } else { _sPos vectorAdd [1, 1, 0] };
        
        private _unit = _snpGrp createUnit [_type, _spawnPos, [], 0, "CAN_COLLIDE"];
        _unit setPosATL _spawnPos;
        
        // Sniper Setup
        _unit disableAI "PATH";
        _unit forceSpeed 0;
        _unit setSkill 1;
        
        _unit setUnitPos "UP";
        _unit spawn { sleep 10; _this setUnitPos "AUTO"; };
        
        _unit setVariable ["VIC_isSniper", true];
        _unit allowFleeing 0;
        
        [_unit] call FUNC(sniperScan);
    };
    
    // 3. SPAWN GROUND TEAM (2-4)
    private _grdGrp = createGroup [_chosenSide, true];
    
    private _groundCount = (floor random 3) + 2; 
    
    // Find safe ground position near base
    private _groundCenter = [_sPos select 0, _sPos select 1, 0];
    private _safePos = [_groundCenter, 0, 80, 2, 0, 20, 0] call BIS_fnc_findSafePos;
    
    for "_i" from 1 to _groundCount do {
            private _type = selectRandom _assaults;
            private _unit = _grdGrp createUnit [_type, _safePos, [], 5, "NONE"];
            _unit setSkill (0.5 + (random 0.3));
            _unit setUnitPos "AUTO";
            [_unit] joinSilent _grdGrp;
    };

     // 4. PERIMETER
     [_sPos, 200, 30] spawn FUNC(spawnSmartFlarePerimeter);
     
     // Register in system so they get managed/deleted later
     private _anchor = [_sPos] call FUNC(createProximityAnchor);
     
     if (isNil "STALKER_snipers") then { STALKER_snipers = [] };
     STALKER_snipers pushBack [_snpGrp, _grdGrp, _sPos, _anchor, _marker, true];
     
     _snpGrp setBehaviour "COMBAT"; _snpGrp setCombatMode "RED";
     _grdGrp setBehaviour "AWARE";  _grdGrp setCombatMode "YELLOW";
     
     [_snpGrp, _grdGrp] call FUNC(sniperAssaultLogic);
     
} forEach _spots;
