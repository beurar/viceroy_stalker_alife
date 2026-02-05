/*
    Spawns a snork nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Snork"] call VIC_fnc_isMutantEnabled ) exitWith {
};

[_pos, "armst_snork"] call VIC_fnc_spawnMutantNest;
