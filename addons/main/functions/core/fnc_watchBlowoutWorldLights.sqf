#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts a server-side watcher that flickers powered world lights
    during blowout stages from `diwako_anomalies_main_blowOutStage`.
    Params: none
*/

if (!isServer) exitWith {};
if (missionNamespace getVariable ["VSA_blowoutWorldLightsWatcher", false]) exitWith {};
missionNamespace setVariable ["VSA_blowoutWorldLightsWatcher", true];

missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 0];
missionNamespace setVariable ["VSA_blowoutWorldLightsCurrent", 0];
missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];
missionNamespace setVariable ["VSA_blowoutWorldLightsFallTime", 90];
missionNamespace setVariable ["VSA_blowoutWorldLightsDebugMode", -1];
missionNamespace setVariable ["VSA_blowoutWorldLightsForceRescan", false];

[
    "diwako_anomalies_main_blowOutStage",
    {
        params ["_stage", ["_args", []]];

        switch (_stage) do {
            case 1: {
                missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 0.25];
                missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];
            };
            case 2: {
                missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 0.55];
                missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];
            };
            case 3: {
                missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 0.85];
                missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];
            };
            case 4: {
                missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 1];
                missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", diag_tickTime + 10];
            };
            default {
                missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 0];
                missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];
            };
        };
    }
] call CBA_fnc_addEventHandler;

[] spawn {
    private _stepInterval = 0.1;
    private _globalScanInterval = 60;
    private _lastGlobalScan = -_globalScanInterval;
    private _trackedLights = [];
    private _flickerIndex = 0;
    private _flickerBatchSize = 300;
    private _worldCenter = [worldSize * 0.5, worldSize * 0.5, 0];
    private _worldRadius = worldSize * 0.75;
    private _flickerDamage = missionNamespace getVariable ["VSA_blowoutLightFlickerDamage", 0.95];
    private _lightClasses = missionNamespace getVariable [
        "VSA_blowoutWorldLightClasses",
        ["Lamps_base_F", "PowerLines_base_F"]
    ];
    private _airportLightClasses = missionNamespace getVariable [
        "VSA_blowoutAirportLightClasses",
        [
            "Land_runway_edgelight",
            "Land_runway_edgelight_blue_F",
            "Land_runway_edgelight_red_F",
            "Land_flush_light_green_F",
            "Land_flush_light_red_F",
            "Land_flush_light_yellow_F",
            "Land_Airport_01_controlTower_F",
            "Land_Airport_01_terminal_F"
        ]
    ];

    while {true} do {
        private _target = missionNamespace getVariable ["VSA_blowoutWorldLightsTarget", 0];
        private _current = missionNamespace getVariable ["VSA_blowoutWorldLightsCurrent", 0];
        private _fadeOutAt = missionNamespace getVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];

        if (_fadeOutAt > 0 && {diag_tickTime >= _fadeOutAt}) then {
            _target = 0;
            missionNamespace setVariable ["VSA_blowoutWorldLightsTarget", 0];
            missionNamespace setVariable ["VSA_blowoutWorldLightsFadeOutAt", -1];
        };

        private _delta = _target - _current;
        if (abs _delta > 0.001) then {
            private _riseTime = 25;
            private _fallTime = (missionNamespace getVariable ["VSA_blowoutWorldLightsFallTime", 90]) max 0.1;
            private _timeConstant = [_fallTime, _riseTime] select (_delta > 0);
            private _step = _stepInterval / _timeConstant;
            _current = _current + (_delta * _step);
        } else {
            _current = _target;
        };

        missionNamespace setVariable ["VSA_blowoutWorldLightsCurrent", _current];

        private _forceRescan = missionNamespace getVariable ["VSA_blowoutWorldLightsForceRescan", false];
        if (_forceRescan || {diag_tickTime - _lastGlobalScan >= _globalScanInterval}) then {
            _trackedLights = [];

            private _globalObjects = nearestObjects [_worldCenter, _lightClasses + _airportLightClasses, _worldRadius, true];
            private _terrainLamps = nearestTerrainObjects [_worldCenter, ["LAMP"], _worldRadius];
            private _missionCounter = 0;

            {
                _trackedLights pushBackUnique _x;
                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 20 == 0) then { sleep 0.001; };
            } forEach _globalObjects;

            {
                _trackedLights pushBackUnique _x;
                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 20 == 0) then { sleep 0.001; };
            } forEach _terrainLamps;

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };
                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Lamps_base_F");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "PowerLines_base_F");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Land_runway_edgelight");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Land_runway_edgelight_blue_F");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Land_runway_edgelight_red_F");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Land_flush_light_green_F");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Land_flush_light_red_F");

            {
                if (!isNull _x) then {
                    _trackedLights pushBackUnique _x;
                };

                _missionCounter = _missionCounter + 1;
                if (_missionCounter % 50 == 0) then { sleep 0.001; };
            } forEach (allMissionObjects "Land_flush_light_yellow_F");

            _flickerIndex = 0;
            _lastGlobalScan = diag_tickTime;
            missionNamespace setVariable ["VSA_blowoutWorldLightsForceRescan", false];
        };

        private _flickerChance = _current * 0.5;
        private _debugMode = missionNamespace getVariable ["VSA_blowoutWorldLightsDebugMode", -1];
        private _trackedCount = count _trackedLights;
        if (_trackedCount <= 0) then {
            sleep _stepInterval;
            continue;
        };

        private _batchCount = _flickerBatchSize min _trackedCount;
        for "_i" from 0 to (_batchCount - 1) do {
            if (_flickerIndex >= _trackedCount) then {
                _flickerIndex = 0;
            };

            private _x = _trackedLights select _flickerIndex;
            if (!isNull _x) then {
                private _wasTracked = _x getVariable ["VSA_blowoutLightTracked", false];
                if (!_wasTracked) then {
                    _x setVariable ["VSA_blowoutLightOrigDamage", damage _x];
                    _x setVariable ["VSA_blowoutLightTracked", true];
                };

                if (_debugMode == 0) then {
                    private _origDamage = _x getVariable ["VSA_blowoutLightOrigDamage", 0];
                    _x setDamage _origDamage;
                    _x setVariable ["VSA_blowoutLightIsOff", false];
                } else {
                    if (_debugMode == 1) then {
                        _x setDamage _flickerDamage;
                        _x setVariable ["VSA_blowoutLightIsOff", true];
                    } else {
                        if (_current <= 0.01) then {
                            private _origDamage = _x getVariable ["VSA_blowoutLightOrigDamage", 0];
                            _x setDamage _origDamage;
                            _x setVariable ["VSA_blowoutLightIsOff", false];
                        } else {
                            private _isOff = _x getVariable ["VSA_blowoutLightIsOff", false];
                            if (_isOff) then {
                                private _until = _x getVariable ["VSA_blowoutLightRecoverAt", 0];
                                if (diag_tickTime >= _until) then {
                                    private _origDamage = _x getVariable ["VSA_blowoutLightOrigDamage", 0];
                                    _x setDamage _origDamage;
                                    _x setVariable ["VSA_blowoutLightIsOff", false];
                                };
                            } else {
                                if (random 1 < _flickerChance) then {
                                    _x setDamage _flickerDamage;
                                    _x setVariable ["VSA_blowoutLightIsOff", true];
                                    _x setVariable [
                                        "VSA_blowoutLightRecoverAt",
                                        diag_tickTime + (0.02 + random (0.06 + (_current * 0.3)))
                                    ];
                                };
                            };
                        };
                    };
                };
            };

            _flickerIndex = _flickerIndex + 1;
            if ((_i + 1) % 20 == 0) then { sleep 0.001; };
        };

        sleep _stepInterval;
    };
};
