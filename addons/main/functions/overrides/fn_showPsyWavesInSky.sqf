#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
// Manually expanded macros to match diwako_anomalies_main
if !(hasInterface) exitWith {};
params [["_show", false]];

if (isNil "diwako_anomalies_main_skyPsyWaves") then {
    diwako_anomalies_main_skyPsyWaves = false;
    diwako_anomalies_main_psySky = objNull;
};

if (_show isEqualTo diwako_anomalies_main_skyPsyWaves) exitWith {};
diwako_anomalies_main_skyPsyWaves = _show;

if (_show) then {
    deleteVehicle diwako_anomalies_main_psySky;
    private _psySky = createSimpleObject ["UserTexture10m_F", [0, 0, 0], true];
    _psySky setVectorDirAndUp [[0,0,1], [0,1,0]];
    _psySky setObjectScale (viewDistance/5);
    _psySky setPosWorld (([] call CBA_fnc_currentUnit) modelToWorldWorld [0, 0, 200]);
    _psySky setObjectMaterial [0, "a3\characters_f_bootcamp\common\data\vrarmoremmisive.rvmat"];
    _psySky setObjectTexture [0, format ["#(rgb,4096,4096,1)ui('RscDisplayEmpty','%1','sky')", "diwako_anomalies_main_psyWavesUI"]];
    diwako_anomalies_main_psySky = _psySky;

    private _fnc = {
        params ["_psySky"];
        systemChat "Viceroy: Overridden fn_showPsyWavesInSky called!";
        if (missionNamespace getVariable ["diwako_anomalies_main_debug", false]) then {
            systemChat "Display found!";
        };
        private _display = findDisplay "diwako_anomalies_main_psyWavesUI";
        _psySky setVariable ["diwako_anomalies_main_display", _display];

        // clean up old control if still exists
        ctrlDelete (_display getVariable ["diwako_anomalies_main_texture", controlNull]);
        private _ctrl = _display ctrlCreate ["RscPicture", -1];
        _display setVariable ["diwako_anomalies_main_texture", _ctrl];
        private _size = 0.5;
        _ctrl ctrlSetPosition [(1-_size) / 2, (1-_size) / 2, _size, _size];
        _ctrl ctrlSetTextColor [1, 1, 1, 1];
        
        // OVERRIDE: Use Viceroy texture
        _ctrl ctrlSetText "\z\viceroy_stalker_alife\addons\main\data\blowout_psy_sky_ca.paa";
        
        _ctrl ctrlSetBackgroundColor [0, 0, 0, 0];
        _ctrl ctrlSetFade 1;
        _ctrl ctrlCommit 0;
        displayUpdate _display;
        _ctrl ctrlSetFade 0;
        _ctrl ctrlCommit 120;
        [{
            if (isGamePaused) exitWith {};
            params ["_psySky", "_display"];
            _psySky setPosWorld (player modelToWorldWorld [0, 0, 200]);
            (_display getVariable ["diwako_anomalies_main_texture", controlNull]) ctrlSetAngle [(cba_missionTime % 7200) / 20, 0.5, 0.5];
            displayUpdate _display;

            isNull _psySky
        }, {}, [_psySky, _display]] call CBA_fnc_waitUntilAndExecute;
    };
    [{
        if (missionNamespace getVariable ["diwako_anomalies_main_debug", false]) then {
            systemChat "Searching display";
        };
        !isNull (findDisplay "diwako_anomalies_main_psyWavesUI")
    }, _fnc, [_psySky]] call CBA_fnc_waitUntilAndExecute;
} else {
    private _display = diwako_anomalies_main_psySky getVariable ["diwako_anomalies_main_display", displayNull];
    private _ctrl = _display getVariable ["diwako_anomalies_main_texture", controlNull];
    private _commit = 5 * 60;
    _ctrl ctrlSetFade 1;
    _ctrl ctrlCommit _commit;
    [{
        ctrlDelete _this;
        deleteVehicle diwako_anomalies_main_psySky;
    }, _ctrl, _commit + 10] call CBA_fnc_waitAndExecute;
};
