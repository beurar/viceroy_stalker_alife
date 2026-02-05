/*
    Spawns a pseudodog nest at the given position.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Pseudodog"] call VIC_fnc_isMutantEnabled ) exitWith {
};

private _classes = ["armst_pseudodog", "armst_pseudodog2"];
[_pos, selectRandom _classes] call VIC_fnc_spawnMutantNest;
