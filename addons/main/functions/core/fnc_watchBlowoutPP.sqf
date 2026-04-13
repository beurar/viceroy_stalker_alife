#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts a client-side blowout light watcher that reacts to
    `diwako_anomalies_main_blowOutStage` and applies a map-wide tint light.
    Params: none
*/

if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["VSA_blowoutPPWatcher", false]) exitWith {};
missionNamespace setVariable ["VSA_blowoutPPWatcher", true];

private _lightHandle = "#lightpoint" createVehicleLocal [0, 0, 0];
_lightHandle setLightUseFlare false;
_lightHandle setLightAmbient [1, 0.35, 0.08];
_lightHandle setLightColor [1, 0.35, 0.08];
_lightHandle setLightDayLight true;
_lightHandle setLightAttenuation [0, 0, 0, 1, 6000, 6500];
_lightHandle setLightBrightness 0;
missionNamespace setVariable ["VSA_blowoutLightHandle", _lightHandle];

missionNamespace setVariable ["VSA_blowoutPPStage", 0];
missionNamespace setVariable ["VSA_blowoutPPTarget", 0];
missionNamespace setVariable ["VSA_blowoutPPCurrent", 0];
missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", -1];
missionNamespace setVariable ["VSA_blowoutPPRiseTime", 1];
missionNamespace setVariable ["VSA_blowoutPPFallTime", 90];

[
    "diwako_anomalies_main_blowOutStage",
    {
        params ["_stage", ["_args", []]];

        missionNamespace setVariable ["VSA_blowoutPPStage", _stage];

        switch (_stage) do {
            case 1: {
                missionNamespace setVariable ["VSA_blowoutPPTarget", 0.25];
                missionNamespace setVariable ["VSA_blowoutPPRiseTime", 60];
                missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", -1];
            };
            case 2: {
                missionNamespace setVariable ["VSA_blowoutPPTarget", 0.55];
                missionNamespace setVariable ["VSA_blowoutPPRiseTime", 45];
                missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", -1];
            };
            case 3: {
                missionNamespace setVariable ["VSA_blowoutPPTarget", 0.85];
                missionNamespace setVariable ["VSA_blowoutPPRiseTime", 30];
                missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", -1];
            };
            case 4: {
                missionNamespace setVariable ["VSA_blowoutPPTarget", 1];
                missionNamespace setVariable ["VSA_blowoutPPRiseTime", 6];
                missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", diag_tickTime + 10];
            };
            default {
                missionNamespace setVariable ["VSA_blowoutPPTarget", 0];
                missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", -1];
            };
        };
    }
] call CBA_fnc_addEventHandler;

[] spawn {
    private _stepInterval = 0.1;
    private _lastLightUpdate = 0;

    while {true} do {
        private _lightHandleLocal = missionNamespace getVariable ["VSA_blowoutLightHandle", objNull];
        if (isNull _lightHandleLocal) exitWith {};

        private _stage = missionNamespace getVariable ["VSA_blowoutPPStage", 0];
        private _targetIntensity = missionNamespace getVariable ["VSA_blowoutPPTarget", 0];
        private _currentIntensity = missionNamespace getVariable ["VSA_blowoutPPCurrent", 0];
        private _fadeOutAt = missionNamespace getVariable ["VSA_blowoutPPFadeOutAt", -1];

        if (_stage isEqualTo 4 && {_fadeOutAt > 0} && {diag_tickTime >= _fadeOutAt}) then {
            _targetIntensity = 0;
            missionNamespace setVariable ["VSA_blowoutPPTarget", 0];
            missionNamespace setVariable ["VSA_blowoutPPFadeOutAt", -1];
        };

        private _delta = _targetIntensity - _currentIntensity;
        if (abs _delta > 0.001) then {
            private _riseTime = (missionNamespace getVariable ["VSA_blowoutPPRiseTime", 1]) max 0.1;
            private _fallTime = (missionNamespace getVariable ["VSA_blowoutPPFallTime", 90]) max 0.1;
            private _timeConstant = [_fallTime, _riseTime] select (_delta > 0);
            private _step = _stepInterval / _timeConstant;

            _currentIntensity = _currentIntensity + (_delta * _step);
            missionNamespace setVariable ["VSA_blowoutPPCurrent", _currentIntensity];
        } else {
            _currentIntensity = _targetIntensity;
            missionNamespace setVariable ["VSA_blowoutPPCurrent", _currentIntensity];
        };

        if (_currentIntensity > 0.001) then {
            if (diag_tickTime - _lastLightUpdate >= 0.5) then {
                private _cameraPosASL = getPosASL cameraOn;
                _cameraPosASL set [2, (_cameraPosASL select 2) + 500];
                _lightHandleLocal setPosASL _cameraPosASL;
                _lastLightUpdate = diag_tickTime;
            };

            _lightHandleLocal setLightBrightness (_currentIntensity * 80);
        } else {
            _lightHandleLocal setLightBrightness 0;
        };

        sleep _stepInterval;
    };
};
