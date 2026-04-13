#include "script_component.hpp"
/*
    STALKER ALife  postInit
*/

if (hasInterface && { ["VSA_debugMode", false] call FUNC(getSetting) }) then {
    [] call FUNC(setupDebugActions);
    [] call FUNC(markPlayerRanges);
};

//[] call antistasi_fnc_manageAntistasiEvents;

[] call FUNC(watchBlowoutPP);
[] call FUNC(watchPsySkyTexture);
