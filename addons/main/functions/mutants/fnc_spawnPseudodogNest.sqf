#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a pseudodog nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Pseudodog"] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith {
};

private _classes = ["armst_pseudodog", "armst_pseudodog2"];
[_pos, selectRandom _classes] call viceroy_stalker_alife_mutants_fnc_spawnMutantNest;
