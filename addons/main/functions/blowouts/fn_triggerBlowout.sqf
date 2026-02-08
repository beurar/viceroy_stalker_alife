#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Trigger a single blowout using Diwako's Anomalies.
    Params: None. All emission settings are handled by
    Diwako's Anomalies and should not be modified here.
*/
params [];


if (!isServer) exitWith {
};

// Start blowout using Diwako's server event with default parameters
["diwako_anomalies_main_startBlowout", []] call CBA_fnc_serverEvent;

