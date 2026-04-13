#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Starts a client-side watcher that replaces the psy sky texture
    when the Diwako psy waves display appears.
    Params: none
*/

if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["VSA_psySkyTextureWatcher", false]) exitWith {};
missionNamespace setVariable ["VSA_psySkyTextureWatcher", true];

// Default texture if none selected
if (isNil "VSA_currentPsySkyTexture") then {
    VSA_currentPsySkyTexture = "\z\viceroy_stalker_alife\addons\main\data\blowoutsky_3.paa";
};

[] spawn {
    while {true} do {
        waitUntil {
            sleep 0.2;
            !isNull (findDisplay "diwako_anomalies_main_psyWavesUI")
        };

        private _display = findDisplay "diwako_anomalies_main_psyWavesUI";
        private _ctrl = controlNull;

        waitUntil {
            sleep 0.1;
            _ctrl = _display getVariable ["diwako_anomalies_main_texture", controlNull];
            (!isNull _ctrl) || isNull _display
        };

        if (!isNull _ctrl) then {
            // Apply current selected texture immediately
            _ctrl ctrlSetText VSA_currentPsySkyTexture;
            
            // Watch for changes while display is active so we can hot-swap
            private _lastTexture = VSA_currentPsySkyTexture;
            private _stepInterval = 0.1;
            
            while {!isNull (findDisplay "diwako_anomalies_main_psyWavesUI")} do {
                if (VSA_currentPsySkyTexture != _lastTexture) then {
                    _ctrl ctrlSetText VSA_currentPsySkyTexture;
                    _lastTexture = VSA_currentPsySkyTexture;
                };

                sleep _stepInterval;
            };
        };

        // Wait until display is gone before looping back to wait for it again
        waitUntil {
            sleep 0.2;
            isNull (findDisplay "diwako_anomalies_main_psyWavesUI")
        };
    };
};
