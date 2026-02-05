/*
    File: fn_toggleFieldAvoid.sqf
    Author: Viceroy's STALKER ALife
    Description:
        Toggles AI avoidance of anomaly fields for testing.
*/



if (!isServer) exitWith {
};

missionNamespace setVariable ["VSA_fieldAvoidEnabled", !(missionNamespace getVariable ["VSA_fieldAvoidEnabled", true]), true];
private _state = missionNamespace getVariable ["VSA_fieldAvoidEnabled", true];


true
