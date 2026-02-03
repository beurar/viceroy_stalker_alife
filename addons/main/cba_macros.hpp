#ifndef CBA_MACROS_H
#define CBA_MACROS_H

// Core CBA Macros (Vendor-ed for HEMTT build compliance)

#define DOUBLES(var1,var2) var1##_##var2
#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3
#define QUOTE(var1) #var1

// Addon Structure
#ifndef SUBPREFIX
    #define SUBPREFIX addons
#endif

#define ADDON DOUBLES(PREFIX,COMPONENT)

// Path Macros
#define PATHTOF_SYS(var1,var2,var3) \MAINPREFIX\var1\SUBPREFIX\var2\var3
#define PATHTOF(var1) PATHTOF_SYS(PREFIX,COMPONENT,var1)
#define QPATHTOF(var1) QUOTE(PATHTOF(var1))

// Function Macros
#define QFUNC(var1) QUOTE(DFUNC(var1))

// Global Variables
#define GVAR(var1) DOUBLES(ADDON,var1)
#define QGVAR(var1) QUOTE(GVAR(var1))

#define EGVAR(var1,var2) TRIPLES(PREFIX,var1,var2)
#define QEGVAR(var1,var2) QUOTE(EGVAR(var1,var2))

// Logging
#define LOG_SYS_FORMAT(LEVEL,MESSAGE) format ['[%1] (%2) %3: %4', toUpper 'PREFIX', 'COMPONENT', LEVEL, MESSAGE]
#define LOG(MESSAGE) diag_log LOG_SYS_FORMAT("LOG",MESSAGE)
#define ERROR(MESSAGE) diag_log LOG_SYS_FORMAT("ERROR",MESSAGE)
#define ERROR_WITH_TITLE(TITLE,MESSAGE) diag_log LOG_SYS_FORMAT("ERROR",format ["%1: %2", TITLE, MESSAGE])

// Versioning
#ifndef VERSION_CONFIG
  #define VERSION_CONFIG version = VERSION; versionStr = QUOTE(VERSION_STR); versionAr[] = {VERSION_AR}
#endif

#endif
