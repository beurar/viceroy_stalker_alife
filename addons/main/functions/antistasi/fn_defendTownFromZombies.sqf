#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Antistasi Custom Mission: Defend Friendly Town from Zombie Attack
    - Randomly triggers at night
    - Rewards $20 per zombie killed
*/

params ["_townPos", "_townName"];

// Only run at night
if !(dayTime < 5 || dayTime > 20) exitWith {};

// Spawn zombies attacking the town
private _zombieClasses = ["WBK_Zombie1","WBK_Zombie2","WBK_Zombie3"];
private _zombieCount = 20 + floor random 10;
private _zombies = [];
for "_i" from 1 to _zombieCount do {
    private _pos = _townPos getPos [random 100, random 360];
    private _zombie = (selectRandom _zombieClasses) createUnit [_pos, groupNull, "", 0, "NONE"];
    _zombies pushBack _zombie;
};

// Reward handler: $20 per zombie killed
{
    _x addEventHandler ["Killed", {
        params ["_unit", "_killer"];
        if (isPlayer _killer) then {
            _killer setVariable ["A3A_Money", (_killer getVariable ["A3A_Money", 0]) + 20, true];
            [format ["+$20 for killing a zombie! Total: $%1", _killer getVariable ["A3A_Money", 0]], "hint"] remoteExec ["BIS_fnc_showNotification", _killer];
        };
    }];
} forEach _zombies;

// Mission briefing
[format ["Defend %1 from a zombie attack! Survive until all zombies are dead.", _townName], "hint"] remoteExec ["BIS_fnc_showNotification", 0];

// Monitor mission completion
waitUntil { ({alive _x} count _zombies) == 0 };
["Mission complete! Town defended.", "hint"] remoteExec ["BIS_fnc_showNotification", 0];

// Cleanup
{ deleteVehicle _x } forEach _zombies;
