#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Manages the behavior of a sniper team (snipers) and their security detail (assault).
    If an enemy is spotted by the sniper group, the mobile ground units are ordered to hunt them down.
    
    Params:
        0: GROUP - The Sniper / Spotter Group (Static)
        1: GROUP - The Assault / Guard Group (Mobile)
        2: NUMBER - Hunt radius (default 1000)
*/
params ["_snpGrp", "_assaultGrp", ["_radius", 1000]];

if (isNull _snpGrp || isNull _assaultGrp) exitWith {};

[_snpGrp, _assaultGrp, _radius] spawn {
    params ["_snpGrp", "_assaultGrp", "_radius"];
    
    // Mark this group as managed to avoid double scripts
    if (_snpGrp getVariable ["VIC_sniperAssaultActive", false]) exitWith {};
    _snpGrp setVariable ["VIC_sniperAssaultActive", true];
    
    _assaultGrp allowFleeing 0;
    
    // Determine LAMBS support (Safe Check)
    private _hasLambs = !isNil "lambs_wp_fnc_taskDefend";
    private _anchorPos = getPos (leader _snpGrp);
    
    // Initial State: DEFEND
    if (_hasLambs) then {
        // [group, pos, radius, type, reinforce?, active?]
        [_assaultGrp, _anchorPos, 50] spawn lambs_wp_fnc_taskDefend;
    } else {
        private _wp = _assaultGrp addWaypoint [_anchorPos, 50];
        _wp setWaypointType "GUARD";
        _wp setWaypointSpeed "NORMAL";
        _wp setWaypointBehaviour "AWARE";
    };
    
    _assaultGrp setVariable ["VIC_assaultState", "DEFEND"];

    // Main Loop
    while { !isNull _snpGrp && { {alive _x} count units _snpGrp > 0 } && !isNull _assaultGrp } do {
        
        sleep 10;
        
        private _snpLeader = leader _snpGrp;
        private _assaultLeader = leader _assaultGrp;
        
        // 1. CHECK SNIPER TARGETS
        private _enemy = _snpLeader findNearestEnemy _snpLeader;
        private _assaultEnemy = _assaultLeader findNearestEnemy _assaultLeader; // Assault's own eyes
        
        // Is there a sniper target in range?
        if (!isNull _enemy && { _enemy distance _snpLeader < _radius }) then {
            
            // 2. ALERT ASSAULT TEAM
            private _knowsVal = _assaultGrp knowsAbout _enemy;
            if (_knowsVal < 3) then { _assaultGrp reveal [_enemy, 4]; };
            
            // Command Logic: If they are currently defending, switch to ATTACK
            private _currentState = _assaultGrp getVariable ["VIC_assaultState", "DEFEND"];
            private _distToEnemy = _assaultLeader distance _enemy;
            
            // Switch to ATTACK if:
            // a) Currently Defending
            // b) Attacking, but new target is far from the "last known job"
            if (_currentState == "DEFEND" || (_distToEnemy > 150 && _assaultLeader distance (_assaultGrp getVariable ["VIC_lastAssaultPos", [0,0,0]]) > 100)) then {
                
                _assaultGrp setVariable ["VIC_assaultState", "ATTACK"];
                _assaultGrp setVariable ["VIC_lastAssaultPos", getPos _enemy];
                
                // Clear existing waypoints first
                for "_i" from count waypoints _assaultGrp - 1 to 0 step -1 do { deleteWaypoint [_assaultGrp, _i]; };
                
                if (_hasLambs) then {
                    // Switch to HUNT
                    // Using taskHunt for aggressive seeking
                    [_assaultGrp, getPos _enemy, _radius] spawn lambs_wp_fnc_taskHunt;
                } else {
                    // Vanilla Fallback
                    private _wp = _assaultGrp addWaypoint [getPos _enemy, 0];
                    _wp setWaypointType "SAD";
                    _wp setWaypointSpeed "FULL";
                    _wp setWaypointBehaviour "COMBAT";
                    _assaultGrp setCombatMode "RED";
                };
                
                if (["VSA_debugMode", false] call FUNC(getSetting)) then {
                    systemChat format ["Sniper Spotter (%2): Ordering Assault Team to Hunt %1", name _enemy, groupId _snpGrp];
                };
            };
            
        } else {
             // No enemies spotted by Snipers.
             // If Assault team also has no enemies, return to DEFEND logic.
             if (isNull _assaultEnemy || { _assaultEnemy distance _assaultLeader > _radius }) then {
                 
                 private _currentState = _assaultGrp getVariable ["VIC_assaultState", "DEFEND"];
                 
                 // If we were Attacking, check if we drifted too far from base
                 if (_currentState == "ATTACK") then {
                     if (_assaultLeader distance _anchorPos > 100) then {
                         // Pull back
                         _assaultGrp setVariable ["VIC_assaultState", "DEFEND"];
                         
                         // Clear Waypoints
                         for "_i" from count waypoints _assaultGrp - 1 to 0 step -1 do { deleteWaypoint [_assaultGrp, _i]; };
                         
                         if (_hasLambs) then {
                             [_assaultGrp, _anchorPos, 50] spawn lambs_wp_fnc_taskDefend;
                         } else {
                             private _wp = _assaultGrp addWaypoint [_anchorPos, 50];
                             _wp setWaypointType "GUARD";
                             _wp setWaypointSpeed "NORMAL";
                             _wp setWaypointBehaviour "AWARE";
                         };
                     };
                 };
             };
        };
    };
};
