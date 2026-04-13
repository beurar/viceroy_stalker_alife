//viceroy_stalke_alife eventhandlers
class Extended_PreStart_EventHandlers {
    class ADDON {
        // Startup lockup isolation mode:
        // PreStart is intentionally disabled to avoid any automatic execution before menu render.
        // Rollback: restore the original XEH_preStart init line.
        // init = QUOTE(call COMPILE_SCRIPT(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_postInit));
    };
};
