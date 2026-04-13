#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Debug toggle for world light fixtures. Forces all tracked lights
    OFF (damage flicker state) or ON (restored damage).
    Params: none
*/

if (!isServer) exitWith {};

private _forceOff = !(missionNamespace getVariable ["VSA_blowoutWorldLightsDebugForceOff", false]);
missionNamespace setVariable ["VSA_blowoutWorldLightsDebugForceOff", _forceOff, true];
missionNamespace setVariable ["VSA_blowoutWorldLightsDebugMode", [0, 1] select _forceOff, true];
missionNamespace setVariable ["VSA_blowoutWorldLightsForceRescan", true];

private _stateText = ["ON", "OFF"] select _forceOff;
[format ["[VSA DEBUG] World lights forced %1", _stateText]] remoteExec ["systemChat", 0];
