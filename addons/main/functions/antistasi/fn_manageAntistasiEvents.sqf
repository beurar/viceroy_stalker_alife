#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Antistasi Event Manager Extension
    - Periodically checks for night and randomly triggers the Defend Town from Zombies mission
*/

if !(call VIC_fnc_isAntistasiUltimate) exitWith {};
if (!isServer) exitWith {};

[] spawn {
    while {true} do {
        // Only check at night
        if (dayTime < 5 || dayTime > 20) then {
            if (random 1 < 0.05) then { // 5% chance per check
                [] call antistasi_fnc_startDefendTownFromZombies;
            };
        };
        sleep 300; // Check every 5 minutes
    };
};
