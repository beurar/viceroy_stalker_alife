/*
    Makes a sniper unit periodically scan the horizon/surroundings.
    
    Params:
        0: OBJECT - The unit to control
        1: NUMBER - Scan range (distance to look at) default 800
        2: NUMBER - Update interval (seconds) default 6-12
*/
params ["_unit", ["_range", 800], ["_interval", 10]];

if (!alive _unit) exitWith {};

[_unit, _range, _interval] spawn {
    params ["_unit", "_range", "_interval"];
    
    _unit setVariable ["VIC_sniperScanning", true];
    
    private _dir = getDir _unit;
    private _baseDir = _dir; // Remember the initial direction as the "front"
    
    while { alive _unit && _unit getVariable ["VIC_sniperScanning", true] } do {
        
        // Don't scan if engaged in combat (Arma AI handles that)
        if (behaviour _unit != "COMBAT") then {
            
            // Pick a random offset from the base direction (+- 60 degrees)
            private _scanDir = _baseDir + (random 120) - 60;
            
            // Sometimes look completely around (check 6)
            if (random 100 < 10) then {
                _scanDir = _baseDir + 180;
            };
            
            private _watchPos = _unit getPos [_range, _scanDir];
            _watchPos set [2, (getPosASL _unit select 2)]; // Keep eye level roughly
            
            _unit doWatch _watchPos;
            
            // Occasionally use binoculars if available
            if ("Binocular" in (items _unit + assignedItems _unit) && random 100 < 30) then {
                _unit selectWeapon "Binocular";
            } else {
                if (currentWeapon _unit == "Binocular") then {
                    _unit selectWeapon (primaryWeapon _unit);
                };
            };
        };
        
        sleep (_interval + (random 5));
    };
};
