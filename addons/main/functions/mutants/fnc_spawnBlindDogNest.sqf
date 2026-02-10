#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a blind dog nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Blind Dog"] call FUNC(isMutantEnabled) ) exitWith {
};

private _classes = ["armst_blinddog1", "armst_blinddog2", "armst_blinddog3"];
[_pos, selectRandom _classes] call FUNC(spawnMutantNest);
