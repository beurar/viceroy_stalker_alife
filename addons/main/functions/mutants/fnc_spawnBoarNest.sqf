#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a boar nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Boar"] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith {
};

private _classes = ["armst_boar", "armst_boar2"];
[_pos, selectRandom _classes] call viceroy_stalker_alife_mutants_fnc_spawnMutantNest;
