#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Manages active helicopter patrols. Cleans up destroyed or distant patrols.
    Updates marker positions to follow the helicopter.
    STALKER_heliPatrols entries: [group, helicopter, centerPos, anchor, marker, faction]
*/

if (!isServer) exitWith {};
if (isNil "STALKER_heliPatrols") exitWith {};

for "_idx" from (count STALKER_heliPatrols - 1) to 0 step -1 do {
    private _entry = STALKER_heliPatrols select _idx;
    if (!(_entry isEqualType [])) then {
        STALKER_heliPatrols deleteAt _idx;
        continue;
    };

    _entry params ["_grp", "_heli", "_centerPos", "_anchor", "_marker", "_faction"];

    private _cleanup = false;

    // Cleanup if group is dead or heli destroyed
    if (isNull _grp || { units _grp isEqualTo [] }) then {
        _cleanup = true;
    };
    if (!isNull _heli && { !alive _heli }) then {
        _cleanup = true;
    };

    // Cleanup if far from all players
    if (!_cleanup) then {
        private _heliPos = if (!isNull _heli && { alive _heli }) then { getPos _heli } else { _centerPos };
        private _nearAny = false;
        { if (_x distance2D _heliPos < 4000) exitWith { _nearAny = true } } forEach allPlayers;
        if (!_nearAny) then { _cleanup = true };
    };

    if (_cleanup) then {
        if (!isNull _grp) then {
            { deleteVehicle _x } forEach units _grp;
            deleteGroup _grp;
        };
        if (!isNull _heli) then { deleteVehicle _heli };
        deleteVehicle _anchor;
        if (_marker != "") then { deleteMarker _marker };
        STALKER_heliPatrols deleteAt _idx;
    } else {
        // Update marker to follow helicopter
        if (_marker != "" && { !isNull _heli && { alive _heli } }) then {
            _marker setMarkerPos (getPos _heli);
        };
    };
};

true
