#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Retrieves a setting directly from the mission namespace with a
    fallback value.

    Params:
        0: STRING - setting variable name
        1: ANY    - default value if the setting is undefined

    Returns:
        ANY - value of the setting or the provided default
*/
params ["_name", "_default"];

private _value = missionNamespace getVariable [_name, _default];
_value

