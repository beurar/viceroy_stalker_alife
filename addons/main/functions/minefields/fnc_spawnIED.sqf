#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a single IED on a road near the given position.
    Params:
        0: POSITION - position to search
    Returns:
        ARRAY - array containing the spawned IED object
*/
params ["_center"];


if (!isServer) exitWith { [] };

private _pos = [_center, 200, 20] call viceroy_stalker_alife_core_fnc_findRoadPosition;
if (isNil {_pos}) exitWith { [] };

[_pos] call viceroy_stalker_alife_core_fnc_createProximityAnchor;
private _ied = createMine [selectRandom ["IEDUrbanBig_F", "IEDLandBig_F", "IEDUrbanSmall_F", "IEDLandSmall_F"], _pos, [], 0];

if (["VSA_debugMode", false] call viceroy_stalker_alife_cba_fnc_getSetting) then {
    private _marker = format ["ied_%1", diag_tickTime];
    [_marker, _pos, "ICON", "mil_triangle", "#(0.9,0.2,0.2,1)", 0.2, "IED"] call viceroy_stalker_alife_markers_fnc_createGlobalMarker;
};

[_ied];
