/*
    Spawns a WebKnight acid smasher nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Acid Smasher"] call VIC_fnc_isMutantEnabled ) exitWith {
};

[_pos, "WBK_SpecialZombie_Smasher_Acid_3"] call VIC_fnc_spawnMutantNest;
