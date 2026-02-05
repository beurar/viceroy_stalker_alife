/*
    Starts the minefield management loop. Debug use only.
*/

if (!isServer) exitWith {};

if (missionNamespace getVariable ["VIC_minefieldManagerRunning", false]) exitWith {};
missionNamespace setVariable ["VIC_minefieldManagerRunning", true];

[] spawn {
    while { missionNamespace getVariable ["VIC_minefieldManagerRunning", false] } do {
        [] call VIC_fnc_manageMinefields;
        [] call VIC_fnc_manageBoobyTraps;
        sleep 6;
    };
};

true
