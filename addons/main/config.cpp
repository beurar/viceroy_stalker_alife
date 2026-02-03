#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Functions_F",
            "CBA_Extended_EventHandlers",
            "cba_main"
        };
        author = "Viceroy and PG";
        authorUrl = "https://github.com/beurar/viceroy_stalker_alife";
        VERSION_CONFIG;
    };
};

class CfgMods {
    class PREFIX {
        dir = "@viceroy_stalker_alife";
        name = "Viceroy's STALKER A-Life";
        picture = "logo.paa";
        logo = "Icon.paa";
        logoOver = "Icon.paa";
        logoSmall = "Icon.paa";
        hidePicture = "false";
        hideName = "false";
        actionName = "Website";
        action = "https://github.com/beurar/viceroy_stalker_alife";
        description = "Dynamic A-Life system";
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class CfgRemoteExec {
    class Functions {
        mode = 2;
        jip = 0;
        
        class DFUNC(triggerPsyStorm)     { allowedTargets = 2; };
        class DFUNC(triggerBlowout)      { allowedTargets = 2; };
        class DFUNC(spawnChemicalZone)   { allowedTargets = 2; };
        class DFUNC(spawnRandomChemicalZones) { allowedTargets = 2; };
        class DFUNC(spawnValleyChemicalZones) { allowedTargets = 2; };
        class DFUNC(spawnValleyChemicalFields) { allowedTargets = 2; };
        class DFUNC(spawnAllAnomalyFields)    { allowedTargets = 2; };
        class DFUNC(spawnBridgeAnomalyFields) { allowedTargets = 2; };
        class DFUNC(cycleAnomalyFields)  { allowedTargets = 2; };
        class DFUNC(spawnMutantGroup)    { allowedTargets = 2; };
        class DFUNC(spawnSpookZone)      { allowedTargets = 2; };
        class DFUNC(spawnZombiesFromQueue) { allowedTargets = 2; };
        class DFUNC(triggerNecroplague)  { allowedTargets = 2; };
        class DFUNC(spawnAmbientHerds)   { allowedTargets = 2; };
        class DFUNC(spawnAmbientStalkers) { allowedTargets = 2; };
        class DFUNC(spawnStalkerCamps)   { allowedTargets = 2; };
        class DFUNC(spawnSniper)         { allowedTargets = 2; };
        class DFUNC(startSniperManager)  { allowedTargets = 2; };
        class DFUNC(startCampManager)   { allowedTargets = 2; };
        class DFUNC(spawnPredatorAttack) { allowedTargets = 2; };
        class DFUNC(spawnHabitatHunters) { allowedTargets = 2; };
        class DFUNC(spawnMinefields)     { allowedTargets = 2; };
        class DFUNC(spawnIEDSites)       { allowedTargets = 2; };
        class DFUNC(startIEDManager)     { allowedTargets = 2; };
        class DFUNC(spawnBoobyTraps)     { allowedTargets = 2; };
        class DFUNC(spawnTripwirePerimeter) { allowedTargets = 2; };
        class DFUNC(startMinefieldManager) { allowedTargets = 2; };
        class DFUNC(spawnAmbushes)       { allowedTargets = 2; };
        class DFUNC(startAmbushManager)  { allowedTargets = 2; };
        class DFUNC(startAnomalyManager) { allowedTargets = 2; };
        class DFUNC(setupMutantHabitats) { allowedTargets = 2; };
        class DFUNC(spawnCachedHabitats) { allowedTargets = 2; };
        class DFUNC(manageHabitats)      { allowedTargets = 2; };
        class DFUNC(triggerAIPanic)      { allowedTargets = 2; };
        class DFUNC(resetAIBehavior)     { allowedTargets = 2; };
        class DFUNC(toggleFieldAvoid)    { allowedTargets = 2; };
        class DFUNC(radioMessage)        { allowedTargets = 0; };
    };
};
