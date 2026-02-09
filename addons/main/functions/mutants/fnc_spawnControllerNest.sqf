#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a controller nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Controller"] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith {
};

private _classes = ["armst_controller_new", "armst_controller_new2", "armst_controller_new3"];
[_pos, selectRandom _classes] call viceroy_stalker_alife_mutants_fnc_spawnMutantNest;
