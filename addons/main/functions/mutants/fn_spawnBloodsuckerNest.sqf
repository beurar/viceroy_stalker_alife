#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a bloodsucker nest at the given position and records it for ALife management.
    Params:
        0: POSITION - location of the nest
*/
params ["_pos"];


if !( ["Bloodsucker"] call VIC_fnc_isMutantEnabled ) exitWith {
};

private _classes = ["armst_krovosos", "armst_krovosos2"];
[_pos, selectRandom _classes] call VIC_fnc_spawnMutantNest;
