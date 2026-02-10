#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Creates a whirligig anomaly field.
    Params:
        0: POSITION or OBJECT - search center
        1: NUMBER - search radius
        2: NUMBER (optional) - anomaly count (-1 = random)
        3: ARRAY (optional) - site position to use (must be valid when provided)
    Returns: ARRAY - spawned anomalies
*/
params ["_center","_radius", ["_count",-1], ["_site", []]];

if (isNil {_site} || {count _site == 0}) then {
    _site = [_center,_radius] call VIC_fnc_findSite_whirligig;
    if (count _site == 0) exitWith {
        []
    };
} else {
};
_site = [_site] call FUNC(findLandPos);
if (isNil {_site} || {count _site == 0}) exitWith {
    []
};

if (_count < 0) then {
    private _max = ["VSA_anomaliesPerField", 40] call FUNC(getSetting);
    _max = _max max 5;
    _count = floor (random (_max - 5 + 1)) + 5;
    private _dens = ["VSA_anomalyDensity_Whirligig",100] call FUNC(getSetting);
    _count = round (_count * (_dens / 100));
};

// Create a marker for this anomaly field
if (isNil "STALKER_anomalyMarkers") then { STALKER_anomalyMarkers = [] };
private _markerName = format ["anom_whirligig_%1", diag_tickTime];
private _size = ["VSA_anomalyFieldRadius", 200] call FUNC(getSetting);
private _marker = [_markerName, _site, "ELLIPSE", "", VIC_colorTeleport, 1, format ["Whirligig %1m", _size]] call FUNC(createGlobalMarker);
_marker setMarkerSizeLocal [_size,_size];
_marker setMarkerBrush "Border";
STALKER_anomalyMarkers pushBack _marker;

private _spawned = [];
for "_i" from 1 to _count do {
    private _off = _site getPos [random _size, random 360];
    private _surf = [_off] call FUNC(getLandSurfacePosition);
    if (_surf isEqualTo []) then { continue };
    private _create = missionNamespace getVariable ["diwako_anomalies_main_fnc_createWhirligig", {}];
    if (_create isEqualTo {}) then {
        continue;
    };
    private _anom = [_surf] call _create;
    _anom setVariable ["zoneMarker", _marker];
    _spawned pushBack _anom;
};
_spawned
