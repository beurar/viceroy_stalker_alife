#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Spawns a stalker vehicle convoy on a road near the given position.
    A random faction is selected and a vehicle with crew + passengers
    is created. The vehicle drives along the road network.

    Params:
        0: POSITION - center position to search for roads from
        1: NUMBER   - search radius for roads (default 500)
    Returns:
        BOOL
*/
params ["_center", ["_radius", 500]];

if (!isServer) exitWith { false };

if (isNil "STALKER_convoys") then { STALKER_convoys = [] };

private _debug = ["VSA_debugMode", false] call FUNC(getSetting);

// Find a road to spawn on
private _roads = _center nearRoads _radius;
if (_roads isEqualTo []) exitWith { false };

// Pick a road segment and find a connected route
private _startRoad = selectRandom _roads;
private _startPos = getPos _startRoad;

// Find destination road far away for route
private _endPos = nil;
for "_i" from 1 to 20 do {
    private _rndPos = _startPos getPos [800 + random 1500, random 360];
    private _nearRoads = _rndPos nearRoads 300;
    if (_nearRoads isNotEqualTo []) exitWith {
        _endPos = getPos (selectRandom _nearRoads);
    };
};
if (isNil "_endPos") exitWith { false };

// Select faction
private _factions = [] call FUNC(getStalkerFactions);
if (_factions isEqualTo []) exitWith { false };
private _faction = selectRandom _factions;
private _chosenSide = selectRandom (_faction select 1);
private _unitClasses = _faction select 2;
private _factionName = _faction select 0;

// Vehicle classes (mix of civilian and military depending on faction)
private _vehicleClasses = switch (_factionName) do {
    case "Military";
    case "Spetznaz": {
        ["d3s_uaz_2315", "d3s_uaz_2315D", "d3s_gaz66_TENT", "d3s_BRDM_2"]
    };
    case "Monolith";
    case "Duty": {
        ["d3s_uaz_2315", "d3s_uaz_3741", "d3s_uaz_2206"]
    };
    default {
        ["C_Offroad_01_F", "C_Van_01_transport_F", "C_SUV_01_F",
         "d3s_luaz969m", "d3s_uaz_2206", "d3s_uaz_2746", "d3s_zaz968m"]
    };
};

private _vehClass = selectRandom _vehicleClasses;
private _veh = createVehicle [_vehClass, _startPos, [], 0, "NONE"];
_veh setDir ([_startPos, _endPos] call BIS_fnc_dirTo);

// Create group and crew
private _grp = createGroup [_chosenSide, true];
private _driver = _grp createUnit [selectRandom _unitClasses, _startPos, [], 0, "CAN_COLLIDE"];
_driver assignAsDriver _veh;
_driver moveInDriver _veh;
[_driver] joinSilent _grp;

// Add 1-3 passengers
private _passengerCount = 1 + floor random 3;
private _cargoSlots = _veh emptyPositions "cargo";
_passengerCount = _passengerCount min _cargoSlots;

for "_i" from 1 to _passengerCount do {
    private _unit = _grp createUnit [selectRandom _unitClasses, _startPos, [], 0, "CAN_COLLIDE"];
    _unit assignAsCargo _veh;
    _unit moveInCargo _veh;
    [_unit] joinSilent _grp;
};

// Set behavior
_grp setBehaviour "AWARE";
_grp setCombatMode "YELLOW";
_grp setSpeedMode "LIMITED";

// Drive to destination
private _wp = _grp addWaypoint [_endPos, 30];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 30;
_wp setWaypointSpeed "LIMITED";

// Cycle waypoint: find another road and keep going
private _wp2 = _grp addWaypoint [_startPos, 50];
_wp2 setWaypointType "CYCLE";

private _anchor = [_startPos] call FUNC(createProximityAnchor);

private _marker = "";
if (_debug) then {
    _marker = format ["convoy_%1", diag_tickTime];
    [_marker, _startPos, "ICON", "mil_arrow", "#(1,0.8,0,1)", 0.6, format ["Convoy-%1", _factionName]] call FUNC(createGlobalMarker);
};

// Entry: [group, vehicle, startPos, anchor, marker, faction]
STALKER_convoys pushBack [_grp, _veh, _startPos, _anchor, _marker, _faction];

if (_debug) then {
    systemChat format ["Road Convoy: %1 faction spawned at %2", _factionName, _startPos];
};

true
