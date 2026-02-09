#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Marks detected valley positions on the map when debugging is enabled.

    Returns: BOOL
*/


params [["_global", false]];



if (isNil "STALKER_valleyMarkers") then { STALKER_valleyMarkers = [] };

// Remove any existing markers
{
    if (_x != "") then { deleteMarker _x };
} forEach STALKER_valleyMarkers;
STALKER_valleyMarkers = [];

if (isNil "STALKER_valleys") then {
    private _cached = ["STALKER_valleys"] call viceroy_stalker_alife_cache_fnc_loadCache;
    if (isNil {_cached}) exitWith { false };
    STALKER_valleys = _cached;
};

if (isNil "STALKER_valleys") exitWith { false };
private _valleys = STALKER_valleys;

{
    private _area = _x;
    {
        private _pos = _x;
        private _name = format ["valley_%1", diag_tickTime + random 1000];
        private _marker = [_name, _pos, "ICON", "mil_arrow", "#(0,0,1,1)", 1, "", [1,1], _global] call viceroy_stalker_alife_markers_fnc_createGlobalMarker;
        STALKER_valleyMarkers pushBack _marker;
    } forEach _area;
} forEach _valleys;

true
