/*
    Spawns a WebKnight behemoth nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Behemoth"] call VIC_fnc_isMutantEnabled ) exitWith {
};

[_pos, "WBK_Goliaph_3"] call VIC_fnc_spawnMutantNest;
