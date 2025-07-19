untyped // Player.s stuff

global function ClGamemodeEXT_Init
global function CLExtraction_RegisterNetworkFunctions
global function ServerCallback_EXT_NewObjective
global function ServerCallback_EXT_ObjectiveComplete
global function ServerCallback_EXT_StartDropshipExtraction
global function ServerCallback_EXT_SyncSettings
global function ServerCallback_EXT_AnnounceJumpKit
global function ServerCallback_EXT_AnnounceTactical
global function ServerCallback_EXT_ShowTutorialHint
global function ServerCallback_EXT_AnnounceHazardIncrease
global function ServerCallback_EXT_PlayerRespawnRefreshIcons

struct {
	var tutorialTip
	entity jumpKitEntRef
	entity tacticalEntRef
	bool musicPlaying
	bool musicIsEnabled
	var hazardHudRui
	var inventoryIntelRui
	array<var> turretRuis
} file

const float ICON_PROXIMITY_SHOW_MINDIST = 400
const float HACK_TERMINALS_PROXIMITY_SHOW_MINDIST = 600
const float TABLET_PROXIMITY_SHOW_MINDIST = 200

table< int, bool > tutorialShown










/*
 ██████ ██      ██ ███████ ███    ██ ████████     ██ ███    ██ ██ ████████ 
██      ██      ██ ██      ████   ██    ██        ██ ████   ██ ██    ██    
██      ██      ██ █████   ██ ██  ██    ██        ██ ██ ██  ██ ██    ██    
██      ██      ██ ██      ██  ██ ██    ██        ██ ██  ██ ██ ██    ██    
 ██████ ███████ ██ ███████ ██   ████    ██        ██ ██   ████ ██    ██    
*/

void function ClGamemodeEXT_Init()
{
	RegisterLevelMusicForTeam( eMusicPieceID.LEVEL_INTRO, "music_mp_fd_intro_hard", TEAM_MILITIA )
	RegisterLevelMusicForTeam( eMusicPieceID.PVE_OBJECTIVE_START, "music_s2s_04_maltabattle_alt", TEAM_MILITIA )
	RegisterLevelMusicForTeam( eMusicPieceID.PVE_OBJECTIVE_START_FINAL, "music_skyway_12_titanhillwave03", TEAM_MILITIA )
	RegisterLevelMusicForTeam( eMusicPieceID.LEVEL_WIN, "music_mp_freeagents_outro_win", TEAM_MILITIA )
	RegisterLevelMusicForTeam( eMusicPieceID.LEVEL_DRAW, "music_mp_fd_defeat", TEAM_MILITIA )
	RegisterLevelMusicForTeam( eMusicPieceID.LEVEL_LOSS, "music_mp_fd_defeat", TEAM_MILITIA )
	RegisterLevelMusicForTeam( eMusicPieceID.LEVEL_SUDDEN_DEATH, "music_mp_pilothunt_epilogue_win", TEAM_MILITIA )

	AddCreateCallback( "prop_script", CreateCallback_PropScript )
	AddCreateCallback( "item_titan_battery", CreateCallback_BatterySpawner )
	AddCreateCallback( "prop_control_panel", CreateCallback_HackTerminal )
	AddCreateCallback( "prop_physics", CreateCallback_IntelTablet )
	AddCreateCallback( "npc_soldier", CreateCallback_HackGrunt )
	AddCreateCallback( "info_target", CreateCallback_InfoNode )
	AddCreateCallback( "npc_turret_sentry", OnTurretCreated )
	AddCreateCallback( "npc_titan", CreateCallback_Titan )

	AddEventNotificationCallback( eEventNotifications.TEMP_VortexDefence, EXT_RadarJammerUsed )

	SetGameModeScoreBarUpdateRules( GameModeScoreBarRules_EXT )

	file.tutorialTip = CreatePermanentCockpitRui( $"ui/fd_tutorial_tip.rpak", MINIMAP_Z_BASE )

	AddCallback_OnClientScriptInit( ClGamemodeEXT_OnClientScriptInit )
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )

	ScoreEvent_SetMedalText( GetScoreEvent( "FDHealingBonus" ), "#EXT_MEDAL_REVIVE_ALLY" )
	ScoreEvent_SetMedalText( GetScoreEvent( "FDTeamHeal" ), "#EXT_MEDAL_RESPAWNS" )
	ScoreEvent_SetMedalText( GetScoreEvent( "FDSupportBonus" ), "#EXT_MEDAL_JUMPKIT" )
	ScoreEvent_SetMedalText( GetScoreEvent( "FDDamageBonus" ), "#EXT_MEDAL_TACTICAL" )
	
	ScoreEvent_SetSplashText( GetScoreEvent( "FDHealingBonus" ), "#EXT_MEDAL_REVIVE_ALLY" )
	ScoreEvent_SetSplashText( GetScoreEvent( "FDTeamHeal" ), "#EXT_MEDAL_RESPAWNS" )
	ScoreEvent_SetSplashText( GetScoreEvent( "FDSupportBonus" ), "#EXT_MEDAL_JUMPKIT" )
	ScoreEvent_SetSplashText( GetScoreEvent( "FDDamageBonus" ), "#EXT_MEDAL_TACTICAL" )
}

void function ClGamemodeEXT_OnClientScriptInit( entity player )
{
	ShowPlayerHazardAndInventoryHUD()
	Minimap_DisableDraw()

	file.musicIsEnabled = !GetConVarBool( "ext_disable_overall_music" )
}

void function GameModeScoreBarRules_EXT( var rui )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	
	RuiSetInt( rui, "maxTeamScore", GetObjectiveMaxCounter() )
	RuiSetFloat( rui, "rightTeamScore", float ( GetObjectiveMaxCounter() ) )
	RuiSetFloat( rui, "leftTeamScore", float ( GetObjectiveCurrentCounter() ) )

	if ( IsValid( file.hazardHudRui ) )
		RuiSetString( file.hazardHudRui, "msgText", Localize( "#EXT_HAZARD_LEVEL" ) + GetGlobalNetInt( "hazardLevel" ) )

	if ( IsValid( file.inventoryIntelRui ) && IsValid( GetLocalViewPlayer() ) )
		RuiSetString( file.inventoryIntelRui, "msgText", Localize( "#EXT_INTEL_INVENTORY" ) + GetLocalViewPlayer().GetPlayerNetInt( "tabletInventoryCount" ) )
}

void function ShowPlayerHazardAndInventoryHUD()
{
	var hazardHudRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( hazardHudRui, "maxLines", 4 )
	RuiSetInt( hazardHudRui, "lineNum", 0 )
	RuiSetString( hazardHudRui, "msgText", "" )
	RuiSetFloat( hazardHudRui, "msgFontSize", 30.0 )
	RuiSetFloat( hazardHudRui, "msgAlpha", 0.8 )
	RuiSetFloat3( hazardHudRui, "msgColor", < 1.0, 1.0, 1.0 > )
	RuiSetFloat2( hazardHudRui, "msgPos", < 0.05, 0.2, 0.0 > )
	file.hazardHudRui = hazardHudRui

	var inventoryIntelRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( inventoryIntelRui, "maxLines", 4 )
	RuiSetInt( inventoryIntelRui, "lineNum", 1 )
	RuiSetString( inventoryIntelRui, "msgText", "" )
	RuiSetFloat( inventoryIntelRui, "msgFontSize", 30.0 )
	RuiSetFloat( inventoryIntelRui, "msgAlpha", 0.8 )
	RuiSetFloat3( inventoryIntelRui, "msgColor", < 1.0, 1.0, 1.0 > )
	RuiSetFloat2( inventoryIntelRui, "msgPos", < 0.05, 0.2, 0.0 > )
	file.inventoryIntelRui = inventoryIntelRui
}

void function CLExtraction_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_int( "currentMainObjective", UpdateExtractionStatusText )
}

void function UpdateExtractionStatusText( entity player, int old, int new, bool actuallyChanged )
{
	string statusText = "#EXT_WAITING_OBJECTIVE"
	if ( new == eEXTObjectives.DestroyHarvester )
		statusText = "#EXT_MAIN_OBJ_HARVESTER_DESTROY"
	if ( new == eEXTObjectives.GatherBatteries )
		statusText = "#EXT_MAIN_OBJ_BATTERY_QUOTA"
	if ( new == eEXTObjectives.DefendPosition )
		statusText = "#EXT_MAIN_OBJ_DEFEND_POSITION"
	if ( new == eEXTObjectives.ActivateTerminals )
		statusText = "#EXT_MAIN_OBJ_TERMINAL_ACTIVATE"
	if ( new == eEXTObjectives.DataRecovery )
		statusText = "#EXT_MAIN_OBJ_DATA_RECOVER"
	if ( new == eEXTObjectives.DataDelivery )
		statusText = "#EXT_MAIN_OBJ_DATA_DELIVER"
	if ( new == eEXTObjectives.FinalExtraction )
	{
		statusText = "#EXT_MAIN_OBJ_SURVIVE_EXTRACTION"

		var respawnDisabledRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
		RuiSetInt( respawnDisabledRui, "maxLines", 4 )
		RuiSetInt( respawnDisabledRui, "lineNum", 2 )
		RuiSetString( respawnDisabledRui, "msgText", Localize( "#EXT_RESPAWN_DISABLED" ) )
		RuiSetFloat( respawnDisabledRui, "msgFontSize", 30.0 )
		RuiSetFloat( respawnDisabledRui, "msgAlpha", 0.8 )
		RuiSetFloat3( respawnDisabledRui, "msgColor", < 1.0, 0.0, 0.0 > )
		RuiSetFloat2( respawnDisabledRui, "msgPos", < 0.05, 0.2, 0.0 > )
	}
	if ( new == eEXTObjectives.KillQuota )
		statusText = "#EXT_MAIN_OBJ_KILL_QUOTA"
	if ( new == eEXTObjectives.EliminateEliteTitan )
		statusText = "#EXT_MAIN_OBJ_KILL_ELITE_TITAN"

	ClGameState_SetInfoStatusText( statusText )
}











/*
 ██████ ██████  ███████  █████  ████████ ██  ██████  ███    ██     ███████ ██    ██ ███    ██  ██████ ███████ 
██      ██   ██ ██      ██   ██    ██    ██ ██    ██ ████   ██     ██      ██    ██ ████   ██ ██      ██      
██      ██████  █████   ███████    ██    ██ ██    ██ ██ ██  ██     █████   ██    ██ ██ ██  ██ ██      ███████ 
██      ██   ██ ██      ██   ██    ██    ██ ██    ██ ██  ██ ██     ██      ██    ██ ██  ██ ██ ██           ██ 
 ██████ ██   ██ ███████ ██   ██    ██    ██  ██████  ██   ████     ██       ██████  ██   ████  ██████ ███████ 
*/

void function CreateCallback_PropScript( entity prop )
{
	var ruiEnt
	if ( prop.GetTargetName() == "objectiveHarvester" )
	{
		ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
		RuiSetImage( ruiEnt, "icon", $"rui/menu/boosts/boost_icon_harvester" )
		RuiSetBool( ruiEnt, "isVisible", true )
		RuiSetBool( ruiEnt, "showClampArrow", true )
		RuiSetBool( ruiEnt, "pinToEdge", true )
		RuiSetFloat2( ruiEnt, "iconSize", <96,96,0> )
		RuiTrackFloat3( ruiEnt, "pos", prop, RUI_TRACK_ABSORIGIN_FOLLOW )
		thread TrackEntityDeletion( prop, ruiEnt )
	}

	if ( prop.GetTargetName() == "batteryPort" )
	{
		ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
		RuiSetImage( ruiEnt, "icon", $"rui/hud/battery/battery_generator" )
		RuiSetBool( ruiEnt, "isVisible", true )
		RuiSetBool( ruiEnt, "showClampArrow", true )
		RuiSetBool( ruiEnt, "pinToEdge", true )
		RuiSetFloat2( ruiEnt, "iconSize", <64,64,0> )
		RuiTrackFloat3( ruiEnt, "pos", prop, RUI_TRACK_OVERHEAD_FOLLOW )
		thread TrackEntityDeletion( prop, ruiEnt )
	}

	if ( prop.GetTargetName() == "weaponCrate" )
		thread TrackCrateDistance( prop )
}

void function CreateCallback_BatterySpawner( entity battery )
{
	var rui = CreateCockpitRui( $"ui/fra_battery_icon.rpak" )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiTrackFloat3( rui, "pos", battery, RUI_TRACK_OVERHEAD_FOLLOW )
	thread TrackEntityDeletion( battery, rui )
}

void function CreateCallback_HackTerminal( entity terminal )
{
	if ( terminal.GetTargetName() == "respawnTerminal" )
		thread TrackHackingTerminal( terminal, $"rui/hud/scoreboard/sb_pilot_friendly" )
	
	if ( terminal.GetTargetName() == "titanTerminal" )
		thread TrackHackingTerminal( terminal, $"rui/hud/scoreboard/sb_titan_friendly" )
}

void function CreateCallback_IntelTablet( entity tablet )
{
	if ( tablet.GetTargetName() == "intelTablet" )
		thread TrackIntelTablet( tablet )
}

void function CreateCallback_InfoNode( entity node )
{
	var ruiEnt
	if ( node.GetTargetName() == "jumpKitBank" )
	{
		thread TrackJumpKitBank( node )
		file.jumpKitEntRef = node
	}
	
	if ( node.GetTargetName() == "tacticalBank" )
	{
		thread TrackTacticalBank( node )
		file.tacticalEntRef = node
	}

	if ( node.GetTargetName() == "defensePosition" )
	{
		ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
		RuiSetImage( ruiEnt, "icon", $"rui/hud/gametype_icons/last_titan_standing/bomb_marker_friendly" )
		RuiSetBool( ruiEnt, "isVisible", true )
		RuiSetBool( ruiEnt, "showClampArrow", true )
		RuiSetBool( ruiEnt, "pinToEdge", true )
		RuiSetFloat2( ruiEnt, "iconSize", <96,96,0> )
		RuiTrackFloat3( ruiEnt, "pos", node, RUI_TRACK_OVERHEAD_FOLLOW )
		thread TrackEntityDeletion( node, ruiEnt )
	}
	
	if ( node.GetTargetName() == "interactTerminal" )
	{
		ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
		RuiSetImage( ruiEnt, "icon", $"rui/menu/common/hint_icon" )
		RuiSetBool( ruiEnt, "isVisible", true )
		RuiSetBool( ruiEnt, "showClampArrow", true )
		RuiSetBool( ruiEnt, "pinToEdge", false )
		RuiSetFloat2( ruiEnt, "iconSize", <40,40,0> )
		RuiTrackFloat3( ruiEnt, "pos", node, RUI_TRACK_ABSORIGIN_FOLLOW )
		thread TrackEntityDeletion( node, ruiEnt )
	}
	
	if ( node.GetTargetName() == "intelDeliver" )
	{
		var ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
		RuiSetImage( ruiEnt, "icon", $"rui/menu/common/bulb_hint_icon" )
		RuiSetBool( ruiEnt, "isVisible", true )
		RuiSetBool( ruiEnt, "showClampArrow", true )
		RuiSetBool( ruiEnt, "pinToEdge", true )
		RuiSetFloat2( ruiEnt, "iconSize", <96,96,0> )
		RuiTrackFloat3( ruiEnt, "pos", node, RUI_TRACK_ABSORIGIN_FOLLOW )
		thread TrackEntityDeletion( node, ruiEnt )
	}

	if ( node.GetTargetName() == "extractionPoint" )
	{
		thread CreateExtractionShipIcon_Internal( node )
		thread CreateExtractionShipWorldFX( node )
	}
}

void function CreateCallback_HackGrunt( entity grunt )
{
	if ( grunt.GetTargetName() == "hackGrunt" && grunt.GetTeam() == TEAM_MILITIA )
	{
		var ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
		RuiSetImage( ruiEnt, "icon", $"rui/hud/gametype_icons/fd/fd_icon_grunt_grey" )
		RuiSetBool( ruiEnt, "isVisible", true )
		RuiSetBool( ruiEnt, "showClampArrow", true )
		RuiSetBool( ruiEnt, "pinToEdge", false )
		RuiSetFloat2( ruiEnt, "iconSize", <48,48,0> )
		RuiTrackFloat3( ruiEnt, "pos", grunt, RUI_TRACK_OVERHEAD_FOLLOW )
		thread TrackHackerGrunt( grunt, ruiEnt )
	}
}

void function CreateCallback_Titan( entity titan )
{
	if ( titan.GetTeam() == TEAM_IMC )
	{
		if( titan.GetAISettingsName().find( "elite" ) && titan.GetTargetName() == "eliteTitan" ) //Hack for Elites overhead icons
			thread AddOverheadIcon( titan, $"rui/hud/gametype_icons/fd/fd_icon_titan_elite" )
	}
}










/*
 █████  ███    ██ ███    ██  ██████  ██    ██ ███    ██  ██████ ███████ ███    ███ ███████ ███    ██ ████████ ███████ 
██   ██ ████   ██ ████   ██ ██    ██ ██    ██ ████   ██ ██      ██      ████  ████ ██      ████   ██    ██    ██      
███████ ██ ██  ██ ██ ██  ██ ██    ██ ██    ██ ██ ██  ██ ██      █████   ██ ████ ██ █████   ██ ██  ██    ██    ███████ 
██   ██ ██  ██ ██ ██  ██ ██ ██    ██ ██    ██ ██  ██ ██ ██      ██      ██  ██  ██ ██      ██  ██ ██    ██         ██ 
██   ██ ██   ████ ██   ████  ██████   ██████  ██   ████  ██████ ███████ ██      ██ ███████ ██   ████    ██    ███████ 
*/

void function EXT_AnnounceObjective()
{
	AnnouncementData announcement = Announcement_Create( "#EXT_NEW_MAIN_OBJECTIVE" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_FD_WaveIncoming" )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_RESULTS )
	Announcement_SetTitleColor( announcement, TEAM_COLOR_FRIENDLY )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function EXT_AnnounceExtraction()
{
	AnnouncementData announcement = Announcement_Create( "#EXT_EXTRACT_INCOMING" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_FD_WaveIncoming" )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_RESULTS )
	Announcement_SetTitleColor( announcement, TEAM_COLOR_FRIENDLY )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function EXT_AnnounceObjectiveComplete()
{
	AnnouncementData announcement = Announcement_Create( "#EXT_MAIN_OBJECTIVE_COMPLETE" )
	Announcement_SetSoundAlias( announcement, "UI_InGame_CoOp_WaveSurvived" )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_BIG )
	Announcement_SetTitleColor( announcement, TEAM_COLOR_FRIENDLY )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function EXT_AnnounceHazardChange_Thread( int currentHazard )
{
	AnnouncementData announcement = Announcement_Create( Localize( "#EXT_HAZARD_LEVEL" ) + currentHazard )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_FD_WAVE_INTRO )
	Announcement_SetSubText( announcement, GetHazardDescriptionForLevel( currentHazard ) )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_FD_WaveIncoming" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	Announcement_SetOptionalTextArgsArray( announcement,  [ string( currentHazard ), string( MAX_HAZARD_LEVEL ) ] )
	Announcement_SetDuration( announcement, 12 )
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	thread EXT_AnnounceHazardChange_SFX( currentHazard, MAX_HAZARD_LEVEL )
}

void function EXT_AnnounceHazardChange_SFX( int currentHazard, int totalWaves )
{
	entity player = GetLocalClientPlayer()
	wait 1.5
	for ( int i = 0; i < totalWaves; i++ )
	{
		if ( i < currentHazard )
		{
			if ( IsAlive( player ) )
				EmitSoundOnEntity( player, "UI_InGame_FD_WaveTickGold" )
		}
		else
		{
			if ( IsAlive( player ) )
				EmitSoundOnEntity( player, "UI_InGame_FD_WaveTick" )
		}

		wait 0.15
	}
}

string function GetHazardDescriptionForLevel( int currentHazard )
{
	string hazardDescription = ""
	switch( currentHazard )
	{
		case 2:
			hazardDescription = "#EXT_HAZARD_LVL2_DESCRIPTION"
			break
		
		case 3:
			hazardDescription = "#EXT_HAZARD_LVL3_DESCRIPTION"
			break
		
		case 4:
			hazardDescription = "#EXT_HAZARD_LVL4_DESCRIPTION"
			break
		
		case 5:
			hazardDescription = "#EXT_HAZARD_LVL5_DESCRIPTION"
			break
	}

	return hazardDescription
}

void function EXT_RadarJammerUsed( entity activatingPlayer, var eventVal )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( activatingPlayer == localViewPlayer )
		SetTimedEventNotification( 3.0, "#EXT_RADAR_JAMMER_USED", activatingPlayer.GetPlayerName() )
	else if ( activatingPlayer.GetTeam() ==  localViewPlayer.GetTeam() )
		SetTimedEventNotification( 3.0, "#EXT_FRIENDLY_RADAR_JAMMER", activatingPlayer.GetPlayerName() )
}










/*
██   ██ ██    ██ ██████      ██  ██████  ██████  ███    ██ ███████ 
██   ██ ██    ██ ██   ██     ██ ██      ██    ██ ████   ██ ██      
███████ ██    ██ ██   ██     ██ ██      ██    ██ ██ ██  ██ ███████ 
██   ██ ██    ██ ██   ██     ██ ██      ██    ██ ██  ██ ██      ██ 
██   ██  ██████  ██████      ██  ██████  ██████  ██   ████ ███████ 
*/

void function TrackEntityDeletion( entity trackedEnt, var rui )
{
	trackedEnt.EndSignal( "OnDeath" )
	trackedEnt.EndSignal( "OnDestroy" )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function TrackHackerGrunt( entity grunt, var rui )
{
	clGlobal.levelEnt.EndSignal( "ObjectiveCompleted" )
	grunt.EndSignal( "OnDeath" )
	grunt.EndSignal( "OnDestroy" )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function TrackCrateDistance( entity crate )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) || player != GetLocalViewPlayer() || !IsValid( crate ) )
		return
	
	var ruiEnt
	bool createdRui
	while( IsValid( crate ) )
	{
		if ( !IsValid( player ) || player != GetLocalViewPlayer() || !IsValid( crate ) )
			break
		
		if ( Distance( crate.GetOrigin(), player.GetOrigin() ) < ICON_PROXIMITY_SHOW_MINDIST )
		{
			if ( !createdRui )
			{
				ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
				RuiSetImage( ruiEnt, "icon", $"rui/hud/common/ammo_pickup" )
				RuiSetBool( ruiEnt, "isVisible", true )
				RuiSetBool( ruiEnt, "showClampArrow", true )
				RuiSetBool( ruiEnt, "pinToEdge", true )
				RuiSetFloat2( ruiEnt, "iconSize", <96,96,0> )
				RuiTrackFloat3( ruiEnt, "pos", crate, RUI_TRACK_OVERHEAD_FOLLOW )
				createdRui = true
			}
		}
		else
		{
			if ( createdRui )
			{
				RuiDestroy( ruiEnt )
				createdRui = false
			}
		}
		WaitFrame()
	}

	if ( createdRui )
		RuiDestroy( ruiEnt )
}

void function TrackHackingTerminal( entity terminal, asset icon )
{
	entity player = GetLocalClientPlayer()
	
	if ( !IsValid( player ) || player != GetLocalViewPlayer() || !IsValid( terminal ) )
		return
	
	var ruiEnt
	bool createdRui
	while( IsValid( terminal ) && IsValid( player ) )
	{
		if ( Distance( terminal.GetOrigin(), player.GetOrigin() ) < HACK_TERMINALS_PROXIMITY_SHOW_MINDIST )
		{
			if ( !createdRui )
			{
				ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
				RuiSetImage( ruiEnt, "icon", icon )
				RuiSetBool( ruiEnt, "isVisible", true )
				RuiSetBool( ruiEnt, "showClampArrow", true )
				RuiSetBool( ruiEnt, "pinToEdge", true )
				RuiSetFloat2( ruiEnt, "iconSize", <96,96,0> )
				RuiTrackFloat3( ruiEnt, "pos", terminal, RUI_TRACK_OVERHEAD_FOLLOW )
				createdRui = true
			}
		}
		else
		{
			if ( createdRui )
			{
				RuiDestroy( ruiEnt )
				createdRui = false
			}
		}
		WaitFrame()
	}

	if ( createdRui )
		RuiDestroy( ruiEnt )
}

void function TrackIntelTablet( entity tablet )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) || player != GetLocalViewPlayer() || !IsValid( tablet ) )
		return

	var ruiEnt
	bool createdRui
	while( IsValid( tablet ) && IsValid( player ) )
	{
		if ( !IsValid( player ) || player != GetLocalViewPlayer() || !IsValid( tablet ) )
			break

		if ( Distance( tablet.GetOrigin(), player.GetOrigin() ) < TABLET_PROXIMITY_SHOW_MINDIST )
		{
			if ( !createdRui )
			{
				ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
				RuiSetImage( ruiEnt, "icon", $"rui/hud/common/objective_marker" )
				RuiSetBool( ruiEnt, "isVisible", true )
				RuiSetBool( ruiEnt, "showClampArrow", true )
				RuiSetBool( ruiEnt, "pinToEdge", true )
				RuiSetFloat2( ruiEnt, "iconSize", <96,96,0> )
				RuiTrackFloat3( ruiEnt, "pos", tablet, RUI_TRACK_ABSORIGIN_FOLLOW )
				createdRui = true
			}
		}
		else
		{
			if ( createdRui )
			{
				RuiDestroy( ruiEnt )
				createdRui = false
			}
		}
		WaitFrame()
	}

	if ( createdRui )
		RuiDestroy( ruiEnt )
}

void function TrackJumpKitBank( entity icon )
{
	entity player = GetLocalClientPlayer()

	if ( player != GetLocalViewPlayer() )
		return
	
	player.EndSignal( "OnDeath" )

	bool playerHasJumpkit = false
	var ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
	RuiSetImage( ruiEnt, "icon", $"rui/pilot_loadout/mods/jump_kit" )
	RuiSetBool( ruiEnt, "isVisible", true )
	RuiSetBool( ruiEnt, "showClampArrow", true )
	RuiSetBool( ruiEnt, "pinToEdge", true )
	RuiSetFloat2( ruiEnt, "iconSize", <128,128,0> )
	RuiTrackFloat3( ruiEnt, "pos", icon, RUI_TRACK_ABSORIGIN_FOLLOW )
	
	OnThreadEnd(
	function() : ( ruiEnt )
		{
			RuiDestroy( ruiEnt )
		}
	)

	while( !player.GetPlayerNetBool( "playerGotJumpkit" ) )
		WaitFrame()
}

void function TrackTacticalBank( entity icon )
{
	entity player = GetLocalClientPlayer()

	if ( player != GetLocalViewPlayer() )
		return
	
	player.EndSignal( "OnDeath" )
	
	var ruiEnt = CreateCockpitRui( $"ui/overhead_icon_generic.rpak", MINIMAP_Z_BASE + 200 )
	RuiSetImage( ruiEnt, "icon", GetPlayerTacticalIcon() )
	RuiSetBool( ruiEnt, "isVisible", true )
	RuiSetBool( ruiEnt, "showClampArrow", true )
	RuiSetBool( ruiEnt, "pinToEdge", true )
	RuiSetFloat2( ruiEnt, "iconSize", <160,160,0> )
	RuiTrackFloat3( ruiEnt, "pos", icon, RUI_TRACK_ABSORIGIN_FOLLOW )

	OnThreadEnd(
	function() : ( ruiEnt )
		{
			RuiDestroy( ruiEnt )
		}
	)
	
	while( !player.GetPlayerNetBool( "playerGotTactical" ) )
		WaitFrame()
}

asset function GetPlayerTacticalIcon()
{
	entity player = GetLocalClientPlayer()

	if ( player != GetLocalViewPlayer() )
		return $""

	int loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "pilot" )
	PilotLoadoutDef loadout = GetPilotLoadoutFromPersistentData( player, loadoutIndex )

	switch ( loadout.setFile )
	{
		case "pilot_medium_male":
		case "pilot_medium_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_pulse_blade"
		
		case "pilot_geist_male":
		case "pilot_geist_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_cloak"

		case "pilot_stalker_male":
		case "pilot_stalker_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_holo_pilot"
		
		case "pilot_light_male":
		case "pilot_light_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_phase_shift"
		
		case "pilot_heavy_male":
		case "pilot_heavy_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_hardcover"
		
		case "pilot_grapple_male":
		case "pilot_grapple_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_grapple"
		
		case "pilot_nomad_male":
		case "pilot_nomad_female":
			return $"rui/pilot_loadout/tactical/pilot_tactical_stim"
	}

	return $""
}

var function AddOverheadIcon( entity prop, asset icon, bool pinToEdge = true, asset ruiFile = $"ui/overhead_icon_generic.rpak" )
{
	var rui = CreateCockpitRui( ruiFile, MINIMAP_Z_BASE - 20 )
	RuiSetImage( rui, "icon", icon )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", pinToEdge )
	RuiTrackFloat3( rui, "pos", prop, RUI_TRACK_OVERHEAD_FOLLOW )

	thread AddOverheadIconThread( prop, rui )
	return rui
}

void function AddOverheadIconThread( entity prop, var rui )
{
	prop.EndSignal( "OnDestroy" )
	if ( prop.IsTitan() )
		prop.EndSignal( "OnDeath" )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	if ( prop.IsTitan() )
	{
		while ( 1 )
		{
			bool showIcon = !IsCloaked( prop )

			if ( IsValid( prop.GetTitanSoul() ) )
				showIcon = showIcon && prop.GetTitanSoul().GetTitanSoulNetBool( "showOverheadIcon" )

			RuiSetBool( rui, "isVisible", showIcon )
			wait 0.5
		}
	}

	WaitForever()
}

//Both functions below are based off the Evac code, had to duplicate in order to keep the functionality without the Evac announcement or objective override
void function CreateExtractionShipIcon_Internal( entity ent )
{
	entity player = GetLocalClientPlayer()
	var iconRui = CreateCockpitRui( $"ui/overhead_icon_evac.rpak" )
	RuiSetBool( iconRui, "isVisible", true )
	RuiTrackFloat3( iconRui, "pos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )

	OnThreadEnd(
		function() : ( iconRui )
		{
			RuiDestroy( iconRui )
		}
	)

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	float endTime = player.GetObjectiveEndTime()
	float timeToWait = endTime - Time()

	RuiSetImage( iconRui, "icon", $"rui/hud/common/evac_location_friendly" )
	RuiSetString( iconRui, "statusText", "#EVAC_ARRIVAL" )
	RuiSetGameTime( iconRui, "finishTime", endTime )

	wait timeToWait
}

void function CreateExtractionShipWorldFX( entity ent )
{
	entity player = GetLocalClientPlayer()

	int fxId = GetParticleSystemIndex( FX_EVAC_MARKER )
	player.s.rescueWorldFx <- StartParticleEffectInWorldWithHandle( fxId, ent.GetOrigin(), Vector( 0,0,1 ) )
	EffectSetControlPointVector( player.s.rescueWorldFx, 1, < 61, 211, 255 > )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( "rescueWorldFx" in player.s )
			{
				if ( EffectDoesExist( player.s.rescueWorldFx ) )
					EffectStop( player.s.rescueWorldFx, true, false )
			}
		}
	)

	float endTime = player.GetObjectiveEndTime() - 2.0
	float timeToWait = endTime - Time()
	wait timeToWait

	if ( "rescueWorldFx" in player.s )
	{
		if ( EffectDoesExist( player.s.rescueWorldFx ) )
			EffectStop( player.s.rescueWorldFx, true, false )
	}
}

void function OnTurretCreated( entity turret )
{
	thread TrackTurretKillCount( turret )
}

void function TrackTurretKillCount( entity turret )
{
	entity owner = turret.GetBossPlayer()

	var turretRui
	if ( owner == GetLocalViewPlayer() )
	{
		turretRui = CreateCockpitRui( $"ui/turret_hud_status.rpak" )
		file.turretRuis.append( turretRui )
		UpdateTurretRuiIndeces()
	}

	var rui = CreateCockpitRui( $"ui/turret_kill_tracker.rpak", 0 )
	RuiSetBool( rui, "isMine", ( owner == GetLocalViewPlayer() ) )
	RuiTrackFloat3( rui, "pos", turret, RUI_TRACK_ABSORIGIN_FOLLOW )
	turret.EndSignal( "OnDeath" )
	OnThreadEnd(
		function () : ( rui, turretRui )
		{
			RuiDestroy( rui )

			if ( IsValid( turretRui ) )
			{
				file.turretRuis.fastremovebyvalue( turretRui )
				RuiDestroy( turretRui )
			}


			UpdateTurretRuiIndeces()
		}
	)

	while( IsValid( turret ) )
	{
		int killCount = int( turret.kv.killCount )
		if ( IsValid( turretRui ) )
		{
			RuiSetInt( turretRui, "killCount", killCount )
			RuiSetBool( turretRui, "isOnline", turret.GetHealth() > 1 )
		}
		RuiSetBool( rui, "isOnline", turret.GetHealth() > 1 )
		RuiSetInt( rui, "killCount", killCount )
		wait 0.1
	}
}

void function UpdateTurretRuiIndeces()
{
	for ( int i=0; i<file.turretRuis.len(); i++ )
	{
		RuiSetInt( file.turretRuis[i], "index", i )
	}
}










/*
███████ ███████ ██████  ██    ██ ███████ ██████       ██████  █████  ██      ██      ██████   █████   ██████ ██   ██ ███████ 
██      ██      ██   ██ ██    ██ ██      ██   ██     ██      ██   ██ ██      ██      ██   ██ ██   ██ ██      ██  ██  ██      
███████ █████   ██████  ██    ██ █████   ██████      ██      ███████ ██      ██      ██████  ███████ ██      █████   ███████ 
     ██ ██      ██   ██  ██  ██  ██      ██   ██     ██      ██   ██ ██      ██      ██   ██ ██   ██ ██      ██  ██       ██ 
███████ ███████ ██   ██   ████   ███████ ██   ██      ██████ ██   ██ ███████ ███████ ██████  ██   ██  ██████ ██   ██ ███████ 
*/

void function ServerCallback_EXT_SyncSettings()
{
	if( !file.musicPlaying && GamePlaying() && GetNetworkedVariableIndex( "currentMainObjective" ) != 0 && file.musicIsEnabled )
	{
		StopMusic()
		if ( GetNetworkedVariableIndex( "currentMainObjective" ) == eEXTObjectives.FinalExtraction ) 
			thread ForceLoopMusic_DEPRECATED( eMusicPieceID.PVE_OBJECTIVE_START_FINAL )
		else
			thread ForceLoopMusic_DEPRECATED( eMusicPieceID.PVE_OBJECTIVE_START )
		
		file.musicPlaying = true
	}
}

void function ServerCallback_EXT_NewObjective()
{
	if( !file.musicPlaying && file.musicIsEnabled )
	{
		StopMusic() 
		thread ForceLoopMusic_DEPRECATED( eMusicPieceID.PVE_OBJECTIVE_START )
		file.musicPlaying = true
	}

	EXT_AnnounceObjective()
}

void function ServerCallback_EXT_StartDropshipExtraction()
{
	if ( file.musicIsEnabled )
	{
		StopMusic() 
		thread ForceLoopMusic_DEPRECATED( eMusicPieceID.PVE_OBJECTIVE_START_FINAL )
	}

	EXT_AnnounceExtraction()
}

void function ServerCallback_EXT_AnnounceHazardIncrease( int hazardLevel )
{
	thread EXT_AnnounceHazardChange_Thread( hazardLevel )
}

void function ServerCallback_EXT_ObjectiveComplete()
{
	clGlobal.levelEnt.Signal( "ObjectiveCompleted" )
	EXT_AnnounceObjectiveComplete()
}

void function ServerCallback_EXT_AnnounceJumpKit()
{
	AnnouncementMessagePVEObjective( GetLocalViewPlayer(), "#EXT_JUMPKIT_EARNED", "#EXT_JUMPKIT_SUBTITLE", < 1, 1, 1 >, $"rui/pilot_loadout/mods/jump_kit", "pilot_collectible_pickup" )
}

void function ServerCallback_EXT_AnnounceTactical()
{
	AnnouncementMessagePVEObjective( GetLocalViewPlayer(), "#EXT_TACTICAL_EARNED", "#EXT_TACTICAL_SUBTITLE", < 1, 1, 1 >, GetPlayerTacticalIcon(), "pilot_collectible_pickup" )
}

void function ServerCallback_EXT_PlayerRespawnRefreshIcons()
{
	Minimap_DisableDraw()

	if ( IsValid( file.jumpKitEntRef ) )
		thread TrackJumpKitBank( file.jumpKitEntRef )
		
	if ( IsValid( file.tacticalEntRef ) )
		thread TrackTacticalBank( file.tacticalEntRef )
}









/*
████████ ██    ██ ████████  ██████  ██████  ██  █████  ██      ███████ 
   ██    ██    ██    ██    ██    ██ ██   ██ ██ ██   ██ ██      ██      
   ██    ██    ██    ██    ██    ██ ██████  ██ ███████ ██      ███████ 
   ██    ██    ██    ██    ██    ██ ██   ██ ██ ██   ██ ██           ██ 
   ██     ██████     ██     ██████  ██   ██ ██ ██   ██ ███████ ███████ 
*/

void function ServerCallback_EXT_ShowTutorialHint( int tutorialID )
{
	entity player = GetLocalClientPlayer()
	
	if ( tutorialID in tutorialShown )
	{
		if ( tutorialShown[tutorialID] )
			return
	}
	
	asset backgroundImage = $""
	asset tipIcon = $""
	string tipTitle = ""
	string tipDesc = ""

	switch ( tutorialID )
	{
		case eEXTTutorials.SurviveStart:
			tipTitle = "#EXT_TUTORIAL_START_TITLE"
			tipDesc = "#EXT_TUTORIAL_START_DESC"
			backgroundImage = $"rui/callsigns/callsign_95_col"
			break
		
		case eEXTTutorials.Objectives:
			tipTitle = "#EXT_TUTORIAL_OBJECTIVES_TITLE"
			tipDesc = "#EXT_TUTORIAL_OBJECTIVES_DESC"
			backgroundImage = $"rui/callsigns/callsign_96_col"
			break
		
		case eEXTTutorials.WeaponsAndGear:
			tipTitle = "#EXT_TUTORIAL_WEAPONS_TITLE"
			tipDesc = "#EXT_TUTORIAL_WEAPONS_DESC"
			backgroundImage = $"rui/callsigns/callsign_10_col"
			break
		
		case eEXTTutorials.PlayerDied:
			tipTitle = "#EXT_TUTORIAL_RSPWN_TITLE"
			tipDesc = "#EXT_TUTORIAL_RSPWN_DESC"
			backgroundImage = $"rui/callsigns/callsign_39_col"
			break
		
		case eEXTTutorials.HazardScaling:
			tipTitle = "#EXT_TUTORIAL_HAZARD_TITLE"
			tipDesc = "#EXT_TUTORIAL_HAZARD_DESC"
			backgroundImage = $"rui/callsigns/callsign_30_col"
			break
		
		case eEXTTutorials.RobotBanks:
			tipTitle = "#EXT_TUTORIAL_ROBOBANK_TITLE"
			tipDesc = "#EXT_TUTORIAL_ROBOBANK_DESC"
			backgroundImage = $"rui/menu/gametype_select/hardpoint"
			break
		
		case eEXTTutorials.ScoreBars:
			tipTitle = "#EXT_TUTORIAL_SCOREBARS_TITLE"
			tipDesc = "#EXT_TUTORIAL_SCOREBARS_DESC"
			backgroundImage = $"rui/menu/main_menu/spotlight_13"
			break
		
		case eEXTTutorials.TerminalHacking:
			tipTitle = "#EXT_TUTORIAL_TERMINAL_HACK_TITLE"
			tipDesc = "#EXT_TUTORIAL_TERMINAL_HACK_DESC"
			backgroundImage = $"rui/callsigns/callsign_97_col"
			break
		
		case eEXTTutorials.TitanLimit:
			tipTitle = "#EXT_TUTORIAL_TITAN_LIMIT_TITLE"
			tipDesc = "#EXT_TUTORIAL_TITAN_LIMIT_DESC"
			backgroundImage = $"rui/callsigns/callsign_94_col"
			break
		
		default:
			return
	}
	
	if ( !( tutorialID in tutorialShown ) )
		tutorialShown[tutorialID] <- true

	EXTDisplayTutorialTip( backgroundImage, tipIcon, tipTitle, tipDesc )
}

void function EXTDisplayTutorialTip( asset backgroundImage, asset tipIcon, string tipTitle, string tipDesc )
{
	RuiSetImage( file.tutorialTip, "backgroundImage", backgroundImage )
	RuiSetImage( file.tutorialTip, "iconImage", tipIcon )
	RuiSetString( file.tutorialTip, "titleText", tipTitle )
	RuiSetString( file.tutorialTip, "descriptionText", tipDesc )
	RuiSetGameTime( file.tutorialTip, "updateTime", Time() )
	RuiSetFloat( file.tutorialTip, "duration", 10.0 )
	thread EXTTutorialTipSounds()
}

void function EXTTutorialTipSounds()
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDestroy" )

	EmitSoundOnEntity( player, "UI_InGame_FD_InfoCardSlideIn"  )
	wait 6.0
	EmitSoundOnEntity( player, "UI_InGame_FD_InfoCardSlideOut" )
}