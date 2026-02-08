// Core
[
    "VSA_autoInit",
    "CHECKBOX",
    [localize "STR_VSA_autoInit", localize "STR_VSA_autoInit_Tooltip"],
    [localize "STR_VSA_Category_Core"],
    true,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    "VSA_playerNearbyRange",
    "SLIDER",
    [localize "STR_VSA_playerNearbyRange", localize "STR_VSA_playerNearbyRange_Tooltip"],
    [localize "STR_VSA_Category_Core"],
    [100, 2000, 800, 0],
    true,
    {
        params ["_value"];
        VSA_playerNearbyRange = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_townRadius",
    "SLIDER",
    [localize "STR_VSA_townRadius", localize "STR_VSA_townRadius_Tooltip"],
    [localize "STR_VSA_Category_Core"],
    [50, 1000, 200, 0],
    true,
    {
        params ["_value"];
        VSA_townRadius = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_townHysteresis",
    "SLIDER",
    [localize "STR_VSA_townHysteresis", localize "STR_VSA_townHysteresis_Tooltip"],
    [localize "STR_VSA_Category_Core"],
    [0, 500, 50, 0],
    true,
    {
        params ["_value"];
        VSA_townHysteresis = _value;
    }
] call CBA_fnc_addSetting;


// Anomalies
[
    "VSA_enableAnomalies",
    "CHECKBOX",
    [localize "STR_VSA_enableAnomalies", localize "STR_VSA_enableAnomalies_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableAnomalies = _value;
        if (isServer && {VSA_enableAnomalies}) then {
            [] spawn VSA_fnc_spawnAllAnomalyFields;
        };
        if (isServer && {!VSA_enableAnomalies}) then {
            // Logic to cleanup anomalies if disabled?
            // Currently spawnAllAnomalyFields handles initial spawn, but maybe we need a cleanup function if toggled off mid-game
            // For now, just setting the var is enough for future spawns/checks.
        };
    }
] call CBA_fnc_addSetting;

[
    "VSA_anomalyFieldCount",
    "SLIDER",
    [localize "STR_VSA_anomalyFieldCount", localize "STR_VSA_anomalyFieldCount_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [0, 100, 25, 0], // Min, Max, Default, Decimals
    true,
    {
        params ["_value"];
        VSA_anomalyFieldCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_maxAnomalyFields",
    "SLIDER",
    [localize "STR_VSA_maxAnomalyFields", localize "STR_VSA_maxAnomalyFields_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [0, 500, 100, 0],
    true,
    {
        params ["_value"];
        VSA_maxAnomalyFields = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_anomalySpawnWeight",
    "SLIDER",
    [localize "STR_VSA_anomalySpawnWeight", localize "STR_VSA_anomalySpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [0, 1, 0.6, 2],
    true,
    {
        params ["_value"];
        VSA_anomalySpawnWeight = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_anomalyWeight_Burner",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Burner", localize "STR_VSA_anomalyWeight_Burner_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Clicker",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Clicker", localize "STR_VSA_anomalyWeight_Clicker_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Electra",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Electra", localize "STR_VSA_anomalyWeight_Electra_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Fruitpunch",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Fruitpunch", localize "STR_VSA_anomalyWeight_Fruitpunch_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Gravi",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Gravi", localize "STR_VSA_anomalyWeight_Gravi_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Meatgrinder",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Meatgrinder", localize "STR_VSA_anomalyWeight_Meatgrinder_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Springboard",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Springboard", localize "STR_VSA_anomalyWeight_Springboard_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Whirligig",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Whirligig", localize "STR_VSA_anomalyWeight_Whirligig_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Launchpad",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Launchpad", localize "STR_VSA_anomalyWeight_Launchpad_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Leech",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Leech", localize "STR_VSA_anomalyWeight_Leech_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Trapdoor",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Trapdoor", localize "STR_VSA_anomalyWeight_Trapdoor_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Zapper",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Zapper", localize "STR_VSA_anomalyWeight_Zapper_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyWeight_Bridge",
    "SLIDER",
    [localize "STR_VSA_anomalyWeight_Bridge", localize "STR_VSA_anomalyWeight_Bridge_Tooltip"],
    [localize "STR_VSA_Category_AnomalyWeights"],
    [0, 100, 10, 0],
    true
] call CBA_fnc_addSetting;

// Anomaly Density
[
    "VSA_anomalyDensity_Burner",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Burner", localize "STR_VSA_anomalyDensity_Burner_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Clicker",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Clicker", localize "STR_VSA_anomalyDensity_Clicker_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Electra",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Electra", localize "STR_VSA_anomalyDensity_Electra_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Fruitpunch",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Fruitpunch", localize "STR_VSA_anomalyDensity_Fruitpunch_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Gravi",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Gravi", localize "STR_VSA_anomalyDensity_Gravi_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Meatgrinder",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Meatgrinder", localize "STR_VSA_anomalyDensity_Meatgrinder_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Springboard",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Springboard", localize "STR_VSA_anomalyDensity_Springboard_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Whirligig",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Whirligig", localize "STR_VSA_anomalyDensity_Whirligig_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Launchpad",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Launchpad", localize "STR_VSA_anomalyDensity_Launchpad_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Leech",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Leech", localize "STR_VSA_anomalyDensity_Leech_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Trapdoor",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Trapdoor", localize "STR_VSA_anomalyDensity_Trapdoor_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Zapper",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Zapper", localize "STR_VSA_anomalyDensity_Zapper_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_anomalyDensity_Bridge",
    "SLIDER",
    [localize "STR_VSA_anomalyDensity_Bridge", localize "STR_VSA_anomalyDensity_Bridge_Tooltip"],
    [localize "STR_VSA_Category_AnomalyDensity"],
    [1, 10, 1, 0],
    true
] call CBA_fnc_addSetting;

[
    "VSA_stableFieldChance",
    "SLIDER",
    [localize "STR_VSA_stableFieldChance", localize "STR_VSA_stableFieldChance_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [0, 1, 0.4, 2],
    true,
    {
        params ["_value"];
        VSA_stableFieldChance = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_anomalyFieldRadius",
    "SLIDER",
    [localize "STR_VSA_anomalyFieldRadius", localize "STR_VSA_anomalyFieldRadius_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [5, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_anomalyFieldRadius = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_bridgeFieldRadius",
    "SLIDER",
    [localize "STR_VSA_bridgeFieldRadius", localize "STR_VSA_bridgeFieldRadius_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [5, 500, 50, 0],
    true,
    {
        params ["_value"];
        VSA_bridgeFieldRadius = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_anomaliesPerField",
    "SLIDER",
    [localize "STR_VSA_anomaliesPerField", localize "STR_VSA_anomaliesPerField_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [1, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_anomaliesPerField = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_anomalyNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_anomalyNightOnly", localize "STR_VSA_anomalyNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    false,
    true,
    {
        params ["_value"];
        VSA_anomalyNightOnly = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_anomalyEmissionMode",
    "LIST",
    [localize "STR_VSA_anomalyEmissionMode", localize "STR_VSA_anomalyEmissionMode_Tooltip"],
    [localize "STR_VSA_Category_Anomalies"],
    [[0, 1, 2], [localize "STR_VSA_Option_None", localize "STR_VSA_Option_Move", localize "STR_VSA_Option_Respawn"], 1],
    true,
    {
        params ["_value"];
        VSA_anomalyEmissionMode = _value;
    }
] call CBA_fnc_addSetting;

// Chemical
[
    "VSA_enableChemicalZones",
    "CHECKBOX",
    [localize "STR_VSA_enableChemicalZones", localize "STR_VSA_enableChemicalZones_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableChemicalZones = _value;
        if (isServer && {VSA_enableChemicalZones}) then {
            [] spawn VSA_fnc_spawnRandomChemicalZones;
        };
    }
] call CBA_fnc_addSetting;

[
    "VSA_chemicalZoneCount",
    "SLIDER",
    [localize "STR_VSA_chemicalZoneCount", localize "STR_VSA_chemicalZoneCount_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [0, 50, 15, 0],
    true,
    {
        params ["_value"];
        VSA_chemicalZoneCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_IEDSiteCount",
    "SLIDER",
    [localize "STR_VSA_IEDSiteCount", localize "STR_VSA_IEDSiteCount_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [0, 50, 25, 0],
    true,
    {
        params ["_value"];
        VSA_IEDSiteCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_chemicalSpawnWeight",
    "SLIDER",
    [localize "STR_VSA_chemicalSpawnWeight", localize "STR_VSA_chemicalSpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [0, 1, 0.4, 2],
    true,
    {
        params ["_value"];
        VSA_chemicalSpawnWeight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_chemicalNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_chemicalNightOnly", localize "STR_VSA_chemicalNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    false,
    true,
    {
        params ["_value"];
        VSA_chemicalNightOnly = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_chemicalZoneRadius",
    "SLIDER",
    [localize "STR_VSA_chemicalZoneRadius", localize "STR_VSA_chemicalZoneRadius_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [10, 200, 50, 0],
    true,
    {
        params ["_value"];
        VSA_chemicalZoneRadius = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_chemicalGasType",
    "LIST",
    [localize "STR_VSA_chemicalGasType", localize "STR_VSA_chemicalGasType_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [[0, 1, 2], [localize "STR_VSA_Option_None", localize "STR_VSA_Option_TearGas", localize "STR_VSA_Option_Sarid"], 1],
    true,
    {
        params ["_value"];
        VSA_chemicalGasType = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_emissionChemicalCount",
    "SLIDER",
    [localize "STR_VSA_emissionChemicalCount", localize "STR_VSA_emissionChemicalCount_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [0, 10, 3, 0],
    true,
    {
        params ["_value"];
        VSA_emissionChemicalCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_emissionChemicalRadius",
    "SLIDER",
    [localize "STR_VSA_emissionChemicalRadius", localize "STR_VSA_emissionChemicalRadius_Tooltip"],
    [localize "STR_VSA_Category_Chemical"],
    [50, 1000, 300, 0],
    true,
    {
        params ["_value"];
        VSA_emissionChemicalRadius = _value;
    }
] call CBA_fnc_addSetting;

// Mutants
[
    "VSA_enableMutants",
    "CHECKBOX",
    [localize "STR_VSA_enableMutants", localize "STR_VSA_enableMutants_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "VSA_mutantGroupCount",
    "SLIDER",
    [localize "STR_VSA_mutantGroupCount", localize "STR_VSA_mutantGroupCount_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_mutantGroupCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_mutantSpawnWeight",
    "SLIDER",
    [localize "STR_VSA_mutantSpawnWeight", localize "STR_VSA_mutantSpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 1, 0.5, 2],
    true,
    {
        params ["_value"];
        VSA_mutantSpawnWeight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_mutantsNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_mutantsNightOnly", localize "STR_VSA_mutantsNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    false,
    true,
    {
        params ["_value"];
        VSA_mutantsNightOnly = _value;
    }
] call CBA_fnc_addSetting;

// Mutant toggles
[
    "VSA_enableBloodsucker",
    "CHECKBOX",
    [localize "STR_VSA_enableBloodsucker", localize "STR_VSA_enableBloodsucker_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableBoar",
    "CHECKBOX",
    [localize "STR_VSA_enableBoar", localize "STR_VSA_enableBoar_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableCat",
    "CHECKBOX",
    [localize "STR_VSA_enableCat", localize "STR_VSA_enableCat_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableFlesh",
    "CHECKBOX",
    [localize "STR_VSA_enableFlesh", localize "STR_VSA_enableFlesh_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableBlindDog",
    "CHECKBOX",
    [localize "STR_VSA_enableBlindDog", localize "STR_VSA_enableBlindDog_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enablePseudodog",
    "CHECKBOX",
    [localize "STR_VSA_enablePseudodog", localize "STR_VSA_enablePseudodog_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableSnork",
    "CHECKBOX",
    [localize "STR_VSA_enableSnork", localize "STR_VSA_enableSnork_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableController",
    "CHECKBOX",
    [localize "STR_VSA_enableController", localize "STR_VSA_enableController_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enablePseudogiant",
    "CHECKBOX",
    [localize "STR_VSA_enablePseudogiant", localize "STR_VSA_enablePseudogiant_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting; 

 [
    "VSA_enableIzlom",
    "CHECKBOX",
    [localize "STR_VSA_enableIzlom", localize "STR_VSA_enableIzlom_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableCorruptor",
    "CHECKBOX",
    [localize "STR_VSA_enableCorruptor", localize "STR_VSA_enableCorruptor_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableSmasher",
    "CHECKBOX",
    [localize "STR_VSA_enableSmasher", localize "STR_VSA_enableSmasher_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableAcidSmasher",
    "CHECKBOX",
    [localize "STR_VSA_enableAcidSmasher", localize "STR_VSA_enableAcidSmasher_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableBehemoth",
    "CHECKBOX",
    [localize "STR_VSA_enableBehemoth", localize "STR_VSA_enableBehemoth_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableParasite",
    "CHECKBOX",
    [localize "STR_VSA_enableParasite", localize "STR_VSA_enableParasite_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableJumper",
    "CHECKBOX",
    [localize "STR_VSA_enableJumper", localize "STR_VSA_enableJumper_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableSpitter",
    "CHECKBOX",
    [localize "STR_VSA_enableSpitter", localize "STR_VSA_enableSpitter_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableStalker",
    "CHECKBOX",
    [localize "STR_VSA_enableStalker", localize "STR_VSA_enableStalker_Tooltip"],
     [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableBully",
    "CHECKBOX",
    [localize "STR_VSA_enableBully", localize "STR_VSA_enableBully_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

 [
    "VSA_enableHivemind",
    "CHECKBOX",
    [localize "STR_VSA_enableHivemind", localize "STR_VSA_enableHivemind_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "VSA_enableZombie",
    "CHECKBOX",
    [localize "STR_VSA_enableZombie", localize "STR_VSA_enableZombie_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "VSA_enableChimera",
    "CHECKBOX",
    [localize "STR_VSA_enableChimera", localize "STR_VSA_enableChimera_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    true,
    true
] call CBA_fnc_addSetting;


// Wandering Stalkers
[
    "VSA_enableAmbientStalkers",
    "CHECKBOX",
    [localize "STR_VSA_enableAmbientStalkers", localize "STR_VSA_enableAmbientStalkers_Tooltip"],
    [localize "STR_VSA_Category_WanderingStalkers"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableAmbientStalkers = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambientStalkerGroups",
    "SLIDER",
    [localize "STR_VSA_ambientStalkerGroups", localize "STR_VSA_ambientStalkerGroups_Tooltip"],
    [localize "STR_VSA_Category_WanderingStalkers"],
    [0, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_ambientStalkerGroups = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambientStalkerSize",
    "SLIDER",
    [localize "STR_VSA_ambientStalkerSize", localize "STR_VSA_ambientStalkerSize_Tooltip"],
    [localize "STR_VSA_Category_WanderingStalkers"],
    [1, 10, 3, 0],
    true,
    {
        params ["_value"];
        VSA_ambientStalkerSize = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambientStalkerNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_ambientStalkerNightOnly", localize "STR_VSA_ambientStalkerNightOnly_Tooltip"],
    [localize "STR_VSA_Category_WanderingStalkers"],
    false,
    true,
    {
        params ["_value"];
        VSA_ambientStalkerNightOnly = _value;
    }
] call CBA_fnc_addSetting;

// Stalker Camps
[
    "VSA_enableStalkerCamps",
    "CHECKBOX",
    [localize "STR_VSA_enableStalkerCamps", localize "STR_VSA_enableStalkerCamps_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableStalkerCamps = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stalkerCampCount",
    "SLIDER",
    [localize "STR_VSA_stalkerCampCount", localize "STR_VSA_stalkerCampCount_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [0, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_stalkerCampCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stalkerCampSize",
    "SLIDER",
    [localize "STR_VSA_stalkerCampSize", localize "STR_VSA_stalkerCampSize_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [1, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_stalkerCampSize = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_minCampPositions",
    "SLIDER",
    [localize "STR_VSA_minCampPositions", localize "STR_VSA_minCampPositions_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [1, 20, 4, 0],
    true,
    {
        params ["_value"];
        VSA_minCampPositions = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stalkerCampSpacing",
    "SLIDER",
    [localize "STR_VSA_stalkerCampSpacing", localize "STR_VSA_stalkerCampSpacing_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [50, 2000, 300, 0],
    true,
    {
        params ["_value"];
        VSA_stalkerCampSpacing = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stalkerCampBLUChance",
    "SLIDER",
    [localize "STR_VSA_stalkerCampBLUChance", localize "STR_VSA_stalkerCampBLUChance_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [0, 1, 0.33, 2],
    true,
    {
        params ["_value"];
        VSA_stalkerCampBLUChance = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stalkerCampOPFChance",
    "SLIDER",
    [localize "STR_VSA_stalkerCampOPFChance", localize "STR_VSA_stalkerCampOPFChance_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [0, 1, 0.33, 2],
    true,
    {
        params ["_value"];
        VSA_stalkerCampOPFChance = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stalkerCampINDChance",
    "SLIDER",
    [localize "STR_VSA_stalkerCampINDChance", localize "STR_VSA_stalkerCampINDChance_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [0, 1, 0.34, 2],
    true,
    {
        params ["_value"];
        VSA_stalkerCampINDChance = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_minStalkerCamps",
    "SLIDER",
    [localize "STR_VSA_minStalkerCamps", localize "STR_VSA_minStalkerCamps_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [0, 20, 2, 0],
    true,
    {
        params ["_value"];
        VSA_minStalkerCamps = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_maxStalkerCamps",
    "SLIDER",
    [localize "STR_VSA_maxStalkerCamps", localize "STR_VSA_maxStalkerCamps_Tooltip"],
    [localize "STR_VSA_Category_StalkerCamps"],
    [0, 20, 10, 0],
    true,
    {
        params ["_value"];
        VSA_maxStalkerCamps = _value;
    }
] call CBA_fnc_addSetting;

// Spooks
[
    "VSA_enableSpooks",
    "CHECKBOX",
    [localize "STR_VSA_enableSpooks", localize "STR_VSA_enableSpooks_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableSpooks = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_spookZoneCount",
    "SLIDER",
    [localize "STR_VSA_spookZoneCount", localize "STR_VSA_spookZoneCount_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    [0, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_spookZoneCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_spookSpawnWeight",
    "SLIDER",
    [localize "STR_VSA_spookSpawnWeight", localize "STR_VSA_spookSpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    [0, 1, 0.3, 2],
    true,
    {
        params ["_value"];
        VSA_spookSpawnWeight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_spooksNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_spooksNightOnly", localize "STR_VSA_spooksNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    true,
    true,
    {
        params ["_value"];
        VSA_spooksNightOnly = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_abominationCount",
    "SLIDER",
    [localize "STR_VSA_abominationCount", localize "STR_VSA_abominationCount_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    [1, 10, 3, 0],
    true,
    {
        params ["_value"];
        VSA_abominationCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_abominationSpawnWeight",
    "SLIDER",
    [localize "STR_VSA_abominationSpawnWeight", localize "STR_VSA_abominationSpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    [0, 1, 0.1, 2],
    true,
    {
        params ["_value"];
        VSA_abominationSpawnWeight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_abominationTime",
    "SLIDER",
    [localize "STR_VSA_abominationTime", localize "STR_VSA_abominationTime_Tooltip"],
    [localize "STR_VSA_Category_Spooks"],
    [0, 24, 0, 0], // Start hour
    true,
    {
        params ["_value"];
        VSA_abominationTime = _value;
    }
] call CBA_fnc_addSetting;


// Storms
[
    "VSA_enableStorms",
    "CHECKBOX",
    [localize "STR_VSA_enableStorms", localize "STR_VSA_enableStorms_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableStorms = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormInterval",
    "SLIDER",
    [localize "STR_VSA_stormInterval", localize "STR_VSA_stormInterval_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [10, 240, 60, 0],
    true,
    {
        params ["_value"];
        VSA_stormInterval = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormSpawnWeight",
    "SLIDER",
    [localize "STR_VSA_stormSpawnWeight", localize "STR_VSA_stormSpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 1, 0.5, 2],
    true,
    {
        params ["_value"];
        VSA_stormSpawnWeight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormsNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_stormsNightOnly", localize "STR_VSA_stormsNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    false,
    true,
    {
        params ["_value"];
        VSA_stormsNightOnly = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormMinDelay",
    "SLIDER",
    [localize "STR_VSA_stormMinDelay", localize "STR_VSA_stormMinDelay_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [60, 3600, 600, 0],
    true,
    {
        params ["_value"];
        VSA_stormMinDelay = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormMaxDelay",
    "SLIDER",
    [localize "STR_VSA_stormMaxDelay", localize "STR_VSA_stormMaxDelay_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [60, 7200, 3600, 0],
    true,
    {
        params ["_value"];
        VSA_stormMaxDelay = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_stormDuration",
    "SLIDER",
    [localize "STR_VSA_stormDuration", localize "STR_VSA_stormDuration_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [60, 600, 300, 0],
    true,
    {
        params ["_value"];
        VSA_stormDuration = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormLightningStart",
    "SLIDER",
    [localize "STR_VSA_stormLightningStart", localize "STR_VSA_stormLightningStart_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 10, 0.2, 2],
    true,
    {
        params ["_value"];
        VSA_stormLightningStart = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormLightningEnd",
    "SLIDER",
    [localize "STR_VSA_stormLightningEnd", localize "STR_VSA_stormLightningEnd_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 10, 1, 2],
    true,
    {
        params ["_value"];
        VSA_stormLightningEnd = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormDischargeStart",
    "SLIDER",
    [localize "STR_VSA_stormDischargeStart", localize "STR_VSA_stormDischargeStart_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 10, 0, 2],
    true,
    {
        params ["_value"];
        VSA_stormDischargeStart = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormDischargeEnd",
    "SLIDER",
    [localize "STR_VSA_stormDischargeEnd", localize "STR_VSA_stormDischargeEnd_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 10, 0.5, 2],
    true,
    {
        params ["_value"];
        VSA_stormDischargeEnd = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_stormFogEnd",
    "SLIDER",
    [localize "STR_VSA_stormFogEnd", localize "STR_VSA_stormFogEnd_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 1, 0.8, 2],
    true,
    {
        params ["_value"];
        VSA_stormFogEnd = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormRainEnd",
    "SLIDER",
    [localize "STR_VSA_stormRainEnd", localize "STR_VSA_stormRainEnd_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 1, 1, 2],
    true,
    {
        params ["_value"];
        VSA_stormRainEnd = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormRadius",
    "SLIDER",
    [localize "STR_VSA_stormRadius", localize "STR_VSA_stormRadius_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [100, 2000, 800, 0],
    true,
    {
        params ["_value"];
        VSA_stormRadius = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormGasDischarges",
    "CHECKBOX",
    [localize "STR_VSA_stormGasDischarges", localize "STR_VSA_stormGasDischarges_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    true,
    true,
    {
        params ["_value"];
        VSA_stormGasDischarges = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormGasRadius",
    "SLIDER",
    [localize "STR_VSA_stormGasRadius", localize "STR_VSA_stormGasRadius_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [1, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_stormGasRadius = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormGasDensity",
    "SLIDER",
    [localize "STR_VSA_stormGasDensity", localize "STR_VSA_stormGasDensity_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [1, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_stormGasDensity = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormGasVertical",
    "SLIDER",
    [localize "STR_VSA_stormGasVertical", localize "STR_VSA_stormGasVertical_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [1, 30, 5, 0],
    true,
    {
        params ["_value"];
        VSA_stormGasVertical = _value;
    }
] call CBA_fnc_addSetting;

// Blowouts
[
    "VSA_enableBlowouts",
    "CHECKBOX",
    [localize "STR_VSA_enableBlowouts", localize "STR_VSA_enableBlowouts_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableBlowouts = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutMinDelay",
    "SLIDER",
    [localize "STR_VSA_blowoutMinDelay", localize "STR_VSA_blowoutMinDelay_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [0, 24, 2, 1],
    true,
    {
        params ["_value"];
        VSA_blowoutMinDelay = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutMaxDelay",
    "SLIDER",
    [localize "STR_VSA_blowoutMaxDelay", localize "STR_VSA_blowoutMaxDelay_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [0, 48, 6, 1],
    true,
    {
        params ["_value"];
        VSA_blowoutMaxDelay = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutDurationMin",
    "SLIDER",
    [localize "STR_VSA_blowoutDurationMin", localize "STR_VSA_blowoutDurationMin_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [60, 600, 180, 0],
    true,
    {
        params ["_value"];
        VSA_blowoutDurationMin = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutDurationMax",
    "SLIDER",
    [localize "STR_VSA_blowoutDurationMax", localize "STR_VSA_blowoutDurationMax_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [60, 1200, 300, 0],
    true,
    {
        params ["_value"];
        VSA_blowoutDurationMax = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutDirection",
    "SLIDER",
    [localize "STR_VSA_blowoutDirection", localize "STR_VSA_blowoutDirection_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [0, 360, 0, 0],
    true,
    {
        params ["_value"];
        VSA_blowoutDirection = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutSpeedMin",
    "SLIDER",
    [localize "STR_VSA_blowoutSpeedMin", localize "STR_VSA_blowoutSpeedMin_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [1, 100, 10, 0],
    true,
    {
        params ["_value"];
        VSA_blowoutSpeedMin = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_blowoutSpeedMax",
    "SLIDER",
    [localize "STR_VSA_blowoutSpeedMax", localize "STR_VSA_blowoutSpeedMax_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"],
    [1, 100, 30, 0],
    true,
    {
        params ["_value"];
        VSA_blowoutSpeedMax = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_killAIEmission",
    "CHECKBOX",
    [localize "STR_VSA_killAIEmission", localize "STR_VSA_killAIEmission_Tooltip"],
    [localize "STR_VSA_Category_Blowouts"], // Should arguably be under Blowouts or Emission
    true,
    true,
    {
        params ["_value"];
        VSA_killAIEmission = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormOvercast",
    "SLIDER",
    [localize "STR_VSA_stormOvercast", localize "STR_VSA_stormOvercast_Tooltip"],
    [localize "STR_VSA_Category_Storms"], // This seems like it belongs to Storms
    [0, 1, 0.8, 2],
    true,
    {
        params ["_value"];
        VSA_stormOvercast = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_stormOvercastTime",
    "SLIDER",
    [localize "STR_VSA_stormOvercastTime", localize "STR_VSA_stormOvercastTime_Tooltip"],
    [localize "STR_VSA_Category_Storms"],
    [0, 300, 60, 0],
    true,
    {
        params ["_value"];
        VSA_stormOvercastTime = _value;
    }
] call CBA_fnc_addSetting;


// Zombification
[
    "VSA_enableZombification",
    "CHECKBOX",
    [localize "STR_VSA_enableZombification", localize "STR_VSA_enableZombification_Tooltip"],
    [localize "STR_VSA_Category_Zombification"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableZombification = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_zombieCount",
    "SLIDER",
    [localize "STR_VSA_zombieCount", localize "STR_VSA_zombieCount_Tooltip"],
    [localize "STR_VSA_Category_Zombification"],
    [0, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_zombieCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_zombieSpawnWeight",
    "SLIDER",
    [localize "STR_VSA_zombieSpawnWeight", localize "STR_VSA_zombieSpawnWeight_Tooltip"],
    [localize "STR_VSA_Category_Zombification"],
    [0, 1, 0.8, 2],
    true,
    {
        params ["_value"];
        VSA_zombieSpawnWeight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_zombiesNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_zombiesNightOnly", localize "STR_VSA_zombiesNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Zombification"],
    false,
    true,
    {
        params ["_value"];
        VSA_zombiesNightOnly = _value;
    }
] call CBA_fnc_addSetting;


// Necroplague
[
    "VSA_enableNecroplague",
    "CHECKBOX",
    [localize "STR_VSA_enableNecroplague", localize "STR_VSA_enableNecroplague_Tooltip"],
    [localize "STR_VSA_Category_Necroplague"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableNecroplague = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_necroMinDelay",
    "SLIDER",
    [localize "STR_VSA_necroMinDelay", localize "STR_VSA_necroMinDelay_Tooltip"],
    [localize "STR_VSA_Category_Necroplague"],
    [60, 3600, 600, 0],
    true,
    {
        params ["_value"];
        VSA_necroMinDelay = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_necroMaxDelay",
    "SLIDER",
    [localize "STR_VSA_necroMaxDelay", localize "STR_VSA_necroMaxDelay_Tooltip"],
    [localize "STR_VSA_Category_Necroplague"],
    [60, 7200, 1800, 0],
    true,
    {
        params ["_value"];
        VSA_necroMaxDelay = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_necroHordes",
    "SLIDER",
    [localize "STR_VSA_necroHordes", localize "STR_VSA_necroHordes_Tooltip"],
    [localize "STR_VSA_Category_Necroplague"],
    [1, 10, 2, 0],
    true,
    {
        params ["_value"];
        VSA_necroHordes = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_necroZombies",
    "SLIDER",
    [localize "STR_VSA_necroZombies", localize "STR_VSA_necroZombies_Tooltip"],
    [localize "STR_VSA_Category_Necroplague"],
    [1, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_necroZombies = _value;
    }
] call CBA_fnc_addSetting;


// AI Tweaks
[
    "VSA_enableAIBehaviour",
    "CHECKBOX",
    [localize "STR_VSA_enableAIBehaviour", localize "STR_VSA_enableAIBehaviour_Tooltip"],
    [localize "STR_VSA_Category_AI"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableAIBehaviour = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_panicThreshold",
    "SLIDER",
    [localize "STR_VSA_panicThreshold", localize "STR_VSA_panicThreshold_Tooltip"],
    [localize "STR_VSA_Category_AI"],
    [0, 1, 0.3, 2],
    true,
    {
        params ["_value"];
        VSA_panicThreshold = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_aiNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_aiNightOnly", localize "STR_VSA_aiNightOnly_Tooltip"],
    [localize "STR_VSA_Category_AI"],
    false,
    true,
    {
        params ["_value"];
        VSA_aiNightOnly = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_aiAnomalyAvoidChance",
    "SLIDER",
    [localize "STR_VSA_aiAnomalyAvoidChance", localize "STR_VSA_aiAnomalyAvoidChance_Tooltip"],
    [localize "STR_VSA_Category_AI"],
    [0, 1, 0.8, 2],
    true,
    {
        params ["_value"];
        VSA_aiAnomalyAvoidChance = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_aiAnomalyAvoidRange",
    "SLIDER",
    [localize "STR_VSA_aiAnomalyAvoidRange", localize "STR_VSA_aiAnomalyAvoidRange_Tooltip"],
    [localize "STR_VSA_Category_AI"],
    [0, 100, 20, 0],
    true,
    {
        params ["_value"];
        VSA_aiAnomalyAvoidRange = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_fieldAvoidEnabled",
    "CHECKBOX",
    [localize "STR_VSA_fieldAvoidEnabled", localize "STR_VSA_fieldAvoidEnabled_Tooltip"],
    [localize "STR_VSA_Category_AI"],
    true,
    true,
    {
        params ["_value"];
        VSA_fieldAvoidEnabled = _value;
    }
] call CBA_fnc_addSetting;


// Extra Mutant Settings
[
    "VSA_mutantGroupCountHostile",
    "SLIDER",
    [localize "STR_VSA_mutantGroupCountHostile", localize "STR_VSA_mutantGroupCountHostile_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_mutantGroupCountHostile = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_mutantThreat",
    "SLIDER",
    [localize "STR_VSA_mutantThreat", localize "STR_VSA_mutantThreat_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_mutantThreat = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_mutantNightOnlyHostile",
    "CHECKBOX",
    [localize "STR_VSA_mutantNightOnlyHostile", localize "STR_VSA_mutantNightOnlyHostile_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    false,
    true,
    {
        params ["_value"];
        VSA_mutantNightOnlyHostile = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambientHerdCount",
    "SLIDER",
    [localize "STR_VSA_ambientHerdCount", localize "STR_VSA_ambientHerdCount_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_ambientHerdCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambientHerdSize",
    "SLIDER",
    [localize "STR_VSA_ambientHerdSize", localize "STR_VSA_ambientHerdSize_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_ambientHerdSize = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambientNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_ambientNightOnly", localize "STR_VSA_ambientNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    false,
    true,
    {
        params ["_value"];
        VSA_ambientNightOnly = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_predatorAttackChance",
    "SLIDER",
    [localize "STR_VSA_predatorAttackChance", localize "STR_VSA_predatorAttackChance_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 1, 0.2, 2],
    true,
    {
        params ["_value"];
        VSA_predatorAttackChance = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_predatorRange",
    "SLIDER",
    [localize "STR_VSA_predatorRange", localize "STR_VSA_predatorRange_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [100, 2000, 500, 0],
    true,
    {
        params ["_value"];
        VSA_predatorRange = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_predatorCheckIntervalDay",
    "SLIDER",
    [localize "STR_VSA_predatorCheckIntervalDay", localize "STR_VSA_predatorCheckIntervalDay_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [60, 3600, 600, 0],
    true,
    {
        params ["_value"];
        VSA_predatorCheckIntervalDay = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_predatorCheckIntervalNight",
    "SLIDER",
    [localize "STR_VSA_predatorCheckIntervalNight", localize "STR_VSA_predatorCheckIntervalNight_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [60, 3600, 300, 0],
    true,
    {
        params ["_value"];
        VSA_predatorCheckIntervalNight = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_proximityCheckInterval",
    "SLIDER",
    [localize "STR_VSA_proximityCheckInterval", localize "STR_VSA_proximityCheckInterval_Tooltip"],
    [localize "STR_VSA_Category_Core"],
    [0, 60, 5, 0],
    true,
    {
        params ["_value"];
        VSA_proximityCheckInterval = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatCheckInterval",
    "SLIDER",
    [localize "STR_VSA_habitatCheckInterval", localize "STR_VSA_habitatCheckInterval_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [60, 3600, 600, 0],
    true,
    {
        params ["_value"];
        VSA_habitatCheckInterval = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_maxAmbientHerds",
    "SLIDER",
    [localize "STR_VSA_maxAmbientHerds", localize "STR_VSA_maxAmbientHerds_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_maxAmbientHerds = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_maxHostileGroups",
    "SLIDER",
    [localize "STR_VSA_maxHostileGroups", localize "STR_VSA_maxHostileGroups_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_maxHostileGroups = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_maxMutantNests",
    "SLIDER",
    [localize "STR_VSA_maxMutantNests", localize "STR_VSA_maxMutantNests_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [0, 20, 5, 0],
    true,
    {
        params ["_value"];
        VSA_maxMutantNests = _value;
    }
] call CBA_fnc_addSetting;


[
    "VSA_nestsNightOnly",
    "CHECKBOX",
    [localize "STR_VSA_nestsNightOnly", localize "STR_VSA_nestsNightOnly_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    false,
    true,
    {
        params ["_value"];
        VSA_nestsNightOnly = _value;
    }
] call CBA_fnc_addSetting;

// Habitat sizes
[
    "VSA_habitatSize_Bloodsucker",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Bloodsucker", localize "STR_VSA_habitatSize_Bloodsucker_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 10, 3, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Bloodsucker = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Dog",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Dog", localize "STR_VSA_habitatSize_Dog_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 20, 8, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Dog = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Boar",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Boar", localize "STR_VSA_habitatSize_Boar_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 15, 6, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Boar = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Cat",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Cat", localize "STR_VSA_habitatSize_Cat_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 10, 4, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Cat = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Flesh",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Flesh", localize "STR_VSA_habitatSize_Flesh_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 15, 6, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Flesh = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Pseudodog",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Pseudodog", localize "STR_VSA_habitatSize_Pseudodog_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 10, 4, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Pseudodog = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Controller",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Controller", localize "STR_VSA_habitatSize_Controller_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 3, 1, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Controller = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Pseudogiant",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Pseudogiant", localize "STR_VSA_habitatSize_Pseudogiant_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 3, 1, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Pseudogiant = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Izlom",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Izlom", localize "STR_VSA_habitatSize_Izlom_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 10, 4, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Izlom = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_habitatSize_Snork",
    "SLIDER",
    [localize "STR_VSA_habitatSize_Snork", localize "STR_VSA_habitatSize_Snork_Tooltip"],
    [localize "STR_VSA_Category_Mutants"],
    [1, 10, 5, 0],
    true,
    {
        params ["_value"];
        VSA_habitatSize_Snork = _value;
    }
] call CBA_fnc_addSetting;

// Ambushes
[
    "VSA_enableAmbushes",
    "CHECKBOX",
    [localize "STR_VSA_enableAmbushes", localize "STR_VSA_enableAmbushes_Tooltip"],
    [localize "STR_VSA_Category_Ambushes"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableAmbushes = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambushCount",
    "SLIDER",
    [localize "STR_VSA_ambushCount", localize "STR_VSA_ambushCount_Tooltip"],
    [localize "STR_VSA_Category_Ambushes"],
    [0, 50, 10, 0],
    true,
    {
        params ["_value"];
        VSA_ambushCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambushTownDistance",
    "SLIDER",
    [localize "STR_VSA_ambushTownDistance", localize "STR_VSA_ambushTownDistance_Tooltip"],
    [localize "STR_VSA_Category_Ambushes"],
    [0, 1000, 300, 0],
    true,
    {
        params ["_value"];
        VSA_ambushTownDistance = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambushMinUnits",
    "SLIDER",
    [localize "STR_VSA_ambushMinUnits", localize "STR_VSA_ambushMinUnits_Tooltip"],
    [localize "STR_VSA_Category_Ambushes"],
    [1, 10, 3, 0],
    true,
    {
        params ["_value"];
        VSA_ambushMinUnits = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_ambushMaxUnits",
    "SLIDER",
    [localize "STR_VSA_ambushMaxUnits", localize "STR_VSA_ambushMaxUnits_Tooltip"],
    [localize "STR_VSA_Category_Ambushes"],
    [1, 20, 6, 0],
    true,
    {
        params ["_value"];
        VSA_ambushMaxUnits = _value;
    }
] call CBA_fnc_addSetting;


// Minefields
[
    "VSA_enableMinefields",
    "CHECKBOX",
    [localize "STR_VSA_enableMinefields", localize "STR_VSA_enableMinefields_Tooltip"],
    [localize "STR_VSA_Category_Minefields"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableMinefields = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_minefieldCount",
    "SLIDER",
    [localize "STR_VSA_minefieldCount", localize "STR_VSA_minefieldCount_Tooltip"],
    [localize "STR_VSA_Category_Minefields"],
    [0, 50, 15, 0],
    true,
    {
        params ["_value"];
        VSA_minefieldCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_minefieldSize",
    "SLIDER",
    [localize "STR_VSA_minefieldSize", localize "STR_VSA_minefieldSize_Tooltip"],
    [localize "STR_VSA_Category_Minefields"],
    [5, 100, 25, 0],
    true,
    {
        params ["_value"];
        VSA_minefieldSize = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_IEDCount",
    "SLIDER",
    [localize "STR_VSA_IEDCount", localize "STR_VSA_IEDCount_Tooltip"],
    [localize "STR_VSA_Category_Minefields"],
    [0, 50, 20, 0],
    true,
    {
        params ["_value"];
        VSA_IEDCount = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_enableBoobyTraps",
    "CHECKBOX",
    [localize "STR_VSA_enableBoobyTraps", localize "STR_VSA_enableBoobyTraps_Tooltip"],
    [localize "STR_VSA_Category_Minefields"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableBoobyTraps = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_boobyTrapCount",
    "SLIDER",
    [localize "STR_VSA_boobyTrapCount", localize "STR_VSA_boobyTrapCount_Tooltip"],
    [localize "STR_VSA_Category_Minefields"],
    [0, 50, 15, 0],
    true,
    {
        params ["_value"];
        VSA_boobyTrapCount = _value;
    }
] call CBA_fnc_addSetting;

// Wrecks
[
    "VSA_enableWrecks",
    "CHECKBOX",
    [localize "STR_VSA_enableWrecks", localize "STR_VSA_enableWrecks_Tooltip"],
    [localize "STR_VSA_Category_Wrecks"],
    true,
    true,
    {
        params ["_value"];
        VSA_enableWrecks = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_wreckCount",
    "SLIDER",
    [localize "STR_VSA_wreckCount", localize "STR_VSA_wreckCount_Tooltip"],
    [localize "STR_VSA_Category_Wrecks"],
    [0, 100, 30, 0],
    true,
    {
        params ["_value"];
        VSA_wreckCount = _value;
    }
] call CBA_fnc_addSetting;

// Antistasi
[
    "VSA_disableA3UWeather",
    "CHECKBOX",
    [localize "STR_VSA_disableA3UWeather", localize "STR_VSA_disableA3UWeather_Tooltip"],
    [localize "STR_VSA_Category_Antistasi"],
    true,
    true,
    {
        params ["_value"];
        VSA_disableA3UWeather = _value;
    }
] call CBA_fnc_addSetting;


// Debug
[
    "VSA_debugMode",
    "CHECKBOX",
    [localize "STR_VSA_debugMode", localize "STR_VSA_debugMode_Tooltip"],
    [localize "STR_VSA_Category_Debug"],
    false,
    true,
    {
        params ["_value"];
        VSA_debugMode = _value;
    }
] call CBA_fnc_addSetting;

[
    "VSA_AIPanicEnabled",
    "CHECKBOX",
    [localize "STR_VSA_AIPanicEnabled", localize "STR_VSA_AIPanicEnabled_Tooltip"],
    [localize "STR_VSA_Category_Emission"],
    true,
    true
] call CBA_fnc_addSetting;
