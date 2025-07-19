untyped

global function GamemodeEXT_Init

global function SetupExtractionMap

global function ExtractionIntro_Setup
global function ExtractionIntro_GetDuration

global function Extraction_AddDefaultEnemyAssaultPoint
global function Extraction_PlaceRespawnTerminal
global function Extraction_PlaceTitanTerminal
global function Extraction_PlaceRobotBank
global function Extraction_PlaceWeaponCrate
global function Extraction_PlaceTerminalInteractor
global function Extraction_PlaceBatterySpot
global function Extraction_PlaceHackStation
global function Extraction_AddExtractionPoint

struct ExtractionPlayer{
	int objectivesCompleted = 0
}

struct {
	table< entity, ExtractionPlayer > matchPlayers
	array< void functionref() > extractionCallbacks
	vector enemiesAssaultSpecialPosition = < 0, 0, 0 >
	array< vector > enemiesDefaultAssaultPositions
	entity objectiveHarvester
	entity harvesterBeam
	entity spawnedBattery
	entity choseBatteryPlatform
	entity respawnTerminal
	entity titanTerminal
	array< entity > robotBanks
	array< entity > terminalPanels
	array< entity > hackStations
	array< entity > batteryPlatforms
	array< string > playersThatCalledTheirTitans
	array< entity > extractionNodes
	array< entity > weaponCrates
	array< entity > droppedTablets
	int previousObjective //Avoid repeating in sequence
	int amountOfObjectivesForExtraction
	int amountOfObjectivesDone
	int maxEnemyReapers = 0
	int maxEnemyTitans = 0
	int maxEnemyGrunts = AI_HARD_LIMIT
	int maxEnemySpectres = 0
	int maxEnemyStalkers = 0
	int maxInfantryAI = AI_HARD_LIMIT
	array< int > availableObjectives = [eEXTObjectives.DestroyHarvester,eEXTObjectives.DataRecovery,eEXTObjectives.KillQuota] // Basic 3 that can work globally without manual dependence
	float respawnTerminalCooldown = 60
	float weaponCrateRespawnTime = 120
	float extractionDropshipTime = 190
	float timeToExtract = 190
	int chanceOfIncreasingHazard = 40
	int maxAlliedTitans = 4
	int minGunsCrates = 2
	int maxGunsCrates = 5
}file

const float OBJECTIVE_TIME_BREAK = 30 // This could be configurable, but not doing because it is decent minimum time that announcements dont overlap each other
const float OBJECTIVE_TIME_INTERVAL_BETWEEN = 2.5
const float OBJECTIVE_TIME_HARVESTER_DESTRUCTION = 150
const float OBJECTIVE_TIME_TERMINAL_ACTIVATION = 60
const float OBJECTIVE_TIME_DATA_RECOVERY = 120
const float OBJECTIVE_TIME_KILL_QUOTA = 90
const float OBJECTIVE_TIME_BATTERY_GATHER = 120
const float OBJECTIVE_TIME_DATA_DELIVERY = 60
const float OBJECTIVE_TIME_KILL_ELITE_TITANS = 120

const int OBJECTIVE_AMT_HACKSTATION_BASE = 200

const float SCORE_OBJECTIVE_KILLQUOTA = 2
const float SCORE_OBJECTIVE_HARVESTER_DAMAGE = 1
const float SCORE_OBJECTIVE_INTEL_GATHER = 4
const float SCORE_OBJECTIVE_INTEL_DELIVER = 5
const float SCORE_OBJECTIVE_HACK_PROTECTION = 2
const float SCORE_OBJECTIVE_BATTERY_GATHER = 25
const float SCORE_OBJECTIVE_RESPAWN_TEAMMATES = 20
const float SCORE_OBJECTIVE_REVIVED_ALLY = 10
const float SCORE_OBJECTIVE_GEARFOUND = 15
const float SCORE_OBJECTIVE_KILLED_ELITE_TITAN = 30

const float HAZARD_TIME_DELAY = 10 // Debounce time between "objective completed" announcement and potential hazard level increase

const int OBJECTIVE_HARVESTER_BASE_HEALTH = 5000
const int HACK_GRUNT_HEALTH_AMOUNT = 800
const int HACK_STATION_SCORE_RANGE = 600
const int PLAYER_TURRET_HEALTH_AMOUNT = 1250
const int WEAPON_CRATE_HEALTH = 100

const float INFANTRY_ASSAULT_ENGAGEMENT_RADIUS = 600 // Total combat area the enemies will stick around looking to for cover and targets
const float TITAN_ASSAULT_ENGAGEMENT_RADIUS = 1200 // Titans requires a bit more space to not feel cramped around combat point
const float SPAWN_ENEMY_MINDIST = 600 // Players won't have enemies spawning within this distance from them
const float SPAWN_ENEMY_MAXDIST_LOCATION = 3000 // When objective is an enemy magnet one, cap the very far distances

const asset WEAPON_CRATE_MODEL = $"models/containers/pelican_case_ammobox.mdl"
const asset MODEL_TERMINAL_PLACEHOLDER = $"models/weapons/bullets/triple_threat_projectile.mdl"
const asset MODEL_DATA_TABLET = $"models/robots/drone_frag/frag_drone_proj.mdl"
const asset MODEL_HARVESTER_EXTRACTION = $"models/props/generator_coop/generator_coop_small.mdl"
const asset MODEL_BATTERY_SPAWNER_BASE = $"models/props/turret_base/turret_base.mdl"
const asset MODEL_HACK_STATION = $"models/communication/terminal_com_station.mdl"

const array< string > DROPPOD_IDLE_ANIMS = ["dp_idle_A","dp_idle_C","dp_idle_D","dp_idle_B"]
const array< string > DROPPOD_IDLE_ANIMS_POV = ["ptpov_droppod_drop_front_L","ptpov_droppod_drop_front_R","ptpov_droppod_drop_back_R","ptpov_droppod_drop_back_L"]
const array< string > DROPPOD_EXIT_ANIMS = ["dp_exit_A","dp_exit_C","dp_exit_D","dp_exit_B"]
const array< string > DROPPOD_EXIT_ANIMS_POV = ["ptpov_droppod_exit_front_L","ptpov_droppod_exit_front_R","ptpov_droppod_exit_back_R","ptpov_droppod_exit_back_L"]
const array< string > EVAC_EMBARK_ANIMS_3P = ["pt_e3_rescue_side_embark_A","pt_e3_rescue_side_embark_B","pt_e3_rescue_side_embark_C","pt_e3_rescue_side_embark_D","pt_e3_rescue_side_embark_E","pt_e3_rescue_side_embark_F","pt_e3_rescue_side_embark_G","pt_e3_rescue_side_embark_H"]
const array< string > EVAC_IDLE_ANIMS_1P = ["ptpov_e3_rescue_side_embark_A_idle","ptpov_e3_rescue_side_embark_B_idle","ptpov_e3_rescue_side_embark_C_idle","ptpov_e3_rescue_side_embark_D_idle","ptpov_e3_rescue_side_embark_E_idle","ptpov_e3_rescue_side_embark_F_idle","ptpov_e3_rescue_side_embark_G_idle","ptpov_e3_rescue_side_embark_H_idle"]
const array< string > EVAC_IDLE_ANIMS_3P = ["pt_e3_rescue_side_idle_A","pt_e3_rescue_side_idle_B","pt_e3_rescue_side_idle_C","pt_e3_rescue_side_idle_D","pt_e3_rescue_side_idle_E","pt_e3_rescue_side_idle_F","pt_e3_rescue_side_idle_G","pt_e3_rescue_side_idle_H"]










/*
██ ███    ██ ██ ████████ ██  █████  ██      ██ ███████  █████  ████████ ██  ██████  ███    ██ 
██ ████   ██ ██    ██    ██ ██   ██ ██      ██    ███  ██   ██    ██    ██ ██    ██ ████   ██ 
██ ██ ██  ██ ██    ██    ██ ███████ ██      ██   ███   ███████    ██    ██ ██    ██ ██ ██  ██ 
██ ██  ██ ██ ██    ██    ██ ██   ██ ██      ██  ███    ██   ██    ██    ██ ██    ██ ██  ██ ██ 
██ ██   ████ ██    ██    ██ ██   ██ ███████ ██ ███████ ██   ██    ██    ██  ██████  ██   ████ 
*/

void function GamemodeEXT_Init()
{
	PrecacheModel( MODEL_FRONTIER_DEFENSE_PORT )
	PrecacheModel( MODEL_FRONTIER_DEFENSE_TURRET_SITE )
	PrecacheModel( MODEL_IMC_SHIELD_CAPTAIN )
	PrecacheModel( MODEL_ATTRITION_BANK )
	PrecacheModel( MODEL_HARVESTER_EXTRACTION )
	PrecacheModel( MODEL_BATTERY_SPAWNER_BASE )
	PrecacheModel( MODEL_HACK_STATION )

	RegisterSignal( "BatteryActivate" ) //From Frontier War, to allow use the battery port
	RegisterSignal( "BankPickedForDataDelivery" ) //Intervention of empty robot banks

	FlagSet( "DisableTimeLimit" )
	SetSwitchSidesBased( false )
	SetServerVar( "replayDisabled", true )
	SetServerVar( "titanDropEnabledForTeam", TEAM_IMC )
	Riff_ForceSetEliminationMode( eEliminationMode.Pilots )

	AddCallback_EntitiesDidLoad( LoadExtractionContent )

	ClassicMP_SetCustomIntro( ExtractionIntro_Setup, ExtractionIntro_GetDuration() )
	ClassicMP_ForceDisableEpilogue( true )

	AddCallback_OnClientConnected( GamemodeEXT_InitPlayer )
	AddCallback_OnClientDisconnected( GamemodeEXT_PlayerDisconnected )
	AddCallback_OnPlayerKilled( GamemodeEXT_OnPlayerKilled )
	AddCallback_OnPlayerGetsNewPilotLoadout( OverrideExtractionPilotLoadout )
	AddCallback_OnPilotBecomesTitan( EXT_EmbarkTitan )
	AddCallback_OnTitanBecomesPilot( EXT_DisembarkTitan )

	AddClientCommandCallback( "dropbattery", ClientCommandCallbackEXTDropBattery )

	AddCallback_GameStateEnter( eGameState.Prematch, Extraction_Prematch )
	AddCallback_GameStateEnter( eGameState.Playing, Extraction_GameplayStart )

	ScoreEvent_SetupScoreValuesForExtraction()
	SetApplyBatteryCallback( EXT_BatteryObjectiveCheck )

	AddDamageCallback( "player", MitigateComboDamage )
	AddDamageCallback( "npc_titan", MitigateComboDamage )
	AddDamageCallback( "npc_turret_sentry", MitigateComboDamage )
	AddDamageCallback( "npc_soldier", MitigateComboDamage )

	AddSpawnCallback( "npc_titan", TitanScaleByHazard )
	AddSpawnCallback( "npc_turret_sentry", AddTurretSentry )
	AddSpawnCallback( "npc_frag_drone", OnTickSpawn )

	AddDeathCallback( "npc_drone", EXT_OnNPCDeath )
	AddDeathCallback( "npc_frag_drone", EXT_OnNPCDeath )
	AddDeathCallback( "npc_soldier", EXT_OnNPCDeath )
	AddDeathCallback( "npc_spectre", EXT_OnNPCDeath )
	AddDeathCallback( "npc_stalker", EXT_OnNPCDeath )
	AddDeathCallback( "npc_super_spectre", EXT_OnNPCDeath )
	AddDeathCallback( "npc_titan", EXT_OnNPCDeath )

	Bleedout_SetCallback_OnPlayerGiveFirstAid( EXT_PlayerRevivesAlly )

	level.endOfRoundPlayerState = ENDROUND_FREE

	FlagInit( "EnemySpawnerActive", true )

	file.maxAlliedTitans = GetCurrentPlaylistVarInt( "ext_max_ally_titans", 4 )
	file.chanceOfIncreasingHazard = GetCurrentPlaylistVarInt( "ext_hazard_chance", 40 )
	file.respawnTerminalCooldown = GetCurrentPlaylistVarFloat( "ext_respawn_cooldown", 60 )
	file.weaponCrateRespawnTime = GetCurrentPlaylistVarFloat( "ext_weapon_crate_time", 120 )
	file.extractionDropshipTime = GetCurrentPlaylistVarFloat( "ext_time_extraction", 120 )
	file.minGunsCrates = maxint( 1, GetCurrentPlaylistVarInt( "ext_weapon_crate_min_guns", 2 ) )
	file.maxGunsCrates = maxint( file.minGunsCrates, GetCurrentPlaylistVarInt( "ext_weapon_crate_max_guns", 5 ) )
	file.maxInfantryAI = maxint( 1, GetCurrentPlaylistVarInt( "ext_max_active_infantry", AI_HARD_LIMIT ) )
}

void function ScoreEvent_SetupScoreValuesForExtraction()
{
	ScoreEvent_SetXPValueFaction( GetScoreEvent( "ChallengeTTDM" ), 1 )
	ScoreEvent_SetXPValueWeapon( GetScoreEvent( "KillTitan" ), 1 )
	ScoreEvent_SetXPValueWeapon( GetScoreEvent( "TitanAssist" ), 1 )
	ScoreEvent_SetXPValueTitan( GetScoreEvent( "TitanKillTitan" ), 1 )

	ScoreEvent_SetDisplayType( GetScoreEvent( "KillDrone" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "KillGrunt" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "KillSpectre" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "KillStalker" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "KillSuperSpectre" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "KillTitan" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "TitanAssist" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "TitanKillTitan" ), eEventDisplayType.MEDAL | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "FDHealingBonus" ), eEventDisplayType.MEDAL | eEventDisplayType.GAMEMODE | eEventDisplayType.CENTER )
	ScoreEvent_SetDisplayType( GetScoreEvent( "FDTeamHeal" ), eEventDisplayType.GAMEMODE | eEventDisplayType.MEDAL | eEventDisplayType.CALLINGCARD )
	ScoreEvent_SetDisplayType( GetScoreEvent( "FDSupportBonus" ), eEventDisplayType.GAMEMODE | eEventDisplayType.MEDAL | eEventDisplayType.CALLINGCARD )
	ScoreEvent_SetDisplayType( GetScoreEvent( "FDDamageBonus" ), eEventDisplayType.GAMEMODE | eEventDisplayType.MEDAL | eEventDisplayType.CALLINGCARD )

	ScoreEvent_SetEarnMeterValues( "FDHealingBonus", 0.05, 0.05 )
	ScoreEvent_SetEarnMeterValues( "FDTeamHeal", 0.10, 0.15 )
	ScoreEvent_SetEarnMeterValues( "FDSupportBonus", 0.10, 0.15 )
	ScoreEvent_SetEarnMeterValues( "FDDamageBonus", 0.10, 0.15 )
	ScoreEvent_SetEarnMeterValues( "KillDrone", 0.01, 0.02 )
	ScoreEvent_SetEarnMeterValues( "KillGrunt", 0.01, 0.02 )
	ScoreEvent_SetEarnMeterValues( "KillSpectre", 0.02, 0.02 )
	ScoreEvent_SetEarnMeterValues( "KillStalker", 0.03, 0.03 )
	ScoreEvent_SetEarnMeterValues( "KillSuperSpectre", 0.1, 0.1 )
	ScoreEvent_SetEarnMeterValues( "KillTitan", 0.25, 0.25 )
	ScoreEvent_SetEarnMeterValues( "TitanAssist", 0.1, 0.1 )
	ScoreEvent_SetEarnMeterValues( "TitanKillTitan", 0.1, 0.1 )
	ScoreEvent_SetEarnMeterValues( "DoomAutoTitan", 0.03, 0.03 )
	ScoreEvent_SetEarnMeterValues( "DoomTitan", 0.03, 0.03 )
	ScoreEvent_SetEarnMeterValues( "PilotBatteryApplied", 0.05, 0.05 )
	ScoreEvent_SetEarnMeterValues( "PilotBatteryStolen", 0.15, 0.15 )
}

void function LoadExtractionContent()
{
	SetGlobalNetInt( "hazardLevel", 1 )
	SetGlobalNetInt( "currentMainObjective", 0 )
	SetObjectiveMaxCounter( 0 )
	
	// The minimum objectives has to be at least 3 because the challenge of completing 3 of them
	int objectiveMin = maxint( 3, GetCurrentPlaylistVarInt( "ext_objective_min", 8 ) )
	int objectiveMax = maxint( objectiveMin, GetCurrentPlaylistVarInt( "ext_objective_max", 12 ) )

	if ( objectiveMin == objectiveMax )
		file.amountOfObjectivesForExtraction = objectiveMin
	else
		file.amountOfObjectivesForExtraction = RandomIntRange( objectiveMin, objectiveMax )

	Extraction_InitMaps()

	foreach ( callback in file.extractionCallbacks )
		callback()
	
	// Append those objectives on the load since some maps might not support them properly ( or modders might skip doing them too )
	if ( file.batteryPlatforms.len() )
		file.availableObjectives.append( eEXTObjectives.GatherBatteries )
	
	if ( file.terminalPanels.len() )
		file.availableObjectives.append( eEXTObjectives.ActivateTerminals )
	
	if ( file.hackStations.len() )
		file.availableObjectives.append( eEXTObjectives.DefendPosition )
}

void function Extraction_Prematch()
{
	BurnReward_GetByRef( "burnmeter_radar_jammer" ).rewardAvailableCallback = ExtractionRadarJammerBurncard // Since no minimap, this boost will block enemy spawns instead
	BurnReward_GetByRef( "burnmeter_maphack" ).rewardAvailableCallback = ExtractionMaphackBurncard // Reveals enemies for more time and also weapon crates and terminals
	BurnMeter_SetBoostLimit( "burnmeter_radar_jammer", 2 )
	BurnMeter_SetBoostLimit( "burnmeter_maphack", 2 )

	if ( !Flag( "LevelHasRoof" ) )
		thread StratonHornetDogfightsIntense()

	PickRobotsForJumpkitAndTactical()
	thread Infantry_Spawner_Thread()
	thread Reaper_Spawner_Thread()
	thread Titan_Spawner_Thread()
}










/*
███    ███  █████  ██ ███    ██      ██████   █████  ███    ███ ███████     ██       ██████   ██████  ██████  
████  ████ ██   ██ ██ ████   ██     ██       ██   ██ ████  ████ ██          ██      ██    ██ ██    ██ ██   ██ 
██ ████ ██ ███████ ██ ██ ██  ██     ██   ███ ███████ ██ ████ ██ █████       ██      ██    ██ ██    ██ ██████  
██  ██  ██ ██   ██ ██ ██  ██ ██     ██    ██ ██   ██ ██  ██  ██ ██          ██      ██    ██ ██    ██ ██      
██      ██ ██   ██ ██ ██   ████      ██████  ██   ██ ██      ██ ███████     ███████  ██████   ██████  ██      
*/

void function Extraction_GameplayStart()
{
	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.SurviveStart )
	
	thread Extraction_MainGameLoop_Thread()
}

void function Extraction_MainGameLoop_Thread()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	while( true )
	{
		SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_BREAK )
		SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_BREAK )
		SetGlobalNetInt( "currentMainObjective", 0 )

		wait OBJECTIVE_TIME_BREAK

		int chosenObjective = file.availableObjectives.getrandom()

		while ( chosenObjective == file.previousObjective ) //Prevention of consecutive same objective
			chosenObjective = file.availableObjectives.getrandom()

		if ( file.amountOfObjectivesDone == file.amountOfObjectivesForExtraction )
			chosenObjective = eEXTObjectives.FinalExtraction

		foreach ( player in GetPlayerArray() )
		{
			if ( chosenObjective == eEXTObjectives.FinalExtraction )
				Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_StartDropshipExtraction" )
			else
				Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_NewObjective" )
		}

		wait OBJECTIVE_TIME_INTERVAL_BETWEEN

		foreach ( player in GetPlayerArray() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.ScoreBars )
		
		SetGlobalNetInt( "currentMainObjective", chosenObjective )
		SetGlobalNetInt( "objectiveCounter", 0 )

		file.previousObjective = chosenObjective

		switch ( chosenObjective )
		{
			case eEXTObjectives.DestroyHarvester:
				waitthread ExtractionObjective_DestroyHarvester()
				break
			
			case eEXTObjectives.GatherBatteries:
				waitthread ExtractionObjective_GatherBatteries()
				break
			
			case eEXTObjectives.DefendPosition:
				waitthread ExtractionObjective_DefendPosition()
				break
			
			case eEXTObjectives.ActivateTerminals:
				waitthread ExtractionObjective_ActivateTerminals()
				break
			
			case eEXTObjectives.DataRecovery:
				waitthread ExtractionObjective_DataRecovery()
				break
			
			case eEXTObjectives.DataDelivery:
				waitthread ExtractionObjective_DataDelivery()
				break
			
			case eEXTObjectives.FinalExtraction:
				thread ExtractionObjective_FinalExtractionSurvival()
				return

			case eEXTObjectives.KillQuota:
				waitthread ExtractionObjective_KillQuota()
				break
			
			case eEXTObjectives.EliminateEliteTitan:
				waitthread ExtractionObjective_EliminateEliteTitan()
				break
		}

		thread RollHazardChanceIncrease_Thread()
		IncrementPlayerObjectivesCompleted()
		file.amountOfObjectivesDone++
	}
}

void function ExtractionObjective_DestroyHarvester()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_HARVESTER_DESTRUCTION )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_HARVESTER_DESTRUCTION )
	SetObjectiveMaxCounter( 1 )
	thread TimeExpire_Monitor()

	entity harvester = Extraction_SpawnHarvester()
	SendEnemiesToSpecialAssaultPosition( harvester.GetOrigin() )

	while ( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()
	
	ClearEnemiesFromSpecialAssaultPosition()
	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_GatherBatteries()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_BATTERY_GATHER )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_BATTERY_GATHER )
	SetObjectiveMaxCounter( RandomIntRange( 2, 4 ) * maxint( 1, GetGlobalNetInt( "hazardLevel" ) - 1 ) )
	thread TimeExpire_Monitor()

	entity chosenBatteryPlatform = file.batteryPlatforms.getrandom()
	file.choseBatteryPlatform = chosenBatteryPlatform
	file.batteryPlatforms.removebyvalue( chosenBatteryPlatform ) // Take away from main array so it never spawns batteries on same spot of port

	entity batterySlot = CreatePropScript( $"models/props/battery_port/battery_port_animated.mdl", chosenBatteryPlatform.GetOrigin() + < 0, 0, 12 >, < 0, 0, 0 >, 6 )
	SetTargetName( batterySlot, "batteryPort" )
	batterySlot.DisableHibernation()
	batterySlot.EnableRenderAlways()

	SetupExtractionBatteryPort( batterySlot )
	SpawnExtractionBatteryItem( file.batteryPlatforms.getrandom() )

	while ( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()

	file.batteryPlatforms.append( chosenBatteryPlatform ) // Readd for later randomization if objective is picked again
	if ( IsValid( file.spawnedBattery ) ) // Remove leftover battery if players completed the objective by stealing from titans or using the boost
		file.spawnedBattery.Destroy()

	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_DefendPosition()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	SetObjectiveMaxCounter( OBJECTIVE_AMT_HACKSTATION_BASE * GetGlobalNetInt( "hazardLevel" ) )

	entity chosenStation = file.hackStations.getrandom()

	entity stationRuiTracker = CreateEntity( "info_target" )
	stationRuiTracker.SetOrigin( chosenStation.GetOrigin() )
	stationRuiTracker.kv.spawnFlags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	DispatchSpawn( stationRuiTracker )
	SetTargetName( stationRuiTracker, "defensePosition" )
	stationRuiTracker.DisableHibernation()
	stationRuiTracker.SetParent( chosenStation, "ICON" )

	SendEnemiesToSpecialAssaultPosition( chosenStation.GetOrigin() )

	wait 10
	thread SpawnAlliedHackerTeam( chosenStation )
	while ( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()
	
	stationRuiTracker.Destroy()
	ClearEnemiesFromSpecialAssaultPosition()
	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_ActivateTerminals()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_TERMINAL_ACTIVATION )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_TERMINAL_ACTIVATION )
	SetObjectiveMaxCounter( file.terminalPanels.len() )
	thread TimeExpire_Monitor()

	foreach ( terminal in file.terminalPanels )
	{
		entity panelRuiTracker = CreateEntity( "info_target" )
		panelRuiTracker.SetOrigin( terminal.GetOrigin() + < 0, 0, 8 > )
		panelRuiTracker.kv.spawnFlags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
		DispatchSpawn( panelRuiTracker )
		SetTargetName( panelRuiTracker, "interactTerminal" )
		panelRuiTracker.DisableHibernation()
		
		thread TrackSwitchPanelInteraction_Threaded( terminal, panelRuiTracker )
	}

	while ( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()
	
	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_DataRecovery()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_DATA_RECOVERY )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_DATA_RECOVERY )
	SetObjectiveMaxCounter( RandomIntRange( 3, 5 ) * GetGlobalNetInt( "hazardLevel" ) )
	thread TimeExpire_Monitor()

	while ( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()
	
	if ( file.availableObjectives.find( eEXTObjectives.DataDelivery ) == -1 && file.robotBanks.len() ) //Tells the objective handler function that players can deliver the data
		file.availableObjectives.append( eEXTObjectives.DataDelivery )
	
	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_DataDelivery()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	int totalIntelToDeliver = 0
	foreach ( player in GetPlayerArray() )
		totalIntelToDeliver += player.GetPlayerNetInt( "tabletInventoryCount" )
	
	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_DATA_DELIVERY )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_DATA_DELIVERY )
	SetObjectiveMaxCounter( totalIntelToDeliver )
	thread TimeExpire_Monitor()

	entity deliveryBank = file.robotBanks.getrandom()
	deliveryBank.Signal( "BankPickedForDataDelivery" )
	deliveryBank.SetUsable()
	deliveryBank.SetUsableByGroup( "pilot" )
	thread MonitorDeliveryRobotInteraction_Threaded( deliveryBank )
	thread EnableRobotBank( deliveryBank, TEAM_IMC )

	entity panelRuiTracker = CreateEntity( "info_target" )
	panelRuiTracker.SetOrigin( deliveryBank.GetOrigin() + < 0, 0, 32 > )
	panelRuiTracker.kv.spawnFlags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	DispatchSpawn( panelRuiTracker )
	SetTargetName( panelRuiTracker, "intelDeliver" )
	panelRuiTracker.DisableHibernation()

	SendEnemiesToSpecialAssaultPosition( deliveryBank.GetOrigin() )

	bool warnIntel
	while ( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
	{
		if ( Time() + 20 > expect float( level.nv.gameEndTime ) && !warnIntel )
		{
			foreach ( player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
			{
				if ( player.GetPlayerNetInt( "tabletInventoryCount" ) > 0 )
					SendHudMessage( player, "#EXT_DELIVER_INTEL", -1, 0.4, 255, 255, 64, 255, 0.15, 3.0, 0.5 )
			}
			warnIntel = true
		}
		WaitFrame()
	}
	
	thread DisableRobotBank( deliveryBank )
	panelRuiTracker.Destroy()

	ClearEnemiesFromSpecialAssaultPosition()

	if ( file.availableObjectives.find( eEXTObjectives.DataDelivery ) != -1 )
		file.availableObjectives.removebyvalue( eEXTObjectives.DataDelivery )
	
	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_FinalExtractionSurvival()
{
	SetGlobalNetInt( "hazardLevel", 6 )
	file.maxEnemyReapers = 6
	file.maxEnemyTitans = 5
	file.respawnTerminal.UnsetUsable()
	entity spaceNode
	if ( GetMapName() == "mp_angel_city" ) // Cringe 1 a new beginning
		spaceNode = CreateScriptRef( < -1700, -5500, -7600 >, < -3.620642, 270.307129, 0 > )
	else if ( GetMapName() == "mp_colony02" ) // Cringe 2 the return
		spaceNode = GetEnt( "intro_spacenode" )
	else if ( GetMapName() == "mp_wargames" ) // Cringe 3 ultimate sacrilege
		spaceNode = GetEnt( "end_spacenode" )
	else
		spaceNode = GetEnt( "spaceNode" )

	SetServerVar( "gameEndTime", Time() + max( 0.1, file.extractionDropshipTime ) )
	SetServerVar( "roundEndTime", Time() + max( 0.1, file.extractionDropshipTime ) )

	file.timeToExtract = Time() + max( 0.1, file.extractionDropshipTime )
	foreach ( player in GetPlayerArray() )
		player.SetObjectiveEndTime( file.timeToExtract )

	entity chosenEvacNode = file.extractionNodes.getrandom()
	vector adjustedEnemyPos = OriginToGround( chosenEvacNode.GetOrigin() )
	SendEnemiesToSpecialAssaultPosition( adjustedEnemyPos )
	ExtractionDropshipIncoming( chosenEvacNode, spaceNode )
}

void function ExtractionObjective_KillQuota()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_KILL_QUOTA )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_KILL_QUOTA )
	SetObjectiveMaxCounter( RandomIntRange( 10, 20 ) * GetGlobalNetInt( "hazardLevel" ) )
	thread TimeExpire_Monitor()

	while( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()
	
	AnnounceObjectiveCompleteForPlayers()
}

void function ExtractionObjective_EliminateEliteTitan()
{
	svGlobal.levelEnt.EndSignal( "GameEnd" )

	int amtOfPlayers = GetPlayerArrayOfTeam( TEAM_MILITIA ).len()
	int eliteTitansToKill = maxint( 1, amtOfPlayers / 4 )

	SetServerVar( "gameEndTime", Time() + OBJECTIVE_TIME_KILL_ELITE_TITANS )
	SetServerVar( "roundEndTime", Time() + OBJECTIVE_TIME_KILL_ELITE_TITANS )
	SetObjectiveMaxCounter( eliteTitansToKill )
	thread TimeExpire_Monitor()

	for ( int i = eliteTitansToKill; i > 0; i-- )
	{
		thread EXT_SpawnEliteTitan()
		wait 1.5
	}

	while( GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
		WaitFrame()
	
	AnnounceObjectiveCompleteForPlayers()
}

void function TimeExpire_Monitor()
{
	svGlobal.levelEnt.EndSignal( "ObjectiveCompleted" )

	while ( Time() < expect float( level.nv.gameEndTime ) )
		WaitFrame()
	
	SetWinner( TEAM_IMC, "#EXT_DEFEAT_MESSAGE_OBJECTIVE", "#EXT_DEFEAT_MESSAGE_OBJECTIVE" )
}

void function IncrementPlayerObjectivesCompleted()
{
	foreach ( player in GetPlayerArray() )
	{
		if ( player in file.matchPlayers )
		{
			file.matchPlayers[player].objectivesCompleted++
			if ( file.matchPlayers[player].objectivesCompleted == 3 )
			{
				AddPlayerScore( player, "ChallengeTTDM" )
				SetPlayerChallengeMeritScore( player )
			}
		}
	}
}

void function RollHazardChanceIncrease_Thread()
{
	wait HAZARD_TIME_DELAY
	int currentHazard = GetGlobalNetInt( "hazardLevel" )
	bool shouldIncreaseHazard

	if ( currentHazard < MAX_HAZARD_LEVEL )
	{
		if ( RandomFloatRange( 1, 100 ) <= file.chanceOfIncreasingHazard )
			shouldIncreaseHazard = true
		
		if ( !shouldIncreaseHazard )
		{
			int remainingObjectives = file.amountOfObjectivesForExtraction - file.amountOfObjectivesDone
			switch ( remainingObjectives )
			{
				case 4:
					if ( currentHazard == 1 )
						shouldIncreaseHazard = true
					break
				case 3:
					if ( currentHazard <= 2 )
						shouldIncreaseHazard = true
					break
				case 2:
					if ( currentHazard <= 3 )
						shouldIncreaseHazard = true
					break
				case 1:
					if ( currentHazard <= 4 )
						shouldIncreaseHazard = true
					break
			}
		}


		if ( shouldIncreaseHazard )
		{
			currentHazard++
			SetGlobalNetInt( "hazardLevel", currentHazard )
			
			switch ( currentHazard )
			{
				case 2:
					file.maxEnemyReapers = 1
					file.maxEnemyGrunts = 26
					file.maxEnemySpectres = 6
					break
				
				case 3:
					file.maxEnemyReapers = 2
					file.maxEnemyTitans = 1
					file.maxEnemyGrunts = 18
					file.maxEnemyStalkers = 6
					file.availableObjectives.append( eEXTObjectives.EliminateEliteTitan )
					break
				
				case 4:
					file.maxEnemyReapers = 3
					file.maxEnemyTitans = 2
					break
				
				case 5:
					file.maxEnemyReapers = 4
					file.maxEnemyTitans = 3
					break
			}
			foreach ( player in GetPlayerArray() )
				Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_AnnounceHazardIncrease", currentHazard )
			
			wait 5
			
			foreach ( player in GetPlayerArray() )
				Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.HazardScaling )
		}
	}
}










/*
██████  ██       █████  ██    ██ ███████ ██████      ██       ██████   ██████  ██  ██████ 
██   ██ ██      ██   ██  ██  ██  ██      ██   ██     ██      ██    ██ ██       ██ ██      
██████  ██      ███████   ████   █████   ██████      ██      ██    ██ ██   ███ ██ ██      
██      ██      ██   ██    ██    ██      ██   ██     ██      ██    ██ ██    ██ ██ ██      
██      ███████ ██   ██    ██    ███████ ██   ██     ███████  ██████   ██████  ██  ██████ 
*/

void function GamemodeEXT_InitPlayer( entity player )
{
	ExtractionPlayer playerData
	file.matchPlayers[player] <- playerData

	if ( GamePlaying() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_SyncSettings" )
	
	if ( GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.FinalExtraction )
		player.SetObjectiveEndTime( file.timeToExtract )
}

void function GamemodeEXT_PlayerDisconnected( entity player )
{
	if ( player in file.matchPlayers[player] )
		delete file.matchPlayers[player]
	
	int inventory = player.GetPlayerNetInt( "tabletInventoryCount" )
	while ( inventory > 0 )
	{
		Extraction_DropIntelTablet( player )
		inventory--
	}
}

void function EXT_PlayerRevivesAlly( entity player )
{
	if ( IsAlive( player ) )
	{
		AddPlayerScore( player, "FDHealingBonus" )
		player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, SCORE_OBJECTIVE_REVIVED_ALLY )
	}
}

void function GamemodeEXT_OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !GamePlaying() || !IsValidPlayer( victim ) )
		return
	
	victim.s.currentKillstreak = 0
	victim.s.lastKillTime = 0.0
	victim.s.currentTimedKillstreak = 0

	foreach( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.PlayerDied )
	
	victim.SetPlayerNetBool( "playerGotJumpkit", false )
	victim.SetPlayerNetBool( "playerGotTactical", false )

	int inventory = victim.GetPlayerNetInt( "tabletInventoryCount" )
	while ( inventory > 0 )
	{
		Extraction_DropIntelTablet( victim )
		inventory--
	}

	victim.SetPlayerNetInt( "tabletInventoryCount", 0 )
}

void function MitigateComboDamage( entity ent, var damageInfo )
{
	if ( ent.GetTeam() != TEAM_MILITIA )
		return

	int damageSourceID = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	float damage = DamageInfo_GetDamage( damageInfo )
	float recentDamage = TotalDamageOverTime_BlendedOut( ent, 0.5, 1.5 )
	float damageMod = GraphCapped( recentDamage, 50, 350, 1.0, 0.1 )

	if ( damageSourceID == eDamageSourceId.damagedef_frag_drone_throwable_NPC && ent.IsPlayer() && !ent.IsTitan() )
		damageMod = 0.2

	if ( IsAlive( attacker ) && attacker.IsNPC() && attacker.IsTitan() && !GetDoomedState( attacker ) && attacker.ai.bossTitanType == TITAN_MERC )
	{
		if ( damageSourceID == eDamageSourceId.auto_titan_melee || DamageInfo_GetCustomDamageType( damageInfo ) & DF_MELEE )
		{
			DamageInfo_ScaleDamage( damageInfo, 2.5 )
			DamageInfo_SetDamageSourceIdentifier( damageInfo, eDamageSourceId.melee_titan_punch ) //Restore obituary messages for Elites because they are piloted by grunts and [Auto-Titan Melee] doesn't make sense due to that
			
			if ( GetTitanCharacterName( attacker ) == "ronin" )
			{
				if ( TitanCoreInUse( attacker ) )
					DamageInfo_SetDamageSourceIdentifier( damageInfo, eDamageSourceId.mp_titancore_shift_core )
				else
					DamageInfo_SetDamageSourceIdentifier( damageInfo, eDamageSourceId.melee_titan_sword )
			}
			
			if ( GetTitanCharacterName( attacker ) == "legion" && ent.IsTitan() ) //Elite Legions have Bison melee, but lack feedback about that, so this should tell players their melee hurts alot
			{
				vector endOrigin = ent.GetOrigin()
				endOrigin.z += 128
				vector startOrigin = attacker.GetOrigin()
				startOrigin.z += 128
				vector refVec = endOrigin - startOrigin
				vector refPos = endOrigin - refVec * 0.5
				
				PlayFX( $"P_impact_exp_XLG_metal", refPos )
				EmitSoundAtPosition( attacker.GetTeam(), refPos, "Explo_Satchel_Impact_3P" )
				EmitSoundAtPosition( attacker.GetTeam(), refPos, "Explo_FragGrenade_Impact_3P" )
				EmitSoundAtPosition( attacker.GetTeam(), refPos, "explo_40mm_splashed_impact_3p" )
				DamageInfo_SetDamageSourceIdentifier( damageInfo, eDamageSourceId.berserker_melee )
			}
		}
	}
	else
		DamageInfo_ScaleDamage( damageInfo, damageMod )
}











/*
 ██████  █████  ██      ██      ██████   █████   ██████ ██   ██ ███████ 
██      ██   ██ ██      ██      ██   ██ ██   ██ ██      ██  ██  ██      
██      ███████ ██      ██      ██████  ███████ ██      █████   ███████ 
██      ██   ██ ██      ██      ██   ██ ██   ██ ██      ██  ██       ██ 
 ██████ ██   ██ ███████ ███████ ██████  ██   ██  ██████ ██   ██ ███████ 
 */

void function SetupExtractionMap( void functionref() callback )
{
	file.extractionCallbacks.append( callback )
}

void function Extraction_AddDefaultEnemyAssaultPoint( vector origin )
{
	file.enemiesDefaultAssaultPositions.append( origin )
}

void function Extraction_AddExtractionPoint( vector origin, vector angles )
{
	entity node = CreateScriptRef( origin, angles )
	file.extractionNodes.append( node )
}

void function Extraction_PlaceRespawnTerminal( vector origin, vector angles )
{
	entity panel = CreateEntity( "prop_control_panel" )
	panel.SetValueForModelKey( $"models/communication/terminal_usable_imc_01.mdl" )
	panel.SetOrigin( origin )
	panel.SetAngles( angles )
	panel.kv.solid = SOLID_VPHYSICS
	SetTeam( panel, TEAM_MILITIA )
	DispatchSpawn( panel )
	
	Highlight_SetFriendlyHighlight( panel, "sp_friendly_hero" )
	panel.Highlight_SetParam( 1, 0, < 0.0, 0.0, 0.0 > )
	panel.EnableRenderAlways()

	SetTargetName( panel, "respawnTerminal" )
	panel.SetModel( $"models/communication/terminal_usable_imc_01.mdl" )
	panel.s.scriptedPanel <- true
	panel.useFunction = ExtractionRespawnPanelCanUse
	panel.s.timeUsed <- Time()
	file.respawnTerminal = panel

	SetControlPanelUseFunc( panel, RespawnTerminalHacked )
	panel.SetUsePrompts( "#EXT_RSPWN_TERMINAL_PRESS_HOLD", "#EXT_RSPWN_TERMINAL_PRESS_USE" )
}

void function Extraction_PlaceTitanTerminal( vector origin, vector angles )
{
	entity panel = CreateEntity( "prop_control_panel" )
	panel.SetValueForModelKey( $"models/communication/terminal_usable_imc_01.mdl" )
	panel.SetOrigin( origin )
	panel.SetAngles( angles )
	panel.kv.solid = SOLID_VPHYSICS
	SetTeam( panel, TEAM_MILITIA )
	DispatchSpawn( panel )
	
	Highlight_SetFriendlyHighlight( panel, "sp_friendly_hero" )
	panel.Highlight_SetParam( 1, 0, < 0.0, 0.0, 0.0 > )
	panel.EnableRenderAlways()

	SetTargetName( panel, "titanTerminal" )
	panel.SetModel( $"models/communication/terminal_usable_imc_01.mdl" )
	panel.SetSkin( 1 )
	panel.s.scriptedPanel <- true
	panel.useFunction = ExtractionTitanPanelCanUse
	panel.s.timeUsed <- Time()
	file.titanTerminal = panel

	SetControlPanelUseFunc( panel, TitanTerminalHacked )
	panel.SetUsePrompts( "#EXT_TITAN_TERMINAL_PRESS_HOLD", "#EXT_TITAN_TERMINAL_PRESS_USE" )
}

void function AddExtractionCustomMapProp( asset modelasset, vector origin, vector angles )
{
	entity prop = CreateEntity( "prop_script" )
	prop.SetValueForModelKey( modelasset )
	prop.SetOrigin( origin )
	prop.SetAngles( angles )
	prop.kv.fadedist = -1
	prop.kv.renderamt = 255
	prop.kv.rendercolor = "255 255 255"
	prop.kv.solid = 6
	ToggleNPCPathsForEntity( prop, false )
	prop.SetAIObstacle( true )
	prop.SetTakeDamageType( DAMAGE_NO )
	prop.SetScriptPropFlags( SPF_BLOCKS_AI_NAVIGATION | SPF_CUSTOM_SCRIPT_3 )
	prop.AllowMantle()
	DispatchSpawn( prop )
}









/*
███████ ██████   █████  ██     ██ ███    ██     ██       ██████   ██████  ██  ██████ 
██      ██   ██ ██   ██ ██     ██ ████   ██     ██      ██    ██ ██       ██ ██      
███████ ██████  ███████ ██  █  ██ ██ ██  ██     ██      ██    ██ ██   ███ ██ ██      
     ██ ██      ██   ██ ██ ███ ██ ██  ██ ██     ██      ██    ██ ██    ██ ██ ██      
███████ ██      ██   ██  ███ ███  ██   ████     ███████  ██████   ██████  ██  ██████ 
*/

void function RespawnPlayersInDropPod()
{
	while ( GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ).len() < GetPlayerArrayOfTeam( TEAM_MILITIA ).len() )
	{
		array< entity > podNodes = SpawnPoints_GetDropPod()
		entity chosenNode = podNodes.getrandom()
		vector PodOrigin = chosenNode.GetOrigin()
		array< entity > playersInPod
		entity pod = CreateDropPod( PodOrigin, < 0, 0, 0 > )
		SetTeam( pod, TEAM_MILITIA )
		InitFireteamDropPod( pod )

		int playerPodCount
		foreach ( player in GetPlayerArray() )
		{
			if ( playerPodCount > 3 || IsAlive( player ) )
				continue

			DoRespawnPlayer( player, null )
			player.SetOrigin( PodOrigin )
			player.SetAngles( < 0, 0, 0 > )
			player.SetParent( pod, "ATTACH", true )
			player.SetTouchTriggers( false )
			player.SetInvulnerable()
			player.SetPlayerNetBool( "playerGotJumpkit", false )
			player.SetPlayerNetBool( "playerGotTactical", false )
			player.SetTitle( "" )
			ScreenFadeFromBlack( player, 1, 1 )
			HolsterAndDisableWeapons( player )
			AddCinematicFlag( player, CE_FLAG_CLASSIC_MP_SPAWNING )
			playersInPod.append( player )
			playerPodCount++
		}

		thread ExtractionLaunchPlayerDropPod( pod, playersInPod )
	}
}

void function ExtractionLaunchPlayerDropPod( entity pod, array< entity > playersInPod )
{
	int playerIndexSlot
	foreach ( player in playersInPod )
	{
		FirstPersonSequenceStruct podSequence
		podSequence.firstPersonAnim = DROPPOD_IDLE_ANIMS_POV[playerIndexSlot]
		podSequence.thirdPersonAnim = DROPPOD_IDLE_ANIMS[playerIndexSlot]
		podSequence.attachment = "ATTACH"
		podSequence.blendTime = 0.0
		podSequence.hideProxy = false
		podSequence.viewConeFunction = ViewConeRampFree
		
		if ( IsValidPlayer( player ) )
			thread FirstPersonSequence( podSequence, player, pod )
		
		playerIndexSlot++
	}

	waitthread LaunchAnimDropPod( pod, "pod_testpath", pod.GetOrigin(), < 0, RandomIntRange( 0, 359 ), 0 > )
	thread DropPodActiveThink( pod )
	pod.NotSolid()
	
	playerIndexSlot = 0
	foreach ( player in playersInPod )
	{
		if ( IsValidPlayer( player ) )
			thread ReleasePlayerFromDropPod( player, playerIndexSlot, pod )
		
		playerIndexSlot++
	}
}

void function ReleasePlayerFromDropPod( entity player, int playerIndexSlot, entity pod )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	FirstPersonSequenceStruct podSequence
	podSequence.firstPersonAnim = DROPPOD_EXIT_ANIMS_POV[playerIndexSlot]
	podSequence.thirdPersonAnim = DROPPOD_EXIT_ANIMS[playerIndexSlot]
	podSequence.attachment = "ATTACH"
	podSequence.blendTime = 0.0
	podSequence.hideProxy = false
	podSequence.enablePlanting = true
	podSequence.viewConeFunction = ViewConeRampFree
	
	waitthread FirstPersonSequence( podSequence, player, pod )
	
	player.ClearParent()
	player.EnableWeaponViewModel()
	player.ClearInvulnerable()
	player.SetTouchTriggers( true )
	RemoveCinematicFlag( player, CE_FLAG_CLASSIC_MP_SPAWNING )
	PutEntityInSafeSpot( player, null, null, pod.GetOrigin(), player.GetOrigin() )
	ClearPlayerAnimViewEntity( player )
	Loadouts_OnUsedLoadoutCrate( player )
	EnableOffhandWeapons( player )
	Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_PlayerRespawnRefreshIcons" )
}

void function EXT_SpawnGrunt( vector pos )
{
	entity guy = CreateSoldier( TEAM_IMC, pos, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
	array< string > gunsArrayBase = ["mp_weapon_wingman", "mp_weapon_semipistol", "mp_weapon_autopistol", "mp_weapon_rspn101_og", "mp_weapon_rspn101" "mp_weapon_hemlok"]
	array< string > gunsArrayTier2 = ["mp_weapon_vinson", "mp_weapon_shotgun_pistol", "mp_weapon_shotgun_doublebarrel", "mp_weapon_r97", "mp_weapon_esaw"]
	array< string > gunsArrayTier3 = ["mp_weapon_lmg", "mp_weapon_lstar", "mp_weapon_mastiff", "mp_weapon_shotgun", "mp_weapon_smr", "mp_weapon_epg"]

	array< string > grenadesBase = ["mp_weapon_grenade_emp", "mp_weapon_grenade_electric_smoke"]
	array< string > grenadesTier2 = ["mp_weapon_frag_grenade", "mp_weapon_thermite_grenade"]
	
	guy.kv.grenadeWeaponName = grenadesBase.getrandom()
	if ( GetGlobalNetInt( "hazardLevel" ) >= 2 )
	{
		gunsArrayBase.extend( gunsArrayTier2 )
		grenadesBase.extend( grenadesTier2 )
	}
	if ( GetGlobalNetInt( "hazardLevel" ) >= 3 )
	{
		gunsArrayBase.extend( gunsArrayTier3 )
		if ( RandomIntRange( 1, 100 ) >= 60 )
		{
			if ( RandomIntRange( 1, 100 ) >= 50 )
				SetSpawnOption_AISettings( guy, "npc_soldier_shield_captain" )
			else
				SetSpawnOption_AISettings( guy, "npc_soldier_pve_specialist" )
		}
	}

	SetSpawnOption_Weapon( guy, gunsArrayBase.getrandom() )
	DispatchSpawn( guy )

	guy.EnableNPCFlag( NPC_NO_WEAPON_DROP | NPC_TEAM_SPOTTED_ENEMY | NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_IGNORE_FRIENDLY_SOUND | NPC_NEW_ENEMY_FROM_SOUND )
	guy.DisableNPCFlag( NPC_ALLOW_FLEE )
	guy.DisableRenderAlways()

	if ( GetGlobalNetInt( "hazardLevel" ) >= 2 )
		guy.SetBehaviorSelector( "behavior_sp_soldier" )
	if ( GetGlobalNetInt( "hazardLevel" ) >= 3 )
	{
		guy.DisableNPCFlag( NPC_USE_SHOOTING_COVER )
		guy.DisableNPCMoveFlag( NPCMF_WALK_NONCOMBAT | NPCMF_WALK_ALWAYS )
		guy.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
	}

	if ( guy.GetAISettingsName() == "npc_soldier_shield_captain" )
		guy.SetModel( MODEL_IMC_SHIELD_CAPTAIN )
	
	foreach ( entity weapon in guy.GetMainWeapons() )
	{
		if ( weapon.GetWeaponClassName() == "mp_weapon_rocket_launcher" )
			guy.TakeWeapon( weapon.GetWeaponClassName() )
	}

	if ( GetGlobalNetInt( "hazardLevel" ) >= 5 )
		guy.GiveWeapon( "mp_weapon_defender", [] )
	
	guy.AssaultSetGoalRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetGoalHeight( 128 )
	guy.AssaultSetFightRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.kv.AccuracyMultiplier = 2.0

	if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > )
		guy.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
	else if ( file.enemiesDefaultAssaultPositions.len() )
		guy.AssaultPointClamped( file.enemiesDefaultAssaultPositions.getrandom() )
}

void function EXT_SpawnSpectre( vector pos )
{
	entity guy = CreateSpectre( TEAM_IMC, pos, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
	array< string > gunsArrayBase = ["mp_weapon_doubletake", "mp_weapon_dmr", "mp_weapon_car", "mp_weapon_lstar", "mp_weapon_g2"]
	
	SetSpawnOption_Weapon( guy, gunsArrayBase.getrandom() )
	DispatchSpawn( guy )

	guy.SetBehaviorSelector( "behavior_sp_soldier" )
	guy.DisableRenderAlways()
	if ( GetGlobalNetInt( "hazardLevel" ) >= 5 )
		guy.GiveWeapon( "mp_weapon_rocket_launcher", ["at_unlimited_ammo"] )
	
	guy.EnableNPCFlag( NPC_NO_WEAPON_DROP | NPC_TEAM_SPOTTED_ENEMY | NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_IGNORE_FRIENDLY_SOUND | NPC_NEW_ENEMY_FROM_SOUND | NPC_AIM_DIRECT_AT_ENEMY )
	guy.DisableNPCFlag( NPC_ALLOW_FLEE )
	guy.DisableNPCMoveFlag( NPCMF_WALK_NONCOMBAT | NPCMF_WALK_ALWAYS )
	guy.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
	guy.AssaultSetGoalRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetGoalHeight( 256 )
	guy.AssaultSetFightRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )

	if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > )
		guy.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
	else if ( file.enemiesDefaultAssaultPositions.len() )
		guy.AssaultPointClamped( file.enemiesDefaultAssaultPositions.getrandom() )
}

void function EXT_SpawnStalker( vector pos )
{
	entity guy = CreateStalker( TEAM_IMC, pos, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
	array< string > gunsArrayBase = ["mp_weapon_smr", "mp_weapon_mastiff", "mp_weapon_shotgun_pistol", "mp_weapon_shotgun", "mp_weapon_epg","mp_weapon_arc_launcher"]
	
	SetSpawnOption_AISettings( guy, "npc_stalker_fd" )
	SetSpawnOption_Weapon( guy, gunsArrayBase.getrandom() )
	DispatchSpawn( guy )

	foreach ( entity weapon in guy.GetMainWeapons() )
		if ( weapon.GetWeaponClassName() == "mp_weapon_arc_launcher" )
			weapon.AddMod( "at_unlimited_ammo" )
	
	guy.DisableRenderAlways()
	guy.EnableNPCFlag( NPC_NO_WEAPON_DROP | NPC_TEAM_SPOTTED_ENEMY | NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND | NPC_AIM_DIRECT_AT_ENEMY )
	guy.AssaultSetGoalRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetGoalHeight( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetFightRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )

	if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > )
		guy.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
	else if ( file.enemiesDefaultAssaultPositions.len() )
		guy.AssaultPointClamped( file.enemiesDefaultAssaultPositions.getrandom() )
}

void function EXT_SpawnReaper( vector pos )
{
	entity guy = CreateSuperSpectre( TEAM_IMC, pos, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
	SetSpawnOption_AISettings( guy, "npc_super_spectre_burnmeter" )
	SetSpawnOption_Alert( guy )
	DispatchSpawn( guy )

	thread SuperSpectre_WarpFall( guy )
	guy.EndSignal( "OnDeath" )
	guy.EndSignal( "OnDestroy" )
	guy.WaitSignal( "WarpfallComplete" )

	guy.DisableRenderAlways()
	guy.SetAllowSpecialJump( true )
	guy.EnableNPCFlag( NPC_ALLOW_PATROL | NPC_TEAM_SPOTTED_ENEMY | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND | NPC_AIM_DIRECT_AT_ENEMY )
	guy.DisableNPCMoveFlag( NPCMF_WALK_NONCOMBAT | NPCMF_WALK_ALWAYS )
	guy.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
	guy.AssaultSetGoalRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetGoalHeight( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetFightRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetArrivalTolerance( TITAN_ASSAULT_ENGAGEMENT_RADIUS / 2 )

	if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > )
		guy.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
	else if ( file.enemiesDefaultAssaultPositions.len() )
		guy.AssaultPointClamped( file.enemiesDefaultAssaultPositions.getrandom() )

	if( GetGlobalNetInt( "hazardLevel" ) >= 4 )
		guy.ai.superSpectreEnableFragDrones = true
}

void function EXT_SpawnTitan( vector pos )
{
	array< string > titanChassis = ["titan_stryder","titan_atlas","titan_ogre"]
	string chosenTitanChassis = titanChassis.getrandom()

	entity guy = CreateNPCTitan( chosenTitanChassis, TEAM_IMC, pos, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
	SetSpawnOption_Titanfall( guy )

	array< string > stryderTypes = ["npc_titan_stryder_leadwall","npc_titan_stryder_rocketeer","npc_titan_stryder_sniper"]
	array< string > atlasTypes = ["npc_titan_atlas_stickybomb","npc_titan_atlas_tracker","npc_titan_atlas_vanguard"]
	array< string > ogreTypes = ["npc_titan_ogre_meteor","npc_titan_ogre_minigun"]

	switch( chosenTitanChassis )
	{
		case "titan_stryder":
			SetSpawnOption_AISettings( guy, stryderTypes.getrandom() )
			break
		case "titan_atlas":
			SetSpawnOption_AISettings( guy, atlasTypes.getrandom() )
			break
		case "titan_ogre":
			SetSpawnOption_AISettings( guy, ogreTypes.getrandom() )
			break
	}

	DispatchSpawn( guy )
	guy.EnableNPCFlag( NPC_ALLOW_PATROL | NPC_TEAM_SPOTTED_ENEMY | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND | NPC_AIM_DIRECT_AT_ENEMY )
	guy.DisableNPCMoveFlag( NPCMF_WALK_NONCOMBAT | NPCMF_DISABLE_DANGEROUS_AREA_DISPLACEMENT | NPCMF_WALK_ALWAYS )
	guy.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
	guy.AssaultSetGoalRadius( TITAN_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetGoalHeight( TITAN_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetFightRadius( TITAN_ASSAULT_ENGAGEMENT_RADIUS )
	guy.AssaultSetArrivalTolerance( TITAN_ASSAULT_ENGAGEMENT_RADIUS / 2 )

	if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > )
	{
		vector ornull clampedVec = NavMesh_ClampPointForAI( file.enemiesAssaultSpecialPosition, guy )
		if( !clampedVec )
			guy.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
		else
			guy.AssaultPointClamped( expect vector( clampedVec ) )
	}
	else if ( file.enemiesDefaultAssaultPositions.len() )
	{
		vector chosenVector = file.enemiesDefaultAssaultPositions.getrandom()
		vector ornull clampedVec = NavMesh_ClampPointForAI( chosenVector, guy )
		if( !clampedVec )
			guy.AssaultPointClamped( chosenVector )
		else
			guy.AssaultPointClamped( expect vector( clampedVec ) )
	}
}

void function OnTickSpawn( entity tick )
{
	thread FragDroneSpawn_Thread( tick )
}

void function FragDroneSpawn_Thread( entity tick )
{
	WaitFrame()
	entity tickOwner = tick.GetBossPlayer()
	if ( IsValidPlayer( tickOwner ) && IsAlive( tick ) )
	{
		tick.SetAISettings( "npc_frag_drone_fd" )
		tick.AssaultSetGoalRadius( 400 )
		tick.AssaultSetGoalHeight( 64 )
		tick.AssaultSetFightRadius( 800 )
		NPCFollowsPlayer( tick, tickOwner )
	}
}

void function OnDroneSpawn( entity drone )
{
	drone.SetAISettings( "npc_drone_plasma_fast" )
	drone.EnableNPCFlag( NPC_ALLOW_PATROL | NPC_TEAM_SPOTTED_ENEMY | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND | NPC_AIM_DIRECT_AT_ENEMY )
	drone.DisableNPCMoveFlag( NPCMF_WALK_NONCOMBAT | NPCMF_WALK_ALWAYS )
	drone.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
	drone.AssaultSetGoalRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )
	drone.AssaultSetGoalHeight( 100 )
	drone.AssaultSetFightRadius( INFANTRY_ASSAULT_ENGAGEMENT_RADIUS )

	if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > )
		drone.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
	else if ( file.enemiesDefaultAssaultPositions.len() )
		drone.AssaultPointClamped( file.enemiesDefaultAssaultPositions.getrandom() )
}

void function TitanScaleByHazard( entity ent )
{
	if ( ent.GetTeam() == TEAM_IMC && GetGlobalNetInt( "hazardLevel" ) >= 5 )
		thread OnNPCTitanSpawn_Thread( ent )
}

void function OnNPCTitanSpawn_Thread( entity npc )
{
	npc.EndSignal( "OnDeath" )
	npc.EndSignal( "OnDestroy" )
	WaitFrame()
	WaitTillHotDropComplete( npc )

	entity soul = npc.GetTitanSoul()
	if ( IsValid( soul ) )
		soul.SetShieldHealth( soul.GetShieldHealthMax() )
}

void function EXT_SpawnEliteTitan()
{
	array<entity> spawnpoints = SpawnPoints_GetTitan()
	entity chosenSpawn = spawnpoints.getrandom()
	vector pos = chosenSpawn.GetOrigin()

	array< string > titanChassis = ["titan_stryder","titan_atlas","titan_ogre"]
	string chosenTitanChassis = titanChassis.getrandom()

	entity guy = CreateNPCTitan( chosenTitanChassis, TEAM_IMC, pos, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
	SetSpawnOption_Titanfall( guy )

	array< string > stryderTypes = ["npc_titan_stryder_leadwall_boss_fd_elite","npc_titan_stryder_sniper_boss_fd_elite"]
	array< string > atlasTypes = ["npc_titan_atlas_stickybomb_boss_fd_elite","npc_titan_atlas_tracker_boss_fd_elite","npc_titan_atlas_vanguard_boss_fd_elite"]
	array< string > ogreTypes = ["npc_titan_ogre_meteor_boss_fd_elite","npc_titan_ogre_minigun_boss_fd_elite"]

	switch( chosenTitanChassis )
	{
		case "titan_stryder":
			SetSpawnOption_AISettings( guy, stryderTypes.getrandom() )
			break
		case "titan_atlas":
			SetSpawnOption_AISettings( guy, atlasTypes.getrandom() )
			break
		case "titan_ogre":
			SetSpawnOption_AISettings( guy, ogreTypes.getrandom() )
			break
	}

	SetTitanAsElite( guy )
	DispatchSpawn( guy )
	guy.AssaultSetGoalRadius( TITAN_ASSAULT_ENGAGEMENT_RADIUS * 2 )
	guy.AssaultSetGoalHeight( TITAN_ASSAULT_ENGAGEMENT_RADIUS * 2 )
	guy.AssaultSetFightRadius( TITAN_ASSAULT_ENGAGEMENT_RADIUS * 2 )
	guy.AssaultSetArrivalTolerance( TITAN_ASSAULT_ENGAGEMENT_RADIUS )
	SetEliteTitanPostSpawn( guy )
	SetTargetName( guy, "eliteTitan" )
	guy.SetMaxHealth( guy.GetMaxHealth() + 7500 )
	guy.SetHealth( guy.GetMaxHealth() )

	guy.EndSignal( "OnDeath" )
	guy.EndSignal( "OnDestroy" )
	WaitTillHotDropComplete( guy )
	
	guy.GetTitanSoul().SetTitanSoulNetBool( "showOverheadIcon", true )

	vector chosenVector = file.enemiesDefaultAssaultPositions.getrandom()
	vector ornull clampedVec = NavMesh_ClampPointForAI( chosenVector, guy )
	if( !clampedVec )
		guy.AssaultPointClamped( chosenVector )
	else
		guy.AssaultPointClamped( expect vector( clampedVec ) )
}










/*
███████ ███    ██ ███████ ███    ███ ██    ██     ███████ ██████   █████  ██     ██ ███    ██ ███████ ██████  
██      ████   ██ ██      ████  ████  ██  ██      ██      ██   ██ ██   ██ ██     ██ ████   ██ ██      ██   ██ 
█████   ██ ██  ██ █████   ██ ████ ██   ████       ███████ ██████  ███████ ██  █  ██ ██ ██  ██ █████   ██████  
██      ██  ██ ██ ██      ██  ██  ██    ██             ██ ██      ██   ██ ██ ███ ██ ██  ██ ██ ██      ██   ██ 
███████ ██   ████ ███████ ██      ██    ██        ███████ ██      ██   ██  ███ ███  ██   ████ ███████ ██   ██ 
*/

void function Infantry_Spawner_Thread()
{
	while ( true )
	{
		FlagWait( "EnemySpawnerActive" )

		int totalGrunts = 0
		int totalSpectres = 0
		int totalStalkers = 0
		array<entity> npcs = GetNPCArrayOfTeam( TEAM_IMC )
		ArrayRemoveDead( npcs )
		foreach ( entity npc in npcs )
		{
			if ( IsGrunt( npc ) )
			{
				totalGrunts++
				continue
			}
			if ( IsSpectre( npc ) )
			{
				totalSpectres++
				continue
			}
			if ( IsStalker( npc ) )
			{
				totalStalkers++
				continue
			}
			npcs.removebyvalue( npc ) // Remove Titans, Dropships, Turrets, Ticks, Drones and Reapers from the equation
		}

		if ( npcs.len() <= minint( AI_HARD_LIMIT, file.maxInfantryAI ) ) // Cap to avoid network load and also engine load
		{
			vector origin = GetSpawnpointsOutsidePlayerLOS_HumanUnits()
			if ( totalGrunts < file.maxEnemyGrunts )
				thread EXT_SpawnGrunt( origin )
			if ( totalSpectres < file.maxEnemySpectres )
			{
				origin = GetSpawnpointsOutsidePlayerLOS_HumanUnits()
				thread EXT_SpawnSpectre( origin )
			}
			if ( totalStalkers < file.maxEnemyStalkers )
			{
				origin = GetSpawnpointsOutsidePlayerLOS_HumanUnits()
				thread EXT_SpawnStalker( origin )
			}
		}
		
		wait 0.2
	}
}

void function Reaper_Spawner_Thread()
{
	while ( true )
	{
		FlagWait( "EnemySpawnerActive" )

		array<entity> npcs = GetNPCArrayOfTeam( TEAM_IMC )
		array<entity> reapers
		ArrayRemoveDead( npcs )
		foreach ( entity npc in npcs )
		{
			if ( !IsSuperSpectre( npc ) )
				continue
			
			reapers.append( npc )
		}

		if ( reapers.len() < file.maxEnemyReapers )
		{
			vector origin = GetSpawnpoints_LargeUnits()
			thread EXT_SpawnReaper( origin )
		}
		
		wait 0.2
	}
}

void function Titan_Spawner_Thread()
{
	while ( true )
	{
		FlagWait( "EnemySpawnerActive" )

		array<entity> npcs = GetTitanArrayOfTeam( TEAM_IMC )
		ArrayRemoveDead( npcs )

		if ( npcs.len() < file.maxEnemyTitans )
		{
			vector origin = GetSpawnpoints_LargeUnits()
			thread EXT_SpawnTitan( origin )
		}
		
		wait 0.2
	}
}

vector function GetSpawnpointsOutsidePlayerLOS_HumanUnits()
{
	array< entity > spawnpoints = SpawnPoints_GetPilot()
	array< vector > spawnVecs

	foreach ( entity spawnpoint in spawnpoints )
		spawnVecs.append( spawnpoint.GetOrigin() )
	
	foreach ( vector spawnpoint in spawnVecs )
	{
		bool needsToRemove = false
		foreach ( player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
		{
			TraceResults result = TraceLine( spawnpoint + < 0, 0, 48 >, player.GetOrigin() + < 0, 0, 48 >, [player], TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
			if ( Distance( spawnpoint, player.GetOrigin() + < 0, 0, 48 > ) < SPAWN_ENEMY_MINDIST || result.fraction == 1.0 )
				needsToRemove = true
		}

		if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > && Distance2D( spawnpoint, file.enemiesAssaultSpecialPosition ) > SPAWN_ENEMY_MAXDIST_LOCATION )
			needsToRemove = true

		if( needsToRemove )
			spawnVecs.removebyvalue( spawnpoint )
	}

	return spawnVecs.getrandom()
}

vector function GetSpawnpoints_LargeUnits()
{
	array< entity > spawnpoints = SpawnPoints_GetTitan()
	array< vector > spawnVecs

	foreach ( entity spawnpoint in spawnpoints )
		spawnVecs.append( spawnpoint.GetOrigin() )

	foreach ( vector spawnpoint in spawnVecs )
	{
		bool needsToRemove = false
		if ( file.enemiesAssaultSpecialPosition != < 0, 0, 0 > && Distance2D( spawnpoint, file.enemiesAssaultSpecialPosition ) > SPAWN_ENEMY_MAXDIST_LOCATION )
			needsToRemove = true

		if( needsToRemove )
			spawnVecs.removebyvalue( spawnpoint )
	}

	return spawnVecs.getrandom()
}









/*
███    ███ ██ ███████  ██████ ███████ ██      ██       █████  ███    ██ ███████  ██████  ██    ██ ███████ 
████  ████ ██ ██      ██      ██      ██      ██      ██   ██ ████   ██ ██      ██    ██ ██    ██ ██      
██ ████ ██ ██ ███████ ██      █████   ██      ██      ███████ ██ ██  ██ █████   ██    ██ ██    ██ ███████ 
██  ██  ██ ██      ██ ██      ██      ██      ██      ██   ██ ██  ██ ██ ██      ██    ██ ██    ██      ██ 
██      ██ ██ ███████  ██████ ███████ ███████ ███████ ██   ██ ██   ████ ███████  ██████   ██████  ███████ 
*/

void function IncrementObjectiveCount( int amount = 1 )
{
	int maxObjectivecount = GetObjectiveMaxCounter()
	int currentObjectivecount =  GetObjectiveCurrentCounter()
	currentObjectivecount += amount
	
	SetGlobalNetInt( "objectiveCounter", minint( currentObjectivecount, maxObjectivecount ) )
}

void function SetObjectiveCurrentCounter( int count )
{
	int countStack = int( max( ( count - ( count % 256 ) ) / 256, 0 ) )
	int countRemainder = ( count % 256 )

	SetGlobalNetInt( "objectiveCounter", countRemainder )
	SetGlobalNetInt( "objectiveCounter256", countStack )
}

void function SetObjectiveMaxCounter( int maxCount )
{
	int countStack = int( max( ( maxCount - ( maxCount % 256 ) ) / 256, 0 ) )
	int countRemainder = ( maxCount % 256 )

	SetGlobalNetInt( "maxObjectiveInteractors", countRemainder )
	SetGlobalNetInt( "maxObjectiveInteractors256", countStack )
}

void function AnnounceObjectiveCompleteForPlayers()
{
	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ObjectiveComplete" )
	
	svGlobal.levelEnt.Signal( "ObjectiveCompleted" )

	SetServerVar( "gameEndTime", Time() )
	SetServerVar( "roundEndTime", Time() )
	wait OBJECTIVE_TIME_INTERVAL_BETWEEN
}

function ExtractionRespawnPanelCanUse( playerUser, controlPanel )
{
	expect entity( playerUser )
	expect entity( controlPanel )

	Remote_CallFunction_NonReplay( playerUser, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.TerminalHacking )
	if ( controlPanel.s.timeUsed > Time() || GetPlayerArrayOfTeam( TEAM_MILITIA ).len() == GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ).len() )
		return false
	
	return ControlPanel_CanUseFunction( playerUser, controlPanel )
}

function RespawnTerminalHacked( panel, player )
{
	expect entity( panel )
	expect entity( player )

	panel.s.timeUsed = Time() + file.respawnTerminalCooldown
	panel.SetUsePrompts( "#EXT_RSPWN_TERMINAL_COOLDOWN", "#EXT_RSPWN_TERMINAL_COOLDOWN" )

	if ( IsAlive( player ) )
	{
		AddPlayerScore( player, "FDTeamHeal", player )
		player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, SCORE_OBJECTIVE_RESPAWN_TEAMMATES )
	}
	
	foreach ( deadPlayer in GetPlayerArray() )
	{
		if( !IsAlive( deadPlayer ) )
		{
			entity intermissionCam = GetEntArrayByClass_Expensive( "info_intermission" ).getrandom()
			deadPlayer.StopObserverMode()
			deadPlayer.ClearReplayDelay()
			deadPlayer.SetViewEntity( intermissionCam, true )
			deadPlayer.Signal( "RespawnMe" )
		}
	}

	thread RespawnTerminalCooldownTracker_Thread( panel )
}

void function RespawnTerminalCooldownTracker_Thread( entity panel )
{
	wait 0.5 // This delay is needed because spectator mode is watched through replay buffer, and clearing that from server is based off their ping, it can never be realtime due to that
	RespawnPlayersInDropPod()
	wait file.respawnTerminalCooldown
	panel.SetUsePrompts( "#EXT_RSPWN_TERMINAL_PRESS_HOLD", "#EXT_RSPWN_TERMINAL_PRESS_USE" )
}

function ExtractionTitanPanelCanUse( playerUser, controlPanel )
{
	expect entity( playerUser )
	expect entity( controlPanel )

	Remote_CallFunction_NonReplay( playerUser, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.TerminalHacking )
	if ( file.playersThatCalledTheirTitans.find( playerUser.GetUID() ) != -1 || GetTitanArrayOfTeam( TEAM_MILITIA ).len() >= file.maxAlliedTitans )
		return false
	
	return ControlPanel_CanUseFunction( playerUser, controlPanel )
}

function TitanTerminalHacked( panel, player )
{
	expect entity( panel )
	expect entity( player )

	array<entity> spawnpoints = ArrayClosest( SpawnPoints_GetTitan(), player.GetOrigin() )
	Point spawnPoint
	spawnPoint.origin = spawnpoints[0].GetOrigin()
	spawnPoint.angles = < 0, RandomFloatRange( 0.0, 359.9 ), 0 >

	file.playersThatCalledTheirTitans.append( player.GetUID() )
	Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.TitanLimit )
	thread CreateTitanForPlayerAndHotdrop( player, spawnPoint )
}

void function OverrideExtractionPilotLoadout( entity player, PilotLoadoutDef loadout )
{
	loadout.setFileMods.append( "disable_wallrun" )
	loadout.setFileMods.append( "disable_doublejump" )
	player.SetPlayerSettingsWithMods( loadout.setFile, loadout.setFileMods )
	
	TakeWeaponsForArray( player, player.GetMainWeapons() )
	player.GiveWeapon( "mp_weapon_semipistol", [] )
	player.TakeOffhandWeapon( OFFHAND_SPECIAL )
	player.TakeOffhandWeapon( OFFHAND_ORDNANCE )
}

void function EXT_OnNPCDeath( entity victim, var damageInfo )
{
	if ( victim.GetTeam() == TEAM_MILITIA ) // Friendlies could count kill quota and drop disks
		return
	
	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	victim.NotSolid() // Their bodies still have a second of collision to bullets and projectiles, so this removes that allowing quicker kills behind each other

	if ( GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.KillQuota )
	{
		if ( IsSuperSpectre( victim ) )
			IncrementObjectiveCount( 2 )
		if ( victim.IsTitan() )
			IncrementObjectiveCount( 4 )
		
		IncrementObjectiveCount()

		if ( IsValidPlayer( attacker ) )
			attacker.AddToPlayerGameStat( PGS_DEFENSE_SCORE, 5 )
	}

	if ( GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.EliminateEliteTitan )
	{
		if ( victim.IsTitan() && victim.GetAISettingsName().find( "elite" ) && victim.GetTargetName() == "eliteTitan" )
			IncrementObjectiveCount()
		
		if ( IsValidPlayer( attacker ) )
			attacker.AddToPlayerGameStat( PGS_DEFENSE_SCORE, 15 )
	}

	if ( GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.DataRecovery )
	{
		if ( IsGrunt( victim ) )
		{
			if ( RandomIntRange( 1, 100 ) >= 40 )
				Extraction_DropIntelTablet( victim )
		}
	}

	if ( IsValid( inflictor ) )
	{
		if ( !inflictor.IsNPC() && IsValidPlayer( attacker ) ) //Turret and Auto-Titan kills should not give xp awards
		{
			entity weapon = attacker.GetActiveWeapon()
			bool canWeaponEarnXp = IsValid( weapon ) && ShouldTrackXPForWeapon( weapon.GetWeaponClassName() ) ? true : false
			
			attacker.s.currentKillstreak++
			if ( attacker.s.currentKillstreak >= 5 && canWeaponEarnXp )
			{
				AddWeaponXP( attacker, 1 )
				attacker.s.currentKillstreak = 0
			}
			
			if ( Time() - attacker.s.lastKillTime > CASCADINGKILL_REQUIREMENT_TIME )
			{
				attacker.s.currentTimedKillstreak = 0
				attacker.s.currentKillstreak = 0
				attacker.s.lastKillTime = Time()
			}

			attacker.s.lastKillTime = Time()
		}
	}
}

void function EXT_EmbarkTitan( entity player, entity titan )
{
	if ( player.GetPlayerNetInt( "tabletInventoryCount" ) > 0 )
		player.SetTitle( "Intel: " + player.GetPlayerNetInt( "tabletInventoryCount" ) )
	
	if ( !IsValid( file.spawnedBattery ) && GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.GatherBatteries )
		SpawnExtractionBatteryItem( file.batteryPlatforms.getrandom() )
}

void function EXT_DisembarkTitan( entity player, entity titan )
{
	if ( player.GetPlayerNetInt( "tabletInventoryCount" ) > 0 )
		player.SetTitle( "Intel: " + player.GetPlayerNetInt( "tabletInventoryCount" ) )
}

void function EXT_BatteryObjectiveCheck( entity rider, entity titan, entity battery )
{
	if ( !IsValid( file.spawnedBattery ) && GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.GatherBatteries )
		SpawnExtractionBatteryItem( file.batteryPlatforms.getrandom() )
}

void function AddTurretSentry( entity turret )
{
	turret.SetShieldHealthMax( PLAYER_TURRET_HEALTH_AMOUNT )
	turret.SetShieldHealth( turret.GetShieldHealthMax() )
	turret.SetMaxHealth( PLAYER_TURRET_HEALTH_AMOUNT )
	turret.SetHealth( turret.GetMaxHealth() )
	entity player = turret.GetBossPlayer()
	if ( player != null )
	{
		turret.kv.AccuracyMultiplier = 6.0
		turret.kv.WeaponProficiency = eWeaponProficiency.VERYGOOD
		turret.kv.meleeable = 0
		if ( turret.GetMainWeapons()[0].GetWeaponClassName() == "mp_weapon_yh803_bullet" || turret.GetMainWeapons()[0].GetWeaponClassName() == "mp_weapon_turretplasma" )
			turret.GetMainWeapons()[0].AddMod( "fd" )
	}
}

void function SendEnemiesToSpecialAssaultPosition( vector pos )
{
	file.enemiesAssaultSpecialPosition = pos
	foreach ( entity npc in GetNPCArrayOfTeam( TEAM_IMC ) )
		npc.AssaultPointClamped( file.enemiesAssaultSpecialPosition )
}

void function ClearEnemiesFromSpecialAssaultPosition()
{
	file.enemiesAssaultSpecialPosition = < 0, 0, 0 >
	foreach ( entity npc in GetNPCArrayOfTeam( TEAM_IMC ) )
		if ( file.enemiesDefaultAssaultPositions.len() )
			npc.AssaultPointClamped( file.enemiesDefaultAssaultPositions.getrandom() )
}

bool function ClientCommandCallbackEXTDropBattery( entity player, array<string> args )
{
	if ( !player.IsTitan() && PlayerHasBattery( player ) )
		Rodeo_PilotThrowsBattery( player )

	return true
}









/*
██ ███    ██ ████████ ███████ ██          ████████  █████  ██████  ██      ███████ ████████ ███████ 
██ ████   ██    ██    ██      ██             ██    ██   ██ ██   ██ ██      ██         ██    ██      
██ ██ ██  ██    ██    █████   ██             ██    ███████ ██████  ██      █████      ██    ███████ 
██ ██  ██ ██    ██    ██      ██             ██    ██   ██ ██   ██ ██      ██         ██         ██ 
██ ██   ████    ██    ███████ ███████        ██    ██   ██ ██████  ███████ ███████    ██    ███████ 
*/

void function Extraction_DropIntelTablet( entity npc )
{
	entity tablet = CreatePropPhysics( MODEL_DATA_TABLET, npc.GetOrigin() + < 0, 0, 40 >, RandomVec( 180 ) )
	SetTargetName( tablet, "intelTablet" )
	tablet.NotSolid()
	Highlight_SetNeutralHighlight( tablet, "sp_friendly_hero" )
	tablet.Highlight_SetParam( 0, 0, < 0.0, 0.0, 0.0 > )
	file.droppedTablets.append( tablet )

	vector vec = RandomVec( 160 )
	tablet.SetVelocity( < vec.x, vec.y, 250 > )
	thread TrackTabletInteraction_Thread( tablet )
}

void function TrackTabletInteraction_Thread( entity tablet )
{
	tablet.EndSignal( "OnDestroy" )
	tablet.SetUsable()
	tablet.SetUsePrompts( "#EXT_TABLET_GRAB_PRESS_HOLD", "#EXT_TABLET_GRAB_PRESS_USE" )

	entity player = expect entity( tablet.WaitSignal( "OnPlayerUse" ).player )

	if ( IsAlive( player ) )
	{
		EmitSoundOnEntity( player, "player_ammopickup" )
		player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, 5 )
		int tabletsInInventory = player.GetPlayerNetInt( "tabletInventoryCount" )
		tabletsInInventory++
		player.SetPlayerNetInt( "tabletInventoryCount", tabletsInInventory )
		if ( GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.DataRecovery )
			IncrementObjectiveCount()
		player.SetTitle( "Intel: " + player.GetPlayerNetInt( "tabletInventoryCount" ) )
		file.droppedTablets.removebyvalue( tablet )
		tablet.Destroy()
	}
}









/*
██     ██ ███████  █████  ██████   ██████  ███    ██      ██████ ██████   █████  ████████ ███████ ███████ 
██     ██ ██      ██   ██ ██   ██ ██    ██ ████   ██     ██      ██   ██ ██   ██    ██    ██      ██      
██  █  ██ █████   ███████ ██████  ██    ██ ██ ██  ██     ██      ██████  ███████    ██    █████   ███████ 
██ ███ ██ ██      ██   ██ ██      ██    ██ ██  ██ ██     ██      ██   ██ ██   ██    ██    ██           ██ 
 ███ ███  ███████ ██   ██ ██       ██████  ██   ████      ██████ ██   ██ ██   ██    ██    ███████ ███████ 
*/

void function Extraction_PlaceWeaponCrate( vector origin, vector angles )
{
	entity weaponCrate = CreateEntity( "prop_script" )
	weaponCrate.SetValueForModelKey( WEAPON_CRATE_MODEL )
	weaponCrate.SetOrigin( origin )
	weaponCrate.SetAngles( angles )
	weaponCrate.kv.solid = SOLID_VPHYSICS
	DispatchSpawn( weaponCrate )

	Highlight_SetNeutralHighlight( weaponCrate, "sp_friendly_hero" )
	weaponCrate.Highlight_SetParam( 0, 0, < 0.0, 0.0, 0.0 > )

	SetTargetName( weaponCrate, "weaponCrate" )
	ToggleNPCPathsForEntity( weaponCrate, false )
	SetCustomSmartAmmoTarget( weaponCrate, false )
	SetObjectCanBeMeleed( weaponCrate, true )
	SetVisibleEntitiesInConeQueriableEnabled( weaponCrate, true )

	weaponCrate.SetTakeDamageType( DAMAGE_YES )
	weaponCrate.SetDamageNotifications( true )
	weaponCrate.SetDeathNotifications( true )
	weaponCrate.SetAIObstacle( true )
	weaponCrate.SetMaxHealth( WEAPON_CRATE_HEALTH )
	weaponCrate.SetHealth( WEAPON_CRATE_HEALTH )
	weaponCrate.SetModel( WEAPON_CRATE_MODEL )
	weaponCrate.SetForceVisibleInPhaseShift( true )

	file.weaponCrates.append( weaponCrate )

	AddEntityCallback_OnKilled( weaponCrate, OnCrateDestroyed )
}

void function WeaponCrateRespawnTimer( vector origin, vector angles, entity weaponWatcher )
{
	wait file.weaponCrateRespawnTime
	Extraction_PlaceWeaponCrate( origin, angles )

	foreach ( weapon in GetWeaponArray( true ) ) // On crate respawn, clear out the previous spawned guns to avoid server load
	{
		if ( "owningCrate" in weapon.s && weapon.s.owningCrate == weaponWatcher )
			weapon.Destroy()
	}

	weaponWatcher.Destroy()
}

void function OnCrateDestroyed( entity crate, var damageInfo )
{
	entity player = DamageInfo_GetAttacker( damageInfo )
	entity weaponWatcher = CreateScriptRef( crate.GetOrigin() )

	if ( file.weaponCrates.find( crate ) != -1 )
		file.weaponCrates.removebyvalue( crate )

	crate.NotSolid()
	EmitSoundAtPosition( TEAM_UNASSIGNED, crate.GetOrigin(), "android_meteorgun_impact_default_3p_vs_1p" )
	PlayFX( $"P_impact_exp_FRAG_metal", crate.GetOrigin() )

	if ( IsValidPlayer( player ) )
		Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.WeaponsAndGear )

	int amountOfWeapons = 1
	if ( file.minGunsCrates == file.maxGunsCrates )
		amountOfWeapons = file.minGunsCrates
	else
		amountOfWeapons = RandomIntRange( file.minGunsCrates, file.maxGunsCrates )

	array< string > gunsArrayBase = ["mp_weapon_wingman", "mp_weapon_autopistol", "mp_weapon_rspn101_og", "mp_weapon_rspn101", "mp_weapon_dmr", "mp_weapon_doubletake", "mp_weapon_grenade_emp", "mp_weapon_grenade_gravity", "mp_weapon_shotgun", "mp_weapon_shotgun_doublebarrel", "mp_weapon_vinson", "mp_weapon_g2", "mp_weapon_mastiff", "mp_weapon_hemlok","mp_weapon_alternator_smg","mp_weapon_hemlok_smg"]
	array< string > gunsArrayTier2 = ["mp_weapon_frag_grenade", "mp_weapon_thermite_grenade", "mp_weapon_shotgun_pistol", "mp_weapon_r97", "mp_weapon_sniper", "mp_weapon_mgl", "mp_weapon_defender","mp_weapon_grenade_electric_smoke","mp_weapon_wingman_n","mp_weapon_esaw"]
	array< string > gunsArrayTier3 = ["mp_weapon_lmg", "mp_weapon_lstar", "mp_weapon_pulse_lmg", "mp_weapon_smr", "mp_weapon_epg", "mp_weapon_softball", "mp_weapon_car", "mp_weapon_rocket_launcher", "mp_weapon_satchel","mp_weapon_arc_launcher"]

	if ( GetGlobalNetInt( "hazardLevel" ) >= 2 )
		gunsArrayBase.extend( gunsArrayTier2 )
	if ( GetGlobalNetInt( "hazardLevel" ) >= 3 )
		gunsArrayBase.extend( gunsArrayTier3 )
	if ( GetGlobalNetInt( "hazardLevel" ) >= 4 )
	{
		gunsArrayBase = gunsArrayTier2
		gunsArrayBase.extend( gunsArrayTier3 )
	}
	if ( GetGlobalNetInt( "hazardLevel" ) >= 5 )
		gunsArrayBase = gunsArrayTier3

	int weaponCount = 0
	while ( weaponCount < amountOfWeapons )
	{
		vector vec = RandomVec( 200 )
		entity weapon = CreateWeaponEntityByNameWithPhysics( gunsArrayBase.getrandom(), crate.GetOrigin() + < 0, 0, 32 >, < 0, RandomFloatRange( 0.0, 359.9 ), 0 > )
		weapon.SetVelocity( < vec.x, vec.y, 250 > )
		Highlight_SetNeutralHighlight( weapon, "weapon_drop_normal" )
		if ( GetGlobalNetInt( "hazardLevel" ) >= 2 )
		{
			try
				weapon.AddMod( "extended_ammo" )
			catch( e1 ) {}

			try
				weapon.AddMod( "pas_ordnance_pack" )
			catch( e2 ) {}
		}

		if ( GetGlobalNetInt( "hazardLevel" ) >= 3 )
		{
			try
				weapon.AddMod( "pas_fast_reload" )
			catch( e3 ) {}

			try
				weapon.AddMod( "pas_fast_swap" )
			catch( e4 ) {}
		}

		if ( GetGlobalNetInt( "hazardLevel" ) >= 4 )
		{
			try
				weapon.AddMod( "pas_run_and_gun" )
			catch( e5 ) {}

			try
				weapon.AddMod( "pas_fast_ads" )
			catch( e6 ) {}
		}

		if ( GetGlobalNetInt( "hazardLevel" ) >= 5 )
		{
			try
				weapon.AddMod( "threat_scope" )
			catch( e7 ) {}

			try
				weapon.AddMod( "at_unlimited_ammo" )
			catch( e8 ) {}
		}

		weapon.s.owningCrate <- weaponWatcher
		weaponCount++
	}

	thread WeaponCrateRespawnTimer( crate.GetOrigin(), crate.GetAngles(), weaponWatcher )
}









/*
 ██████  ██████  ███    ███ ██████  ██    ██ ████████ ███████ ██████      ████████ ███████ ██████  ███    ███ ██ ███    ██  █████  ██      
██      ██    ██ ████  ████ ██   ██ ██    ██    ██    ██      ██   ██        ██    ██      ██   ██ ████  ████ ██ ████   ██ ██   ██ ██      
██      ██    ██ ██ ████ ██ ██████  ██    ██    ██    █████   ██████         ██    █████   ██████  ██ ████ ██ ██ ██ ██  ██ ███████ ██      
██      ██    ██ ██  ██  ██ ██      ██    ██    ██    ██      ██   ██        ██    ██      ██   ██ ██  ██  ██ ██ ██  ██ ██ ██   ██ ██      
 ██████  ██████  ██      ██ ██       ██████     ██    ███████ ██   ██        ██    ███████ ██   ██ ██      ██ ██ ██   ████ ██   ██ ███████ 
*/


void function Extraction_PlaceTerminalInteractor( vector origin )
{
	entity switchPanel = CreatePropDynamic( MODEL_TERMINAL_PLACEHOLDER, origin + < 0, 0, 4 >, < 0, 0, 0 >, 0 )
	switchPanel.SetForceVisibleInPhaseShift( true )
	switchPanel.MakeInvisible()
	file.terminalPanels.append( switchPanel )
}

void function TrackSwitchPanelInteraction_Threaded( entity switchPanel, entity ruiTracker )
{
	switchPanel.EndSignal( "OnDestroy" )
	switchPanel.SetUsable()
	switchPanel.SetUsePrompts( "#EXT_CONSOLE_PRESS_HOLD", "#EXT_CONSOLE_PRESS_USE" )

	entity player = expect entity( switchPanel.WaitSignal( "OnPlayerUse" ).player )

	if ( IsValidPlayer( player ) )
		player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, 15 )

	switchPanel.UnsetUsable()
	EmitSoundOnEntity( switchPanel, "Switch_Activate" )

	if ( IsValid( ruiTracker ) )
		ruiTracker.Destroy()

	IncrementObjectiveCount()
}










/*
██████   ██████  ██████   ██████  ████████     ██████   █████  ███    ██ ██   ██ ███████ 
██   ██ ██    ██ ██   ██ ██    ██    ██        ██   ██ ██   ██ ████   ██ ██  ██  ██      
██████  ██    ██ ██████  ██    ██    ██        ██████  ███████ ██ ██  ██ █████   ███████ 
██   ██ ██    ██ ██   ██ ██    ██    ██        ██   ██ ██   ██ ██  ██ ██ ██  ██       ██ 
██   ██  ██████  ██████   ██████     ██        ██████  ██   ██ ██   ████ ██   ██ ███████ 
*/

void function Extraction_PlaceRobotBank( vector origin )
{
	entity crate = CreatePropDynamic( MODEL_ATTRITION_BANK, origin, < 0, 0, 0 >, 6 )

	crate.SetUsePrompts( "#EXT_INSPECT_BANK_PRESS_HOLD", "#EXT_INSPECT_BANK_PRESS_USE" )
	crate.SetForceVisibleInPhaseShift( true )

	thread PlayAnim( crate, "mh_inactive_idle", crate.GetParent() )
	file.robotBanks.append( crate )
}

void function PickRobotsForJumpkitAndTactical()
{
	if ( file.robotBanks.len() <= 1 )
		return
	
	entity jumpKitBank = file.robotBanks.getrandom()
	jumpKitBank.SetUsable()
	jumpKitBank.SetUsableByGroup( "pilot" )
	thread MonitorJumpkitRobotInteraction_Threaded( jumpKitBank )
	file.robotBanks.removebyvalue( jumpKitBank )
	
	entity tacticalBank = file.robotBanks.getrandom()
	tacticalBank.SetUsable()
	jumpKitBank.SetUsableByGroup( "pilot" )
	thread MonitorTacticalRobotInteraction_Threaded( tacticalBank )
	file.robotBanks.removebyvalue( tacticalBank )

	foreach( robotBank in file.robotBanks )
		thread MonitorEmptyRobotInteraction_Threaded( robotBank )
}

void function MonitorJumpkitRobotInteraction_Threaded( entity bankTracking )
{
	bankTracking.EndSignal( "OnDestroy" )
	bool robotActivated

	while ( true )
	{
		entity player = expect entity(  bankTracking.WaitSignal( "OnPlayerUse" ).player )
		if ( IsAlive( player ) )
		{
			array<string> playerMods = player.GetPlayerSettingsMods()
			if ( playerMods.find( "disable_wallrun" ) != -1 && playerMods.find( "disable_doublejump" ) != -1 )
			{
				Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.RobotBanks )
				Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_AnnounceJumpKit" )
				int loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "pilot" )
				PilotLoadoutDef loadout = GetPilotLoadoutFromPersistentData( player, loadoutIndex )
				player.SetPlayerSettingsWithMods( loadout.setFile, loadout.setFileMods )
				player.SetPlayerNetBool( "playerGotJumpkit", true )
			}
		}

		if ( !robotActivated )
		{
			entity jumpKitRuiTracker = CreateEntity( "info_target" )
			jumpKitRuiTracker.SetOrigin( bankTracking.GetOrigin() + < 0, 0, 48 > )
			jumpKitRuiTracker.kv.spawnFlags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
			DispatchSpawn( jumpKitRuiTracker )
			SetTargetName( jumpKitRuiTracker, "jumpKitBank" )
			jumpKitRuiTracker.DisableHibernation()

			if ( IsAlive( player ) )
			{
				AddPlayerScore( player, "FDSupportBonus", player )
				player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, SCORE_OBJECTIVE_GEARFOUND )
			}

			thread EnableRobotBank( bankTracking )
		}
		
		robotActivated = true

		bankTracking.UnsetUsable()
		wait 0.5

		bankTracking.SetUsable()
	}
}

void function MonitorTacticalRobotInteraction_Threaded( entity bankTracking )
{
	bankTracking.EndSignal( "OnDestroy" )
	bool robotActivated

	while ( true )
	{
		entity player = expect entity( bankTracking.WaitSignal( "OnPlayerUse" ).player )
		if ( IsAlive( player ) && !IsValid( player.GetOffhandWeapon( OFFHAND_LEFT ) ) )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.RobotBanks )
			Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_AnnounceTactical" )
			int loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "pilot" )
			PilotLoadoutDef loadout = GetPilotLoadoutFromPersistentData( player, loadoutIndex )
			player.GiveOffhandWeapon( loadout.special, OFFHAND_LEFT, loadout.specialMods )
			player.SetPlayerNetBool( "playerGotTactical", true )
		}

		if ( !robotActivated )
		{
			entity tacticaRuiTracker = CreateEntity( "info_target" )
			tacticaRuiTracker.SetOrigin( bankTracking.GetOrigin() + < 0, 0, 48 > )
			tacticaRuiTracker.kv.spawnFlags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
			DispatchSpawn( tacticaRuiTracker )
			SetTargetName( tacticaRuiTracker, "tacticalBank" )
			tacticaRuiTracker.DisableHibernation()

			if ( IsAlive( player ) )
			{
				AddPlayerScore( player, "FDDamageBonus", player )
				player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, SCORE_OBJECTIVE_GEARFOUND )
			}

			thread EnableRobotBank( bankTracking )
		}
		
		robotActivated = true
		bankTracking.UnsetUsable()

		wait 0.5

		bankTracking.SetUsable()
	}
}

void function MonitorEmptyRobotInteraction_Threaded( entity bankTracking )
{
	bankTracking.EndSignal( "OnDestroy" )
	bankTracking.EndSignal( "BankPickedForDataDelivery" )
	bankTracking.SetUsable()

	entity player = expect entity( bankTracking.WaitSignal( "OnPlayerUse" ).player )
	Remote_CallFunction_NonReplay( player, "ServerCallback_EXT_ShowTutorialHint", eEXTTutorials.RobotBanks )
	bankTracking.UnsetUsable()
}

void function MonitorDeliveryRobotInteraction_Threaded( entity bankTracking )
{
	bankTracking.EndSignal( "OnDestroy" )

	while ( true )
	{
		entity player = expect entity( bankTracking.WaitSignal( "OnPlayerUse" ).player )
		if ( IsAlive( player ) )
		{
			if ( player.GetPlayerNetInt( "tabletInventoryCount" ) > 0 )
			{
				IncrementObjectiveCount( player.GetPlayerNetInt( "tabletInventoryCount" ) )
				player.SetPlayerNetInt( "tabletInventoryCount", 0 )
				player.SetTitle( "" )
				EmitSoundOnEntityOnlyToPlayer( player, player, "HUD_MP_BountyHunt_BankBonusPts_Deposit_Start_1P" )
			}
		}
		WaitFrame()
	}
}

void function EnableRobotBank( entity robotBank, int team = TEAM_MILITIA )
{
	robotBank.EndSignal( "OnDestroy" )
	SetTeam( robotBank, team )
	waitthread PlayAnim( robotBank, "mh_inactive_2_active", robotBank.GetParent() )
	thread PlayAnim( robotBank, "mh_active_idle", robotBank.GetParent() )
	EmitSoundOnEntity( robotBank, "Mobile_Hardpoint_Idle" )
}

void function DisableRobotBank( entity robotBank )
{
	robotBank.EndSignal( "OnDestroy" )
	robotBank.UnsetUsable()
	SetTeam( robotBank, TEAM_UNASSIGNED )
	FadeOutSoundOnEntity( robotBank, "Mobile_Hardpoint_Idle", 1.0 )
	waitthread PlayAnim( robotBank, "mh_active_2_inactive", robotBank.GetParent() )
	thread PlayAnim( robotBank, "mh_inactive_idle", robotBank.GetParent() )
}










/*
██   ██  █████  ██████  ██    ██ ███████ ███████ ████████ ███████ ██████  
██   ██ ██   ██ ██   ██ ██    ██ ██      ██         ██    ██      ██   ██ 
███████ ███████ ██████  ██    ██ █████   ███████    ██    █████   ██████  
██   ██ ██   ██ ██   ██  ██  ██  ██           ██    ██    ██      ██   ██ 
██   ██ ██   ██ ██   ██   ████   ███████ ███████    ██    ███████ ██   ██ 
*/

entity function Extraction_SpawnHarvester()
{
	array<entity> spawnpoints = SpawnPoints_GetDropPod()
	entity chosenSpot = spawnpoints.getrandom()

	entity harvester = CreatePropScript( MODEL_HARVESTER_EXTRACTION, chosenSpot.GetOrigin(), < 0, 0, 0 >, SOLID_VPHYSICS )
	
	PlayFX( $"P_phase_shift_main_XO", chosenSpot.GetOrigin() )
	SetTargetName( harvester, "objectiveHarvester" )
	ToggleNPCPathsForEntity( harvester, true )
	SetCustomSmartAmmoTarget( harvester, true )
	SetObjectCanBeMeleed( harvester, true )
	SetVisibleEntitiesInConeQueriableEnabled( harvester, true )
	SetTeam( harvester, TEAM_IMC )
	GenerateHarvesterBeam( harvester )
	EmitSoundOnEntity( harvester, "coop_generator_ambient_healthy" )

	int harvesterTotalHP = OBJECTIVE_HARVESTER_BASE_HEALTH * GetPlayerArray().len()

	harvester.SetMaxHealth( harvesterTotalHP )
	harvester.SetHealth( harvesterTotalHP )
	harvester.SetAIObstacle( true )
	harvester.SetTakeDamageType( DAMAGE_YES )
	harvester.SetDamageNotifications( true )

	AddEntityCallback_OnFinalDamaged( harvester, OnHarvesterDamaged )
	AddEntityCallback_OnKilled( harvester, OnHarvesterDestroyed )

	thread TrackHarvesterBeamColor_Thread( harvester )

	return harvester
}

void function TrackHarvesterBeamColor_Thread( entity harvester )
{
	harvester.EndSignal( "OnDeath" )
	harvester.EndSignal( "OnDestroy" )

	while( true )
	{
		if ( IsValid( file.harvesterBeam ) )
		{
			vector beamColor = GetShieldTriLerpColor( 1.0 - ( harvester.GetHealth().tofloat() / harvester.GetMaxHealth().tofloat() ) )
			if ( harvester.GetHealth() > 1 )
				EffectSetControlPointVector( file.harvesterBeam, 1, beamColor )
		}

		WaitFrame()
	}
}

void function GenerateHarvesterBeam( entity harvester )
{
	entity Harvester_Beam = StartParticleEffectOnEntity_ReturnEntity( harvester, GetParticleSystemIndex( FX_HARVESTER_BEAM ), FX_PATTACH_ABSORIGIN_FOLLOW ,0 )
	EffectSetControlPointVector( Harvester_Beam, 1, GetShieldTriLerpColor( 0.0 ) )
	Harvester_Beam.DisableHibernation()
	file.harvesterBeam = Harvester_Beam
}

void function OnHarvesterDamaged( entity harvester, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	
	if ( IsValid( attacker ) && attacker.GetTeam() == harvester.GetTeam() )
		DamageInfo_ScaleDamage( damageInfo, 0.0 )
	else if ( IsValidPlayer( attacker ) )
	{
		attacker.AddToPlayerGameStat( PGS_DEFENSE_SCORE, SCORE_OBJECTIVE_HARVESTER_DAMAGE )
		attacker.NotifyDidDamage( harvester, DamageInfo_GetHitBox( damageInfo ), DamageInfo_GetDamagePosition( damageInfo ), DamageInfo_GetCustomDamageType( damageInfo ), DamageInfo_GetDamage( damageInfo ), DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ), DamageInfo_GetWeapon( damageInfo ), DamageInfo_GetDistFromAttackOrigin( damageInfo ) )
	}
}

void function OnHarvesterDestroyed( entity harvester, var damageInfo )
{
	StopSoundOnEntity( harvester, "coop_generator_ambient_healthy" )
	EmitSoundAtPosition( TEAM_UNASSIGNED, harvester.GetOrigin(), "bt_beacon_controlroom_dish_explosion" )

	entity harvExpFX = PlayFX( $"P_harvester_beam_end", harvester.GetOrigin() )
	harvExpFX.Destroy()

	harvester.NotSolid()
	PlayFX( $"xo_exp_death", harvester.GetOrigin() )

	if ( IsValid( file.harvesterBeam ) )
		file.harvesterBeam.Destroy()
	
	IncrementObjectiveCount()
}










/*
██████   █████  ████████ ████████ ███████ ██████  ██    ██     ███████ ██████   ██████  ████████ ███████ 
██   ██ ██   ██    ██       ██    ██      ██   ██  ██  ██      ██      ██   ██ ██    ██    ██    ██      
██████  ███████    ██       ██    █████   ██████    ████       ███████ ██████  ██    ██    ██    ███████ 
██   ██ ██   ██    ██       ██    ██      ██   ██    ██             ██ ██      ██    ██    ██         ██ 
██████  ██   ██    ██       ██    ███████ ██   ██    ██        ███████ ██       ██████     ██    ███████ 
*/

void function Extraction_PlaceBatterySpot( vector origin )
{
	entity batteryPlatform = CreatePropDynamicLightweight( MODEL_BATTERY_SPAWNER_BASE, origin, < 0, 0, 0 >, 6 )
	file.batteryPlatforms.append( batteryPlatform )
}

void function SpawnExtractionBatteryItem( entity batteryPlatform )
{
	entity battery = Rodeo_CreateBatteryPack()
	battery.SetSkin( 2 )

	foreach ( fx in battery.e.fxArray )
		EffectStop( fx )

	battery.e.fxArray.clear()
	int attachID = battery.LookupAttachment( "fx_center" )
	asset fx = BATTERY_FX_AMPED

	if ( IsValid( battery ) )
		battery.e.fxArray.append( StartParticleEffectOnEntity_ReturnEntity( battery, GetParticleSystemIndex( fx ), FX_PATTACH_POINT_FOLLOW, attachID ) )

	battery.StopPhysics()
	battery.SetOrigin( batteryPlatform.GetOrigin() + < 0, 0, 40 > )

	entity glowRef = CreateScriptRef( batteryPlatform.GetOrigin() )
	PickupGlow glow = CreatePickupGlow( glowRef, 255, 255, 0 )
	glow.glowFX.SetOrigin( batteryPlatform.GetOrigin() )

	file.spawnedBattery = battery

	thread MonitorBatteryPickup_Thread( battery, glowRef )
}

void function MonitorBatteryPickup_Thread( entity battery, entity glowRef )
{
	battery.EndSignal( "OnDestroy" )
	OnThreadEnd( function() : ( battery, glowRef ) 
	{
		file.spawnedBattery = null
		glowRef.Destroy()
	})

	while ( !IsValid( battery.GetParent() ) )
		WaitFrame()
}

void function SetupExtractionBatteryPort( entity batteryPort )
{
	InitTurretBatteryPort( batteryPort )
	batteryPort.s.isUsable <- EXTBatteryPortUseCheck
	batteryPort.s.useBattery <- EXTUseBatteryFunc
	batteryPort.s.hackAvaliable = false
	batteryPort.SetUsableByGroup( "pilot" )
}

function EXTBatteryPortUseCheck( batteryPortvar, playervar )
{	
	entity batteryPort = expect entity( batteryPortvar )
	entity player = expect entity( playervar )

    return ( PlayerHasBattery( player ) && GetObjectiveMaxCounter() > GetObjectiveCurrentCounter() )
}

function EXTUseBatteryFunc( batteryPortvar, playervar )
{
	entity batteryPort = expect entity( batteryPortvar )
	entity player = expect entity( playervar )
	
	if ( !IsValid( player ) )
		return
	
	player.AddToPlayerGameStat( PGS_DEFENSE_SCORE, SCORE_OBJECTIVE_BATTERY_GATHER )
	IncrementObjectiveCount()

	if ( GetObjectiveMaxCounter() == GetObjectiveCurrentCounter() )
		thread WaitPlayerFinishAnimation( player, batteryPort )
	else if ( !IsValid( file.spawnedBattery ) )
		SpawnExtractionBatteryItem( file.batteryPlatforms.getrandom() )
}

void function WaitPlayerFinishAnimation( entity player, entity batteryPort )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd( function() : ( batteryPort ) 
	{
		batteryPort.Destroy()
	})

	while ( player.GetParent() == batteryPort )
		WaitFrame()
	
	wait 0.5
}









/*
██   ██  █████   ██████ ██   ██     ███████ ████████  █████  ████████ ██  ██████  ███    ██ ███████ 
██   ██ ██   ██ ██      ██  ██      ██         ██    ██   ██    ██    ██ ██    ██ ████   ██ ██      
███████ ███████ ██      █████       ███████    ██    ███████    ██    ██ ██    ██ ██ ██  ██ ███████ 
██   ██ ██   ██ ██      ██  ██           ██    ██    ██   ██    ██    ██ ██    ██ ██  ██ ██      ██ 
██   ██ ██   ██  ██████ ██   ██     ███████    ██    ██   ██    ██    ██  ██████  ██   ████ ███████ 
*/

void function Extraction_PlaceHackStation( vector origin )
{
	entity hackStation = CreatePropDynamicLightweight( MODEL_HACK_STATION, origin, < 0, 0, 0 >, 6 )
	hackStation.s.seats <- [ null, null, null, null ]
	file.hackStations.append( hackStation )
}

void function SpawnAlliedHackerTeam( entity hackStation )
{
	array< entity > spawnpoints = ArrayClosest( SpawnPoints_GetDropPod(), hackStation.GetOrigin() )

	vector pos = OriginToGround( spawnpoints[0].GetOrigin() )
	entity pod = CreateDropPod( pos, < 0, RandomIntRange( 0, 359 ), 0 > )
	SetTeam( pod, TEAM_MILITIA )
	InitFireteamDropPod( pod )

	string squadName = MakeSquadName( TEAM_MILITIA, UniqueString() )
	array< entity > guys

	for ( int i = 0; i < 4; i++ )
    {
		array< string > gunsArray = ["mp_weapon_lmg", "mp_weapon_lstar", "mp_weapon_mastiff", "mp_weapon_smr", "mp_weapon_epg"]
		array< string > grenadesArray = ["mp_weapon_frag_grenade", "mp_weapon_grenade_electric_smoke", "mp_weapon_thermite_grenade"]
		entity guy = CreateSoldier( TEAM_MILITIA, pos, < 0, 0, 0 > )
		SetSpawnflags( guy, SF_NPC_START_EFFICIENT )
		SetSpawnOption_Alert( guy )
		guy.kv.grenadeWeaponName = grenadesArray.getrandom()
		SetSpawnOption_Weapon( guy, gunsArray.getrandom() )
		DispatchSpawn( guy )
		guy.EnableNPCFlag( NPC_NO_WEAPON_DROP | NPC_NO_PAIN | NPC_NO_GESTURE_PAIN | NPC_ALLOW_HAND_SIGNALS | NPC_IGNORE_FRIENDLY_SOUND )
		guy.DisableNPCFlag( NPC_ALLOW_FLEE | NPC_DIRECTIONAL_MELEE )
		guy.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
		guy.DisableNPCMoveFlag( NPCMF_WALK_NONCOMBAT | NPCMF_WALK_ALWAYS )
		guy.SetCapabilityFlag( bits_CAP_INNATE_MELEE_ATTACK1 | bits_CAP_INNATE_MELEE_ATTACK2 | bits_CAP_SYNCED_MELEE_ATTACK , false )
		guy.SetParent( pod, "ATTACH", true )
		SetSquad( guy, squadName )
		SetTargetName( guy, "hackGrunt" )
		HideName( guy )

		foreach ( entity weapon in guy.GetMainWeapons() )
		{
			if ( weapon.GetWeaponClassName() == "mp_weapon_rocket_launcher" )
				guy.TakeWeapon( weapon.GetWeaponClassName() )
		}

		guy.MakeInvisible()
		entity weapon = guy.GetActiveWeapon()
		if ( IsValid( weapon ) )
			weapon.MakeInvisible()
		
		guy.AssaultSetGoalRadius( 128 )
		guy.AssaultSetGoalHeight( 64 )
		guy.AssaultSetFightRadius( 0 )
		guy.SetMaxHealth( HACK_GRUNT_HEALTH_AMOUNT )
		guy.SetHealth( HACK_GRUNT_HEALTH_AMOUNT )
		guy.kv.AccuracyMultiplier = 10.0
		guy.kv.WeaponProficiency = eWeaponProficiency.VERYGOOD
		guys.append( guy )
	}

	waitthread LaunchAnimDropPod( pod, "pod_testpath", pos, < 0, RandomIntRange( 0, 359 ), 0 > )
	ArrayRemoveDead( guys )
	ActivateFireteamDropPod( pod, guys )

	foreach ( npc in guys )
	{
		npc.SetEfficientMode( false )
		npc.AssaultPointClamped( hackStation.GetOrigin() )
		thread MonitorHackingGrunt_Thread( npc, hackStation )
	}

	svGlobal.levelEnt.EndSignal( "ObjectiveCompleted" )
	while ( guys.len() > 0 )
	{
		ArrayRemoveDead( guys )
		WaitFrame()
	}
	
	SetWinner( TEAM_IMC, "#EXT_DEFEAT_MESSAGE_HACKER_GRUNTS_DEAD", "#EXT_DEFEAT_MESSAGE_HACKER_GRUNTS_DEAD" )
}

void function MonitorHackingGrunt_Thread( entity grunt, entity hackStation )
{
	svGlobal.levelEnt.EndSignal( "ObjectiveCompleted" )

	grunt.EndSignal( "OnDeath" )
	grunt.EndSignal( "OnDestroy" )
	
	grunt.WaitSignal( "OnEnterGoalRadius" )

	string attachID = ""
	if ( !IsAlive( expect entity ( hackStation.s.seats[0] ) ) )
	{
		attachID = "SEAT_N"
		hackStation.s.seats[0] = grunt
	}
	else if ( !IsAlive( expect entity ( hackStation.s.seats[1] ) ) )
	{
		attachID = "SEAT_W"
		hackStation.s.seats[1] = grunt
	}
	else if ( !IsAlive( expect entity ( hackStation.s.seats[2] ) ) )
	{
		attachID = "SEAT_S"
		hackStation.s.seats[2] = grunt
	}
	else if ( !IsAlive( expect entity ( hackStation.s.seats[3] ) ) )
	{
		attachID = "SEAT_E"
		hackStation.s.seats[3] = grunt
	}
	else
		return

	array < string > sittingAnims = [ "pt_console_runin_R", "pt_console_runin_L" ]
	waitthread PlayAnim( grunt, sittingAnims.getrandom(), hackStation, attachID )

	grunt.SetEfficientMode( true )

	OnThreadEnd( function() : ( grunt, hackStation, attachID ) 
	{
		if ( IsAlive( grunt ) )
		{
			grunt.Signal( "ObjectiveCompleted" )
			array < string > leavingAnims = [ "pt_console_runout_R", "pt_console_runout_L" ]
			grunt.SetEfficientMode( false )
			thread PlayAnim( grunt, leavingAnims.getrandom(), hackStation, attachID )
			NPCFollowsPlayer( grunt, GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ).getrandom() )
		}
	})

	thread GruntHackingStationScore_Thread( grunt )
	while ( true )
		waitthread PlayAnim( grunt, "pt_console_idle", hackStation, attachID )
}

void function GruntHackingStationScore_Thread( entity grunt )
{
	svGlobal.levelEnt.EndSignal( "ObjectiveCompleted" )
	grunt.EndSignal( "OnDeath" )
	grunt.EndSignal( "OnDestroy" )

	while ( true )
	{
		IncrementObjectiveCount()
		foreach ( player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
		{
			if ( Distance( player.GetOrigin(), grunt.GetOrigin() ) < HACK_STATION_SCORE_RANGE )
				player.AddToPlayerGameStat( PGS_ASSAULT_SCORE, SCORE_OBJECTIVE_HACK_PROTECTION )
		}
		wait 1
	}
}









/*
██ ███    ██ ████████ ██████   ██████      ███████  ██████ ███████ ███    ██ ███████ 
██ ████   ██    ██    ██   ██ ██    ██     ██      ██      ██      ████   ██ ██      
██ ██ ██  ██    ██    ██████  ██    ██     ███████ ██      █████   ██ ██  ██ █████   
██ ██  ██ ██    ██    ██   ██ ██    ██          ██ ██      ██      ██  ██ ██ ██      
██ ██   ████    ██    ██   ██  ██████      ███████  ██████ ███████ ██   ████ ███████ 
*/

void function ExtractionIntro_Setup()
{
	AddCallback_GameStateEnter( eGameState.Prematch, ExtractionIntro_ExecuteIntro )
}

float function ExtractionIntro_GetDuration()
{
	entity pod = CreatePropDynamic( $"models/vehicle/droppod_fireteam/droppod_fireteam.mdl", < 0, 0, 0 >, < 0, 0, 0 > )
	float introDuration = ceil( pod.GetSequenceDuration( "pod_testpath" ) + 4.0 )
	pod.Destroy()

	return introDuration
}

void function ExtractionIntro_ExecuteIntro()
{
	ClassicMP_OnIntroStarted()
	RespawnPlayersInDropPod()

	while ( Time() < expect float( level.nv.gameStartTime ) )
		WaitFrame()
	
	ClassicMP_OnIntroFinished()
	foreach ( entity player in GetPlayerArray() )
	{
		if ( !IsPrivateMatchSpectator( player ) )
			TryGameModeAnnouncement( player )
	}
}









/*
██████  ██    ██ ██████  ███    ██  ██████  █████  ██████  ██████       ██████  ██    ██ ███████ ██████  ██████  ██ ██████  ███████ ███████ 
██   ██ ██    ██ ██   ██ ████   ██ ██      ██   ██ ██   ██ ██   ██     ██    ██ ██    ██ ██      ██   ██ ██   ██ ██ ██   ██ ██      ██      
██████  ██    ██ ██████  ██ ██  ██ ██      ███████ ██████  ██   ██     ██    ██ ██    ██ █████   ██████  ██████  ██ ██   ██ █████   ███████ 
██   ██ ██    ██ ██   ██ ██  ██ ██ ██      ██   ██ ██   ██ ██   ██     ██    ██  ██  ██  ██      ██   ██ ██   ██ ██ ██   ██ ██           ██ 
██████   ██████  ██   ██ ██   ████  ██████ ██   ██ ██   ██ ██████       ██████    ████   ███████ ██   ██ ██   ██ ██ ██████  ███████ ███████ 
*/

void function ExtractionMaphackBurncard( entity player )
{
	thread MaphackBurncard_Thread( player )
}

void function MaphackBurncard_Thread( entity player )
{
	player.EndSignal( "OnDestroy" )

	int playerTeam = player.GetTeam()
	bool cleanup = false
	array<entity> entities, affectedEntities
	int statusEffect = 0

	OnThreadEnd(
		function() : ( cleanup, playerTeam, affectedEntities, statusEffect )
		{
			foreach ( weaponCrate in file.weaponCrates )
				weaponCrate.Highlight_SetParam( 0, 0, < 0.0, 0.0, 0.0 > )
			
			foreach ( tablet in file.droppedTablets )
				tablet.Highlight_SetParam( 0, 0, < 0.0, 0.0, 0.0 > )

			file.respawnTerminal.Highlight_SetParam( 1, 0, < 0.0, 0.0, 0.0 > )
			file.titanTerminal.Highlight_SetParam( 1, 0, < 0.0, 0.0, 0.0 > )

			if ( !cleanup )
				return
			
			foreach ( entity ent in affectedEntities )
			{
				if ( IsValid( ent ) )
				{
					SonarEnd( ent, playerTeam )
					StatusEffect_Stop( ent, statusEffect )
				}
			}

			DecrementSonarPerTeam( playerTeam )
		}
	)

	for ( int i = 0; i < 6; i++ )
	{
		EmitSoundOnEntityOnlyToPlayer( player, player, "Burn_Card_Map_Hack_Radar_Pulse_V1_1P" )
		foreach ( allyPlayer in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
			EmitSoundOnEntityOnlyToPlayer( allyPlayer, allyPlayer, "HUD_MP_EnemySonarTag_Flashed_1P" )

		entities = GetPlayerArray()
		entities.extend( GetNPCArray() )
		entities.extend( GetPlayerDecoyArray() )

		IncrementSonarPerTeam( playerTeam )

		if ( IsAlive( player ) )
			Remote_CallFunction_Replay( player, "ServerCallback_SonarPulseFromPosition", player.GetOrigin().x, player.GetOrigin().y, player.GetOrigin().z, SONAR_GRENADE_RADIUS )
		
		foreach ( entity ent in entities )
		{
			if ( !IsValid( ent ) )
				continue

			if ( ent.GetTeam() != playerTeam )
			{
				affectedEntities.append( ent )
				statusEffect = StatusEffect_AddEndless( ent, eStatusEffect.damage_received_multiplier, 0.25 )
				SonarStart( ent, player.GetOrigin(), playerTeam, player )
			}
		}

		foreach ( weaponCrate in file.weaponCrates )
			weaponCrate.Highlight_SetParam( 0, 0, < 1.0, 1.0, 1.0 > )
		
		foreach ( tablet in file.droppedTablets )
			tablet.Highlight_SetParam( 0, 0, HIGHLIGHT_COLOR_INTERACT )

		file.respawnTerminal.Highlight_SetParam( 1, 0, < 0.5, 2.0, 0.5 > )
		file.titanTerminal.Highlight_SetParam( 1, 0, < 0.5, 2.0, 0.5 > )

		cleanup = true
		wait 2

		DecrementSonarPerTeam( playerTeam )
		foreach ( entity ent in affectedEntities )
		{
			if ( IsValid( ent ) )
			{
				SonarEnd( ent, playerTeam )
				StatusEffect_Stop( ent, statusEffect )
			}
		}

		foreach ( weaponCrate in file.weaponCrates )
			weaponCrate.Highlight_SetParam( 0, 0, < 0.0, 0.0, 0.0 > )
		
		foreach ( tablet in file.droppedTablets )
			tablet.Highlight_SetParam( 0, 0, < 0.0, 0.0, 0.0 > )

		file.respawnTerminal.Highlight_SetParam( 1, 0, < 0.0, 0.0, 0.0 > )
		file.titanTerminal.Highlight_SetParam( 1, 0, < 0.0, 0.0, 0.0 > )
		
		cleanup = false
		affectedEntities.clear()
		wait 1
	}
}

void function ExtractionRadarJammerBurncard( entity player )
{
	if ( GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.KillQuota || GetGlobalNetInt( "currentMainObjective" ) == eEXTObjectives.DataRecovery )
		SendHudMessage( player, "#EXT_FOILED_JAMMER", -1, 0.4, 255, 255, 255, 255, 0.15, 3.0, 0.5 )
	else
		thread RadarJammerBurncard_Thread( player )
}

void function RadarJammerBurncard_Thread( entity player )
{
	FlagClear( "EnemySpawnerActive" )

	foreach ( entity otherPlayer in GetPlayerArrayOfTeam( TEAM_MILITIA ) )
		MessageToPlayer( otherPlayer, eEventNotifications.TEMP_VortexDefence, player )

	wait 15

	FlagSet( "EnemySpawnerActive" )
}









/*
███████ ██   ██ ████████ ██████   █████   ██████ ████████ ██  ██████  ███    ██     ██████  ██████   ██████  ██████  ███████ ██   ██ ██ ██████  
██       ██ ██     ██    ██   ██ ██   ██ ██         ██    ██ ██    ██ ████   ██     ██   ██ ██   ██ ██    ██ ██   ██ ██      ██   ██ ██ ██   ██ 
█████     ███      ██    ██████  ███████ ██         ██    ██ ██    ██ ██ ██  ██     ██   ██ ██████  ██    ██ ██████  ███████ ███████ ██ ██████  
██       ██ ██     ██    ██   ██ ██   ██ ██         ██    ██ ██    ██ ██  ██ ██     ██   ██ ██   ██ ██    ██ ██           ██ ██   ██ ██ ██      
███████ ██   ██    ██    ██   ██ ██   ██  ██████    ██    ██  ██████  ██   ████     ██████  ██   ██  ██████  ██      ███████ ██   ██ ██ ██      
*/

// Previously used the global Evac function, but had to make this custom version to support all players, remove the Epilogue announcement and leave bleeding players behind
void function ExtractionDropshipIncoming( entity evacNode, entity spaceNode )
{
	int health = 25000
	int shield = 5000
	float shipHoldTime = 15.0
	asset DROPSHIP_MODEL = $"models/vehicle/crow_dropship/crow_dropship_hero.mdl"

	entity evacIcon = CreateEntity( "info_target" )
	evacIcon.SetOrigin( evacNode.GetOrigin() )
	evacIcon.kv.spawnFlags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	DispatchSpawn( evacIcon )
	SetTargetName( evacIcon, "extractionPoint" )
	evacIcon.DisableHibernation()

	int index = GetParticleSystemIndex( FX_EVAC_MARKER )
	entity effectFriendly = StartParticleEffectInWorld_ReturnEntity( index, evacNode.GetOrigin(), < 0,0,0 > )
	SetTeam( effectFriendly, TEAM_MILITIA )
	effectFriendly.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY

	wait 0.5
	foreach ( entity player in GetPlayerArrayOfTeam( TEAM_MILITIA ) )
		Remote_CallFunction_UI( player, "SCB_SetEvacMeritState", 0 )
	
	wait file.extractionDropshipTime - WARPINFXTIME
	
	entity dropship = CreateDropship( TEAM_MILITIA, evacNode.GetOrigin(), evacNode.GetAngles() )
	dropship.SetValueForModelKey( DROPSHIP_MODEL )
	dropship.SetMaxHealth( health )
	dropship.SetHealth( dropship.GetMaxHealth() )
	dropship.SetShieldHealthMax( shield )
	dropship.SetShieldHealth( dropship.GetShieldHealthMax() )
	SetTargetName( dropship, "#NPC_EVAC_DROPSHIP" )
	DispatchSpawn( dropship )
	
	dropship.kv.VisibilityFlags = ENTITY_VISIBLE_TO_NOBODY
	HideName( dropship )
	dropship.SetModel( DROPSHIP_MODEL )
	AddEntityCallback_OnKilled( dropship, ExtractionDropshipKilled )
	
	dropship.EndSignal( "OnDestroy" )
	OnThreadEnd( function() : ( dropship ) 
	{
		if ( "evacTrigger" in dropship.s )
			dropship.s.evacTrigger.Destroy()
		
		if ( IsAlive( dropship ) )
		{
			bool dropshipEmpty = true
			foreach ( player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
			{
				if ( player.GetParent() == dropship )
					dropshipEmpty = false
			}
			
			if ( dropshipEmpty )
				SetWinner( TEAM_IMC, "#EXT_DEFEAT_MESSAGE_DROPSHIP_EMPTY", "#EXT_DEFEAT_MESSAGE_DROPSHIP_EMPTY" )
			else
				SetWinner( TEAM_MILITIA, "#EXT_VICTORY_MESSAGE_OBJECTIVE", "#EXT_VICTORY_MESSAGE_OBJECTIVE" )
		}
		else
		{
			foreach ( entity player in GetPlayerArrayOfTeam( TEAM_MILITIA ) )
				SetPlayerChallengeEvacState( player, 0 )
		}
	})
	
	Point start = GetWarpinPosition( DROPSHIP_MODEL, "cd_dropship_rescue_side_start", evacNode.GetOrigin(), evacNode.GetAngles() )
	entity fx = PlayFX( FX_GUNSHIP_CRASH_EXPLOSION_ENTRANCE, start.origin, start.angles )
	fx.FXEnableRenderAlways()
	fx.DisableHibernation()
	EmitSoundAtPosition( TEAM_UNASSIGNED, start.origin, "dropship_warpin" )
	wait 0.6

	thread PlayAnimTeleport( dropship, "cd_dropship_rescue_side_start", evacNode )
	dropship.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	ShowName( dropship )
	EmitSoundOnEntity( dropship, "Crow_MCOR_Evac_Flyin" )
	float sequenceDuration = dropship.GetSequenceDuration( "cd_dropship_rescue_side_start" )
	float cycleFrac = dropship.GetScriptedAnimEventCycleFrac( "cd_dropship_rescue_side_start", "ReadyToLoad" )
	PlayFactionDialogueToTeam( "mp_evacGoNag", TEAM_MILITIA )

	foreach ( enemy in GetNPCArrayOfTeam( TEAM_IMC ) )
	{
		enemy.ClearEnemy()
		enemy.SetEnemy( dropship )
	}
	
	wait sequenceDuration * cycleFrac
	
	SetServerVar( "gameEndTime", Time() + shipHoldTime )
	SetServerVar( "roundEndTime", Time() + shipHoldTime )
	thread PlayAnim( dropship, "cd_dropship_rescue_side_idle", evacNode )
	EmitSoundOnEntity( dropship, "Crow_MCOR_Evac_Hover" )

	if ( IsValid( effectFriendly ) )
		EffectStop( effectFriendly )

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( 200 )
	trigger.SetAboveHeight( 200 )
	trigger.SetBelowHeight( 200 )
	trigger.SetOrigin( dropship.GetOrigin() )
	trigger.SetParent( dropship, "ORIGIN" )
	DispatchSpawn( trigger )

	trigger.SetEnterCallback( void function( entity trigger, entity player ) 
	{
		if ( !player.IsPlayer() || !IsAlive( player ) || player.IsTitan() || player.ContextAction_IsBusy() || IsValid( player.GetParent() ) )
			return
		
		thread AddPlayerToExtractionDropship( trigger.GetParent(), player )
	})
	
	dropship.s.evacTrigger <- trigger
	float waitStartTime = Time()
	while ( Time() - waitStartTime < shipHoldTime )
	{
		bool everyoneOnBoard = true
		foreach ( player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
		{
			if ( StatusEffect_Get( player, eStatusEffect.bleedoutDOF ) != 0 ) // Skip players who are bleeding
				continue
			
			if ( player.GetParent() != dropship )
				everyoneOnBoard = false
		}

		if ( everyoneOnBoard )
			break
		
		WaitFrame()
	}

	StopSoundOnEntity( dropship, "Crow_MCOR_Evac_Hover" )
	EmitSoundOnEntity( dropship, "Crow_MCOR_Evac_Flyout" )
	
	foreach ( entity player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
	{
		if ( player.GetParent() == dropship )
		{
			HolsterAndDisableWeapons( player )
			player.DisableWeaponViewModel()
		}
	}
	
	dropship.Signal( "EvacShipLeaves" )
	thread PlayAnim( dropship, "cd_dropship_rescue_side_end", evacNode )
	wait dropship.GetSequenceDuration( "cd_dropship_rescue_side_end" ) - WARPINFXTIME
	
	foreach ( entity player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
		if ( player.GetParent() == dropship )
			Remote_CallFunction_NonReplay( player, "ServerCallback_PlayScreenFXWarpJump" )
	
	wait WARPINFXTIME
	dropship.kv.VisibilityFlags = ENTITY_VISIBLE_TO_NOBODY

	WaitFrame()

	if ( !IsValid( dropship ) )
		return
	
	thread __WarpOutEffectShared( dropship )

	dropship.SetOrigin( spaceNode.GetOrigin() )
	dropship.SetAngles( spaceNode.GetAngles() )
	dropship.SetInvulnerable()
	svGlobal.levelEnt.Signal( "EvacOver" )
	thread PlayAnim( dropship, "ds_space_flyby_dropshipA", spaceNode )
	
	foreach ( entity player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
	{
		if ( player.GetParent() != dropship )
		{
			if ( player.GetTeam() == dropship.GetTeam() )
				SetPlayerChallengeEvacState( player, 2 )
			continue
		}
		
		dropship.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
		HideName( dropship )
		player.SetSkyCamera( GetEnt( SKYBOXSPACE ) )
		Remote_CallFunction_NonReplay( player, "ServerCallback_DisableHudForEvac" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_SetClassicSkyScale", dropship.GetEncodedEHandle(), 0.7 )
		Remote_CallFunction_NonReplay( player, "ServerCallback_SetMapSettings", 4.0, false, 0.4, 0.125 )
		SetPlayerChallengeEvacState( player, 1 )
		
		foreach ( entity otherPlayer in GetPlayerArray() )
			Remote_CallFunction_NonReplay( otherPlayer, "ServerCallback_EvacObit", player.GetEncodedEHandle() )
	}

	int evacCount = 0
	array < entity > evacingPlayers = GetPlayerArrayOfTeam( dropship.GetTeam() )
	foreach ( entity player in evacingPlayers )
	{
		if ( player.GetParent() != dropship )
			continue
		
		evacCount++
	}

	bool allEvac = evacCount == evacingPlayers.len()
	foreach ( entity player in evacingPlayers )
	{
		if ( player.GetParent() != dropship )
			continue

		AddPlayerScore( player, "HotZoneExtract" )
		UpdatePlayerStat( player, "misc_stats", "evacsSurvived" )

		if ( allEvac )
			AddPlayerScore( player, "TeamBonusFullEvac" )
	}

	if ( evacCount == 1 && !allEvac )
		AddPlayerScore( evacingPlayers[0], "SoleSurvivor" )
}

void function AddPlayerToExtractionDropship( entity dropship, entity player ) 
{
	int slot = RandomIntRange( 0, 7 )
	UpdatePlayerStat( player, "misc_stats", "evacsAttempted" )
    dropship.EndSignal( "OnDeath", "OnDestroy" )
    player.EndSignal( "OnDestroy" )

	player.SetInvulnerable()
	player.UnforceCrouch()
	player.ForceStand()
	Remote_CallFunction_NonReplay( player, "ServerCallback_CreateDropShipIntLighting", dropship.GetEncodedEHandle(), dropship.GetTeam() )

	FirstPersonSequenceStruct fp
	fp.thirdPersonAnim = EVAC_EMBARK_ANIMS_3P[ slot ]
	fp.attachment = "RESCUE"
	fp.teleport = true
	fp.thirdPersonCameraAttachments = [ "VDU" ]

	EmitSoundOnEntityOnlyToPlayer( player, player, SHIFTER_START_SOUND_3P )
	PlayPhaseShiftDisappearFX( player )
	FirstPersonSequence( fp, player, dropship )

	FirstPersonSequenceStruct idleFp
	idleFp.firstPersonAnimIdle = EVAC_IDLE_ANIMS_1P[ slot ]
	idleFp.thirdPersonAnimIdle = EVAC_IDLE_ANIMS_3P[ slot ]
	idleFp.attachment = "RESCUE"
	idleFp.teleport = true
	idleFp.hideProxy = true
	idleFp.viewConeFunction = ViewConeWide  

	thread FirstPersonSequence( idleFp, player, dropship )
	ViewConeWide( player )
}

void function ExtractionDropshipKilled( entity dropship, var damageInfo )
{
	SetWinner( TEAM_IMC, "#EXT_DEFEAT_MESSAGE_DROPSHIP", "#EXT_DEFEAT_MESSAGE_DROPSHIP" )
	foreach ( entity player in GetPlayerArrayOfTeam_Alive( TEAM_MILITIA ) )
	{
		if ( player.GetParent() == dropship )
		{
			player.ClearParent()
			player.Die( DamageInfo_GetAttacker( damageInfo ), DamageInfo_GetWeapon( damageInfo ), { damageSourceId = eDamageSourceId.evac_dropship_explosion, scriptType = DF_GIB } )
		}
	}
}