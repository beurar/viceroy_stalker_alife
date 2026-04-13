#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Author: Viceroy
    Description: Debug function to simulate weather.
*/

params ["_mode"];

if (!isServer) exitWith {};

if (_mode == "STORM") then {
    ["Weather debug: Storm phase 1/3 - overcast (30s)"] remoteExec ["systemChat"];

    [] spawn {
        private _phaseDuration = 30;
        private _timeMult = timeMultiplier;
        if (_timeMult <= 0) then { _timeMult = 0.01; };
        private _engineDuration = _phaseDuration * _timeMult;

        [format ["Weather debug: timeMultiplier=%1, engineDuration=%2", _timeMult, _engineDuration]] remoteExec ["systemChat"];

        // Phase 1: regular 30-second overcast transition.
        _engineDuration setOvercast 1;
        sleep _phaseDuration;

        // Phase 2: rain over next 30 seconds
        ["Weather debug: Storm phase 2/3 - rain (30s)"] remoteExec ["systemChat"];
        _engineDuration setRain 1;
        _engineDuration setGusts 1;
        sleep _phaseDuration;

        // Phase 3: fog over final 30 seconds
        ["Weather debug: Storm phase 3/3 - fog (30s)"] remoteExec ["systemChat"];
        _engineDuration setFog 0.35;
        sleep _phaseDuration;

        ["Weather debug: Storm sequence complete"] remoteExec ["systemChat"];
    };
};

if (_mode == "CLEAR") then {
    0 setOvercast 0;
    0 setRain 0;
    0 setFog 0;
    0 setWindStr 0;
    0 setGusts 0;
    forceWeatherChange;
    ["Weather debug: Cleared"] remoteExec ["systemChat"];
};
