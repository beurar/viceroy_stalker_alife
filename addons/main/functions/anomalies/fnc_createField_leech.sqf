#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Creates a leech anomaly field.
    Params:
        0: POSITION or OBJECT - search center
        1: NUMBER - search radius
        2: NUMBER (optional) - anomaly count (-1 = random)
        3: ARRAY (optional) - site position to use (must be valid when provided)
    Returns: ARRAY - spawned anomalies
*/
params ["_center","_radius", ["_count",-1], ["_site", []]];

if (isNil {_site} || {count _site == 0}) then {
    _site = [_center,_radius] call VIC_fnc_findSite_leech;
    if (count _site == 0) exitWith {
        []
    };
} else {
};
_site = [_site] call viceroy_stalker_alife_core_fnc_findLandPos;
if (count _site == 0) exitWith {
    []
};

if (_count < 0) then {
    private _max = ["VSA_anomaliesPerField", 40] call viceroy_stalker_alife_cba_fnc_getSetting;
    _max = _max max 5;
    _count = floor (random (_max - 5 + 1)) + 5;
    private _dens = ["VSA_anomalyDensity_Leech",100] call viceroy_stalker_alife_cba_fnc_getSetting;
    _count = round (_count * (_dens / 100));
};

// Create a marker for this anomaly field
if (isNil "STALKER_anomalyMarkers") then { STALKER_anomalyMarkers = [] };
private _markerName = format ["anom_leech_%1", diag_tickTime];
private _size = ["VSA_anomalyFieldRadius", 200] call viceroy_stalker_alife_cba_fnc_getSetting;
private _marker = [_markerName, _site, "ELLIPSE", "", VIC_colorLeechGrey, 1, format ["Leech %1m", _size]] call viceroy_stalker_alife_markers_fnc_createGlobalMarker;
_marker setMarkerSizeLocal [_size,_size];
_marker setMarkerBrush "Border";
STALKER_anomalyMarkers pushBack _marker;

private _spawned = [];
for "_i" from 1 to _count do {
    private _off = _site getPos [random _size, random 360];
    private _surf = [_off] call viceroy_stalker_alife_core_fnc_getLandSurfacePosition;
    if (_surf isEqualTo []) then { continue };
    private _anom = createVehicle ["DSA_Leech", ASLToATL _surf, [], 0, "NONE"];
    _anom setVariable ["zoneMarker", _marker];
    _spawned pushBack _anom;
};
_spawned
