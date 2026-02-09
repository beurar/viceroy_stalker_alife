#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns mutant habitat markers from cached data.
    Params:
        0: ARRAY - [[type, position, max], ...]
    Returns: BOOL
*/
params [["_data", []]];


if (!isServer) exitWith { false };

if (isNil "STALKER_mutantHabitats") then { STALKER_mutantHabitats = []; };

private _createMarker = {
    params ["_type", "_pos", "_max"];

    if !( [_type] call viceroy_stalker_alife_mutants_fnc_isMutantEnabled ) exitWith { false };
    private _overlap = false;
    {
        if (_pos distance2D (_x#3) < 300) exitWith { _overlap = true };
    } forEach STALKER_mutantHabitats;
    if (!_overlap && {!isNil "STALKER_anomalyFields"}) then {
        {
            if (_pos distance2D (_x#7) < 300) exitWith { _overlap = true };
        } forEach STALKER_anomalyFields;
    };
    if (_overlap) exitWith { false };
    private _base = format ["hab_%1_%2", toLower _type, diag_tickTime + random 1000];
    private _area = _base + "_area";
  [_area, _pos, "ELLIPSE", "", VIC_colorMutant, 1, format ["%1 Habitat Area", _type]] call viceroy_stalker_alife_markers_fnc_createGlobalMarker;
    [_area, [150,150]] remoteExec ["setMarkerSize", 0];
    private _label = _base + "_label";
  [_label, _pos, "ICON", "mil_dot", VIC_colorMutant, 1] call viceroy_stalker_alife_markers_fnc_createGlobalMarker;
    _label setMarkerText format ["%1 Habitat: 0/%2", _type, _max];

    private _anchor = [_pos] call viceroy_stalker_alife_core_fnc_createProximityAnchor;

    STALKER_mutantHabitats pushBack [_area, _label, grpNull, _pos, _anchor, _type, _max, 0, false];
};

{
    _x params ["_type","_pos","_max"];
    [_type, _pos, _max] call _createMarker;
} forEach _data;

true
