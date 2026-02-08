#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Register hooks for blowout events from Diwako's Anomalies.  The
    `blowOutStage` event indicates the current stage of the blowout.
    Stage `1` is the build-up phase, stage `2` marks the start of the
    wave and stage `0` signals the end.  Each handler updates the
    `emission_active` flag and forwards the notification to the
    appropriate subsystem handler.
*/



