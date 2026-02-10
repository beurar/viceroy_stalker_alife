#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Marks a hidden position near players on the map when debugging is enabled.

    Returns: BOOL
*/


params [["_global", false]];



if (isNil "STALKER_hiddenMarkers") then { STALKER_hiddenMarkers = [] };

// remove existing markers
{
    if (_x != "") then { deleteMarker _x };
} forEach STALKER_hiddenMarkers;
STALKER_hiddenMarkers = [];

private _pos = [] call FUNC(findHiddenPosition);
if (isNil {_pos}) exitWith { false };

private _name = format ["hidden_%1", diag_tickTime + random 1000];
private _marker = [_name, _pos, "ICON", "mil_ambush", "#(0,1,0,1)", 1, "", [1,1], _global] call FUNC(createGlobalMarker);
STALKER_hiddenMarkers pushBack _marker;

true
