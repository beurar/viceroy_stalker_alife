#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a snork nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Snork"] call FUNC(isMutantEnabled) ) exitWith {
};

[_pos, "armst_snork"] call FUNC(spawnMutantNest);
