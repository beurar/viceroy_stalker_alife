#include "\x\cba\addons\main\script_macros_common.hpp"

#ifdef DISABLE_COMPILE_CACHE
  #undef PREP
  #define PREP(fncName) DFUNC(fncName) = compileScript [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)]
#else
  #undef PREP
  #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef SUBPREP
    #undef SUBPREP
#endif

#ifdef DISABLE_COMPILE_CACHE
    #define SUBPREP(sub,fncName) DFUNC(fncName) = compileScript [QPATHTOF(functions\sub\DOUBLES(fn,fncName).sqf)]
#else
    #define SUBPREP(sub,fncName) [QPATHTOF(functions\sub\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
    name = #ITEM; \
    count = COUNT; \
}

#define CHECK_FOLDER_1 ai
#define CHECK_FOLDER_2 ambushes
#define CHECK_FOLDER_3 anomalies
#define CHECK_FOLDER_4 antistasi
#define CHECK_FOLDER_5 blowouts
#define CHECK_FOLDER_6 chemical
#define CHECK_FOLDER_7 core
#define CHECK_FOLDER_8 minefields
#define CHECK_FOLDER_9 mutants
#define CHECK_FOLDER_10 necroplague
#define CHECK_FOLDER_11 overrides
#define CHECK_FOLDER_12 panic
#define CHECK_FOLDER_13 smart_terrains
#define CHECK_FOLDER_14 spooks
#define CHECK_FOLDER_15 stalkers
#define CHECK_FOLDER_16 storms
#define CHECK_FOLDER_17 wrecks
#define CHECK_FOLDER_18 zombification

#define SYSTEM_CHECK RUN_CHECK(CHECK_FOLDER_1) && RUN_CHECK(CHECK_FOLDER_2) && RUN_CHECK(CHECK_FOLDER_3) && RUN_CHECK(CHECK_FOLDER_4) && RUN_CHECK(CHECK_FOLDER_5) && RUN_CHECK(CHECK_FOLDER_6) && RUN_CHECK(CHECK_FOLDER_7) && RUN_CHECK(CHECK_FOLDER_8) && RUN_CHECK(CHECK_FOLDER_9) && RUN_CHECK(CHECK_FOLDER_10) && RUN_CHECK(CHECK_FOLDER_11) && RUN_CHECK(CHECK_FOLDER_12) && RUN_CHECK(CHECK_FOLDER_13) && RUN_CHECK(CHECK_FOLDER_14) && RUN_CHECK(CHECK_FOLDER_15) && RUN_CHECK(CHECK_FOLDER_16) && RUN_CHECK(CHECK_FOLDER_17) && RUN_CHECK(CHECK_FOLDER_18)
#define RUN_CHECK(var1) !(call compileScript [QPATHTOF(BUILD_CHECK_FILE(var1,0,0))])
