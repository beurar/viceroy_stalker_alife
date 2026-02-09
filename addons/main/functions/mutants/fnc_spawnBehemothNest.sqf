#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a WebKnight behemoth nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Behemoth"] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith {
};

[_pos, "WBK_Goliaph_3"] call viceroy_stalker_alife_mutants_fnc_spawnMutantNest;
