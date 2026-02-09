#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns multiple stalker camps within an area.
    Params:
        0: POSITION - center position
        1: NUMBER   - search radius (default 500)
        2: NUMBER   - camp count (optional)
*/
params [["_center", [worldSize/2, worldSize/2, 0]], ["_radius",500], ["_count",-1]];



if (!isServer) exitWith {};

if (["VSA_enableStalkerCamps", true] call viceroy_stalker_alife_cba_fnc_getSetting isEqualTo false) exitWith {};

if (_count < 0) then { _count = ["VSA_stalkerCampCount",1] call viceroy_stalker_alife_cba_fnc_getSetting; };

for "_i" from 1 to _count do {
    private _building = [] call viceroy_stalker_alife_stalkers_fnc_findCampBuilding;
    if (isNull _building) exitWith {};
    private _campPos = getPosATL _building;
    [_campPos] call viceroy_stalker_alife_stalkers_fnc_spawnStalkerCamp;
};
