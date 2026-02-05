/*
    Spawns an izlom nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Izlom"] call VIC_fnc_isMutantEnabled ) exitWith {
};

[_pos, "armst_izlom"] call VIC_fnc_spawnMutantNest;
