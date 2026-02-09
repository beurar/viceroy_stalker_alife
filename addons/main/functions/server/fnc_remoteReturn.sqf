#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Stores a value in missionNamespace using the provided variable name.
    Params:
        0: STRING - variable name
        1: ANY    - value to assign
*/
params ["_var", "_value"];

missionNamespace setVariable [_var, _value];

true
