#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a cat nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Cat"] call FUNC(isMutantEnabled) ) exitWith {
};

[_pos, "armst_cat"] call FUNC(spawnMutantNest);
