#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a WebKnight acid smasher nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Acid Smasher"] call FUNC(isMutantEnabled) ) exitWith {
};

[_pos, "WBK_SpecialZombie_Smasher_Acid_3"] call FUNC(spawnMutantNest);
