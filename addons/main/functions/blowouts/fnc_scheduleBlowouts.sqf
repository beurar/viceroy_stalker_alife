#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Schedule recurring blowouts using Diwako's Anomalies.
    Params: None
*/



if (!isServer) exitWith {
};

if (["VSA_enableBlowouts", true] call FUNC(getSetting) isEqualTo false) exitWith {
};

private _minDelay = ["VSA_blowoutMinDelay",12] call FUNC(getSetting); // hours
private _maxDelay = ["VSA_blowoutMaxDelay",72] call FUNC(getSetting); // hours

if (_maxDelay < _minDelay) then { _maxDelay = _minDelay; };

[_minDelay,_maxDelay] spawn {
    params ["_minH","_maxH"];
    private _next = time + (_minH + random (_maxH - _minH)) * 3600;
    while {true} do {
        if (time >= _next) then {
            [] call FUNC(triggerBlowout);
            _next = time + (_minH + random (_maxH - _minH)) * 3600;
        };
        sleep 60;
    };
};

