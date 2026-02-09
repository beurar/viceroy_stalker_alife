#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns an izlom nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Izlom"] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith {
};

[_pos, "armst_izlom"] call viceroy_stalker_alife_mutants_fnc_spawnMutantNest;
