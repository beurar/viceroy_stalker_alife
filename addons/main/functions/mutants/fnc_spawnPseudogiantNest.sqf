#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a pseudogiant nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Pseudogiant"] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith {
};

private _classes = ["armst_giant", "armst_giant2"];
[_pos, selectRandom _classes] call viceroy_stalker_alife_mutants_fnc_spawnMutantNest;
