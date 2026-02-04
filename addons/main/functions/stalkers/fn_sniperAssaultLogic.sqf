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
    
    // Main Loop
    while { !isNull _snpGrp && { {alive _x} count units _snpGrp > 0 } && !isNull _assaultGrp } do {
        
        sleep 5;
        
        // 1. CHECK SNIPER TARGETS
        private _leader = leader _snpGrp;
        private _enemy = _leader findNearestEnemy _leader;
        
        // Valid enemy within range?
        if (!isNull _enemy && { _enemy distance _leader < _radius }) then {
            
            // 2. ALERT ASSAULT TEAM
            // Reveal target to assault leader
            private _assaultLeader = leader _assaultGrp;
            _assaultGrp reveal [_enemy, 4];
            
            // Only issue new move orders if explicitly needed or target changed significantly
            private _lastTarget = _assaultGrp getVariable ["VIC_lastAssaultTarget", objNull];
            
            if (_enemy != _lastTarget || (_assaultLeader distance _enemy > 50 && unitReady _assaultLeader)) then {
                _assaultGrp setVariable ["VIC_lastAssaultTarget", _enemy];
                
                // Clear existing waypoints (Safely)
                for "_i" from count waypoints _assaultGrp - 1 to 0 step -1 do {
                    deleteWaypoint [_assaultGrp, _i];
                };
                
                // Order: SAD (Search and Destroy)
                private _wp = _assaultGrp addWaypoint [getPos _enemy, 0];
                _wp setWaypointType "SAD";
                _wp setWaypointSpeed "FULL";
                _wp setWaypointBehaviour "COMBAT";
                
                _assaultGrp setCombatMode "RED";
                
                if (["VSA_debugMode", false] call VIC_fnc_getSetting) then {
                    systemChat format ["Sniper Spotter (%2): Unleashing Assault Team on %1", name _enemy, groupId _snpGrp];
                };
            };
            
        } else {
             // No enemies? If assault team is far from snipers, pull them back
             private _anchorPos = getPos (leader _snpGrp);
             if ((leader _assaultGrp) distance _anchorPos > 150) then {
                 // Return to base
                 if (currentWaypoint _assaultGrp >= count waypoints _assaultGrp) then {
                     private _wp = _assaultGrp addWaypoint [_anchorPos, 50];
                     _wp setWaypointType "GUARD";
                     _wp setWaypointSpeed "NORMAL";
                     _wp setWaypointBehaviour "AWARE";
                 };
             };
        };
    };
};
