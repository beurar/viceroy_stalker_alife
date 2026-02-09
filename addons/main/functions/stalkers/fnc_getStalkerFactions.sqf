#include "\z\viceroy_stalker_alife\addons\main\script_component.hpp"
/*
    Returns the definition of Stalker factions, their sides, and unit classes.
    Format: [FactionName, [allowed sides], [unit classes]]
*/

[
    ["ClearSky",   [blufor,opfor,independent,civilian], [
        "B_CS_Artifact_Seeker_01","B_CS_Exo_01","B_CS_Experienced_01",
        "B_CS_Guardian_01","B_CS_Journeyman_01","B_CS_Nomad_01",
        "B_CS_Pathfinder_01","B_CS_Rookie_01","B_CS_Tracker_01",
        "SIL_STALKER_ClearSky_Medic_F","SIL_STALKER_ClearSky_Rifleman_1_F",
        "SIL_STALKER_ClearSky_Rifleman_2_F","SIL_STALKER_ClearSky_Rifleman_Light_F",
        "SIL_STALKER_ClearSky_Sharpshooter_F","SIL_STALKER_ClearSky_SEVA_Medic_F",
        "SIL_STALKER_ClearSky_SEVA_Rifleman_1_F","SIL_STALKER_ClearSky_SEVA_Rifleman_2_F",
        "SIL_STALKER_ClearSky_SEVA_Rifleman_Light_F","SIL_STALKER_ClearSky_SEVA_Sharpshooter_F",
        "SIL_STALKER_ClearSky_NoPPE_Medic_F","SIL_STALKER_ClearSky_NoPPE_Rifleman_1_F",
        "SIL_STALKER_ClearSky_NoPPE_Rifleman_2_F","SIL_STALKER_ClearSky_NoPPE_Rifleman_Light_F",
        "SIL_STALKER_ClearSky_NoPPE_Sharpshooter_F"
    ]],
    ["Mercenaries", [blufor,opfor,independent], [
        "B_Merc_Contractor_01","B_Merc_Exo_Merc_01","B_Merc_Merc_Assassin_01",
        "B_Merc_Merc_Scout_01","B_Merc_Merc_Seva_01","B_Merc_Old_Hand_01",
        "B_Merc_Trained_Merc_01",
        "SIL_STALKER_Merc_Autorifleman_F","SIL_STALKER_Merc_Medic_F",
        "SIL_STALKER_Merc_Rifleman_1_F","SIL_STALKER_Merc_Rifleman_2_F",
        "SIL_STALKER_Merc_Rifleman_Light_F","SIL_STALKER_Merc_Sharpshooter_F",
        "SIL_STALKER_Merc_Night_Medic_F","SIL_STALKER_Merc_Night_Rifleman_1_F",
        "SIL_STALKER_Merc_Night_Rifleman_2_F","SIL_STALKER_Merc_Night_Rifleman_Light_F",
        "SIL_STALKER_Merc_Night_Sharpshooter_F","SIL_STALKER_Merc_NoPPE_Autorifleman_F",
        "SIL_STALKER_Merc_NoPPE_Medic_F","SIL_STALKER_Merc_NoPPE_Rifleman_1_F",
        "SIL_STALKER_Merc_NoPPE_Rifleman_2_F","SIL_STALKER_Merc_NoPPE_Rifleman_Light_F",
        "SIL_STALKER_Merc_NoPPE_Sharpshooter_F"
    ]],
    ["Freedom",    [blufor,opfor,independent,civilian], [
        "B_FD_Anomaly_Splunker_01","B_FD_Defender_01","B_FD_Exo_01",
        "B_FD_Guardian_01","B_FD_Seedy_01","B_FD_Seedy_Sniper_01",
        "B_FD_Wardog_01",
        "SIL_STALKER_Freedom_Engineer_F","SIL_STALKER_Freedom_Medic_F",
        "SIL_STALKER_Freedom_Rifleman_1_F","SIL_STALKER_Freedom_Rifleman_2_F",
        "SIL_STALKER_Freedom_Rifleman_Light_F","SIL_STALKER_Freedom_Sharpshooter_F",
        "SIL_STALKER_Freedom_Exo_Rifleman_1_F","SIL_STALKER_Freedom_Exo_Rifleman_2_F",
        "SIL_STALKER_Freedom_NoPPE_Engineer_F","SIL_STALKER_Freedom_NoPPE_Medic_F",
        "SIL_STALKER_Freedom_NoPPE_Rifleman_1_F","SIL_STALKER_Freedom_NoPPE_Rifleman_2_F",
        "SIL_STALKER_Freedom_NoPPE_Rifleman_Light_F","SIL_STALKER_Freedom_NoPPE_Sharpshooter_F",
        "SIL_STALKER_Freedom_SEVA_Medic_F","SIL_STALKER_Freedom_SEVA_Rifleman_1_F",
        "SIL_STALKER_Freedom_SEVA_Rifleman_2_F","SIL_STALKER_Freedom_SEVA_Rifleman_Light_F"
    ]],
    ["Bandits",    [blufor,opfor,independent,civilian], [
        "O_Bdz_Assaulter_01","O_Bdz_Conman_01","O_Bdz_Criminal_01",
        "O_Bdz_Exo_01","O_Bdz_Raider_01","O_Bdz_Robber_01",
        "O_Bdz_Thug_01","O_Bdz_Waster_01",
        "O_sin_Apprentice_01","O_sin_Disciple_01","O_sin_Executor_01",
        "O_sin_Healer_01","O_sin_High_Prosecutor_01","O_sin_Novice_01",
        "O_sin_Sin_Enforcer_01",
        "SIL_STALKER_Bandit_Autorifleman_F","SIL_STALKER_Bandit_Rifleman_1_F",
        "SIL_STALKER_Bandit_Rifleman_2_F","SIL_STALKER_Bandit_Rifleman_Light_F",
        "SIL_STALKER_Bandit_Sharpshooter_F"
    ]],
    ["Duty",       [blufor,opfor], [
        "O_ODty_Artifact_Specialist_01","O_ODty_Duty_Hunter_01","O_ODty_Duty_Patrolman_01",
        "O_ODty_Duty_Officer_01","O_ODty_Duty_Private_01","O_ODty_Duty_Sniper_01",
        "O_ODty_Duty_Specialist_01","O_ODty_Duty_Trooper_01",
        "SIL_STALKER_Duty_Autorifleman_F","SIL_STALKER_Duty_Engineer_F",
        "SIL_STALKER_Duty_Medic_F","SIL_STALKER_Duty_Rifleman_1_F",
        "SIL_STALKER_Duty_Rifleman_2_F","SIL_STALKER_Duty_Rifleman_Light_F",
        "SIL_STALKER_Duty_Sharpshooter_F","SIL_STALKER_Duty_Exo_Rifleman_1_F",
        "SIL_STALKER_Duty_Exo_Rifleman_2_F","SIL_STALKER_Duty_SEVA_Medic_F",
        "SIL_STALKER_Duty_SEVA_Rifleman_1_F","SIL_STALKER_Duty_SEVA_Rifleman_2_F"
    ]]
]
