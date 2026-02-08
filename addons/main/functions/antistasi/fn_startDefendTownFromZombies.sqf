#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts the Defend Town from Zombies mission for Antistasi
    - Randomly selects a friendly town at night
    - Calls the mission logic
*/

if !(call VIC_fnc_isAntistasiUltimate) exitWith {false};
if (!isServer) exitWith {false};

// Only run at night
if !(dayTime < 5 || dayTime > 20) exitWith {false};

// Get list of friendly towns (replace with actual Antistasi town array)
private _towns = missionNamespace getVariable ["A3A_townList", []];
if (_towns isEqualTo []) exitWith {false};

private _entry = selectRandom _towns;
_entry params ["_townPos", "_townName"];

// Start the mission
[_townPos, _townName] call antistasi_fnc_defendTownFromZombies;

if (!isNil "A3U_fnc_createTask") then {
    ["VIC_DefendTownFromZombies","Defend Town","Defend the town from a zombie attack!",_townPos] call A3U_fnc_createTask;
};

true
