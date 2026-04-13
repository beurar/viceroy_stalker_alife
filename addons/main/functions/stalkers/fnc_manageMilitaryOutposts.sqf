#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Manages active military outposts. Cleans up destroyed or distant outposts.
    STALKER_militaryOutposts entries:
        [group, vehicles, centerPos, anchor, marker, faction, lastStrikeTime]
*/

if (!isServer) exitWith {};
if (isNil "STALKER_militaryOutposts") exitWith {};

for "_idx" from (count STALKER_militaryOutposts - 1) to 0 step -1 do {
    private _entry = STALKER_militaryOutposts select _idx;
    if (!(_entry isEqualType [])) then {
        STALKER_militaryOutposts deleteAt _idx;
        continue;
    };

    _entry params ["_grp", "_vehicles", "_centerPos", "_anchor", "_marker", "_faction", "_lastStrikeTime"];

    private _cleanup = false;

    // Cleanup if garrison is wiped
    if (isNull _grp || { (units _grp select { alive _x }) isEqualTo [] }) then {
        _cleanup = true;
    };

    // Cleanup if far from all players
    if (!_cleanup) then {
        private _nearAny = false;
        { if (_x distance2D _centerPos < 3000) exitWith { _nearAny = true } } forEach allPlayers;
        if (!_nearAny) then { _cleanup = true };
    };

    if (_cleanup) then {
        if (!isNull _grp) then {
            { deleteVehicle _x } forEach units _grp;
            deleteGroup _grp;
        };
        { deleteVehicle _x } forEach _vehicles;
        deleteVehicle _anchor;
        if (_marker != "") then { deleteMarker _marker };
        STALKER_militaryOutposts deleteAt _idx;
    };
};

true
