#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Author: Codex
    Description:
        Periodically schedules psy storms or listens for a manual trigger.
        If a variable name is provided as third parameter the storm will
        also trigger whenever that variable is set to true in the mission
        namespace.

    Params:
        0: NUMBER - minimum delay between storms in seconds (default 1800)
        1: NUMBER - maximum delay between storms in seconds (default 3600)
        2: STRING - missionNamespace variable used for manual trigger (optional)
*/

params [
    ["_minDelay", 1800],
    ["_maxDelay", 3600],
    ["_manualVar", ""]
];


if (["VSA_enableStorms", true] call FUNC(getSetting) isEqualTo false) exitWith {};

private _interval = ["VSA_stormInterval", 30] call FUNC(getSetting);
private _spawnWeight = ["VSA_stormSpawnWeight", 50] call FUNC(getSetting);
private _nightOnly = ["VSA_stormsNightOnly", false] call FUNC(getSetting);
private _duration = ["VSA_stormDuration", 180] call FUNC(getSetting);
private _lightningStart = ["VSA_stormLightningStart", 6] call FUNC(getSetting);
private _lightningEnd   = ["VSA_stormLightningEnd", 12] call FUNC(getSetting);
private _dischargeStart = ["VSA_stormDischargeStart", 6] call FUNC(getSetting);
private _dischargeEnd   = ["VSA_stormDischargeEnd", 12] call FUNC(getSetting);
private _fogEnd         = ["VSA_stormFogEnd", 0.6] call FUNC(getSetting);
private _rainEnd        = ["VSA_stormRainEnd", 0.8] call FUNC(getSetting);
private _overcastEnd    = ["VSA_stormOvercast", 1] call FUNC(getSetting);
private _overcastTime   = ["VSA_stormOvercastTime", 60] call FUNC(getSetting);

_minDelay = ["VSA_stormMinDelay", _minDelay] call FUNC(getSetting);
_maxDelay = ["VSA_stormMaxDelay", _maxDelay] call FUNC(getSetting);

if (_minDelay < 0) then { _minDelay = 0; };
if (_maxDelay < _minDelay) then { _maxDelay = _minDelay; };

[_minDelay, _maxDelay, _manualVar, _spawnWeight, _nightOnly, _duration, _lightningStart, _lightningEnd, _dischargeStart, _dischargeEnd, _fogEnd, _rainEnd, _overcastEnd, _overcastTime] spawn {
    params ["_min", "_max", "_var", "_weight", "_night", "_dur", "_lStart", "_lEnd", "_dStart", "_dEnd", "_fEnd", "_rEnd", "_oEnd", "_oTime"];
    private _nextStorm = time + (_min + random (_max - _min));
    while {true} do {
        if (_var != "" && { missionNamespace getVariable [_var, false] }) then {
            missionNamespace setVariable [_var, false, true];
            if (random 100 < _weight && { !(_night && dayTime > 5 && dayTime < 20) }) then {
                ["Increased psy activity has been detected. We're expecting a psystorm imminently boys."] remoteExec ["FUNC(radioMessage)", 0];
                [_dur, _lStart, _lEnd, _dStart, _dEnd, _fEnd, _rEnd, _oEnd, _oTime] call FUNC(triggerPsyStorm);
            };
            _nextStorm = time + (_min + random (_max - _min));
        };

        if (time >= _nextStorm) then {
            if (random 100 < _weight && { !(_night && dayTime > 5 && dayTime < 20) }) then {
                ["Increased psy activity has been detected. We're expecting a psystorm imminently boys."] remoteExec ["FUNC(radioMessage)", 0];
                [_dur, _lStart, _lEnd, _dStart, _dEnd, _fEnd, _rEnd, _oEnd, _oTime] call FUNC(triggerPsyStorm);
            };
            _nextStorm = time + (_min + random (_max - _min));
        };
        sleep 5;
    };
};
