#include "script_component.hpp"

#include "XEH_PREP.hpp"

// Block heavy spawning from CBA settings callbacks during startup
VSA_startupIsolationMode = true;

#include "cba_settings.sqf"

// Allow normal spawning now that settings are registered
VSA_startupIsolationMode = false;

/*
    STALKER ALife preInit
    - Register CBA Hooks
*/
