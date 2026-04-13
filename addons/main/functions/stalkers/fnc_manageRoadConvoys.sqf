#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Manages active road convoys. Cleans up destroyed or distant convoys.
    STALKER_convoys entries: [group, vehicle, startPos, anchor, marker, faction]
*/

if (!isServer) exitWith {};
if (isNil "STALKER_convoys") exitWith {};

private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

for "_idx" from (count STALKER_convoys - 1) to 0 step -1 do {
    private _entry = STALKER_convoys select _idx;
    if (!(_entry isEqualType [])) then {
        STALKER_convoys deleteAt _idx;
        continue;
    };

    _entry params ["_grp", "_veh", "_startPos", "_anchor", "_marker", "_faction"];

    private _cleanup = false;

    // Cleanup if group is dead or vehicle destroyed
    if (isNull _grp || { units _grp isEqualTo [] }) then {
        _cleanup = true;
    };
    if (!isNull _veh && { !alive _veh }) then {
        _cleanup = true;
    };

    // Cleanup if far from all players
    if (!_cleanup) then {
        private _vehPos = if (!isNull _veh) then { getPos _veh } else { _startPos };
        private _nearAny = false;
        { if (_x distance2D _vehPos < 3000) exitWith { _nearAny = true } } forEach allPlayers;
        if (!_nearAny) then { _cleanup = true };
    };

    if (_cleanup) then {
        if (!isNull _grp) then {
            { deleteVehicle _x } forEach units _grp;
            deleteGroup _grp;
        };
        if (!isNull _veh) then { deleteVehicle _veh };
        deleteVehicle _anchor;
        if (_marker != "") then { deleteMarker _marker };
        STALKER_convoys deleteAt _idx;
    } else {
        // Update marker position to follow convoy
        if (_marker != "" && { !isNull _veh }) then {
            _marker setMarkerPos (getPos _veh);
        };
    };
};

true
