#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a WebKnight smasher nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Smasher"] call VIC_fnc_isMutantEnabled ) exitWith {
};

[_pos, "WBK_SpecialZombie_Smasher_3"] call VIC_fnc_spawnMutantNest;
