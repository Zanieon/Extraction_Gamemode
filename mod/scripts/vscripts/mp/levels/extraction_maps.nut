global function Extraction_InitMaps

void function Extraction_InitMaps()
{
	if( IsLobby() || GameRules_GetGameMode() != GAMEMODE_EXT )
		return
	
	switch ( GetMapName() )
	{
		case "mp_forwardbase_kodai":
			SetupExtractionMap( ExecKodaiExtraction )
			break
		case "mp_angel_city":
			SetupExtractionMap( ExecAngelCityExtraction )
			break
		case "mp_black_water_canal":
			SetupExtractionMap( ExecBWCExtraction )
			break
		case "mp_thaw":
			SetupExtractionMap( ExecExoplanetExtraction )
			break
		case "mp_drydock":
			SetupExtractionMap( ExecDrydockExtraction )
			break
		case "mp_eden":
			SetupExtractionMap( ExecEdenExtraction )
			break
		case "mp_wargames":
			SetupExtractionMap( ExecWarGamesExtraction )
			break
		case "mp_colony02":
			SetupExtractionMap( ExecColonyExtraction )
			break
		case "mp_relic02":
			SetupExtractionMap( ExecRelicExtraction )
			break
		case "mp_grave":
			SetupExtractionMap( ExecBoomtownExtraction )
			break
		case "mp_rise":
			SetupExtractionMap( ExecRiseExtraction )
			break
		default:
			throw( "The map selected has no support for Extraction gamemode" )
	}
}

void function ExecKodaiExtraction()
{
	Extraction_PlaceRespawnTerminal( < -2944, -260, 1164 >, < 0, 180, 0 > )
	Extraction_PlaceTitanTerminal( < 2069, -2156, 984 >, < 0, 180, 0 > )

	Extraction_AddExtractionPoint( < -1272, -2140, 1188 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < 1865, 3309, 1341 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < -602, -1167, 1235 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < -315, 3773, 1363 >, < 0, 90, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < 747, -2031, 998 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -697, -2031, 998 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -933, 77, 961 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -754, 1058, 960 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -572, 2530, 1095 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1164, 2984, 1116 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1172, 1004, 959 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 729, 286, 963 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1137, -376, 960 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1145, 3087, 984 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 986, 1928, 960 > )

	Extraction_PlaceWeaponCrate( < -338, 2929, 1095 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 1411, 2909, 1099 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 2829, -536, 947 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 621, -2535, 951 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -792, 541, 960 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 1438, 959, 960 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -3000, 1057, 1039 >, < 0, 180, 0 > )

	Extraction_PlaceRobotBank( < -848, -1892, 952 > )
	Extraction_PlaceRobotBank( < 1256, 185, 1095 > )
	Extraction_PlaceRobotBank( < 642, 1684, 960 > )
	Extraction_PlaceRobotBank( < -1333, 3286, 957 > )
	Extraction_PlaceRobotBank( < -947, 1397, 1096 > )
	Extraction_PlaceRobotBank( < 2475, 3570, 992 > )
	Extraction_PlaceRobotBank( < 2144, -1982, 794 > )

	Extraction_PlaceTerminalInteractor( < 1185, 902, 1144 > )
	Extraction_PlaceTerminalInteractor( < -966, 430, 1142 > )
	Extraction_PlaceTerminalInteractor( < 2660, -544, 990 > )
	Extraction_PlaceTerminalInteractor( < -491, 3280, 1135 > )
	Extraction_PlaceTerminalInteractor( < -1357, 616, 1142 > )
	Extraction_PlaceTerminalInteractor( < 1361, 1080, 1146 > )
	Extraction_PlaceTerminalInteractor( < -490, 3360, 1134 > )
	Extraction_PlaceTerminalInteractor( < -945, 1064, 1143 > )
	Extraction_PlaceTerminalInteractor( < 2659, -331, 991 > )

	Extraction_PlaceBatterySpot( < -459, -1883, 815 > )
	Extraction_PlaceBatterySpot( < 1158, 841, 959 > )
	Extraction_PlaceBatterySpot( < 2022, -2101, 788 > )
	Extraction_PlaceBatterySpot( < -1241, 845, 1096 > )
	Extraction_PlaceBatterySpot( < 1406, 3246, 1099 > )
	Extraction_PlaceBatterySpot( < -294, 1273, 960 > )
	Extraction_PlaceBatterySpot( < -2990, 571, 1158 > )

	Extraction_PlaceHackStation( < 1099, 1658, 970 > )
	Extraction_PlaceHackStation( < -320, 2239, 968 > )
	Extraction_PlaceHackStation( < 690, -1971, 960 > )
}

void function ExecAngelCityExtraction()
{
	Extraction_PlaceRespawnTerminal( < 3764, 92, 320 >, < 0, 0, 0 > )
	Extraction_PlaceTitanTerminal( < -2071, 4693, 348 >, < 0, -15, 0 > )

	Extraction_AddExtractionPoint( < -2971, 1940, 424 >, < 0, -105, 0 > )
	Extraction_AddExtractionPoint( < -86, 2636, 546 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 2276, 1862, 444 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < 235, -2077, 411 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < -2909, -116, 510 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 2835, -2040, 487 >, < 0, 90, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < -149, 1929, 164 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1423, 1861, 207 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 51, 3265, 208 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1154, 3265, 208 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1064, 4038, 316 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -2352, 2501, 265 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -3521, 2841, 128 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -3014, 327, 176 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1608, 1018, 148 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1564, -904, 263 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1459, 973, 127 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2863, -2647, 202 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 71, -160, 128 > )

	Extraction_PlaceWeaponCrate( < -942, 4459, 316 >, < 0, 165, 0 > )
	Extraction_PlaceWeaponCrate( < -2050, 2602, 266 >, < 0, 75, 0 > )
	Extraction_PlaceWeaponCrate( < -3318, 3857, 136 >, < 0, 165, 0 > )
	Extraction_PlaceWeaponCrate( < -3935, 1702, 168 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -2945, 301, 176 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -1479, 762, 148 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -175, 1653, 264 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 1021, 915, 304 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 1317, -953, 264 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 1696, -2882, 359 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < -755, -332, 264 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 164, -166, 128 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 403, 3154, 206 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 3610, -2432, 208 >, < 0, -90, 0 > )

	Extraction_PlaceRobotBank( < -3434, 3603, 136 > )
	Extraction_PlaceRobotBank( < -1732, 2076, 263 > )
	Extraction_PlaceRobotBank( < -109, 2247, 400 > )
	Extraction_PlaceRobotBank( < 1420, 1666, 312 > )
	Extraction_PlaceRobotBank( < 1341, -3065, 207 > )
	Extraction_PlaceRobotBank( < -130, -1111, 128 > )
	Extraction_PlaceRobotBank( < -1819, 1055, 148 > )
	Extraction_PlaceRobotBank( < -4300, 1518, 168 > )

	Extraction_PlaceTerminalInteractor( < 2898, -2937, 264 > )
	Extraction_PlaceTerminalInteractor( < 1690, -866, 331 > )
	Extraction_PlaceTerminalInteractor( < 2600, -790, 270 > )
	Extraction_PlaceTerminalInteractor( < 1410, 663, 191 > )
	Extraction_PlaceTerminalInteractor( < -19, 2935, 268 > )
	Extraction_PlaceTerminalInteractor( < -810, 3701, 232 > )
	Extraction_PlaceTerminalInteractor( < -3486, 3008, 342 > )
	Extraction_PlaceTerminalInteractor( < -245, 1621, 320 > )
	Extraction_PlaceTerminalInteractor( < 21, 2255, 322 > )
	Extraction_PlaceTerminalInteractor( < 1092, 152, 185 > )

	Extraction_PlaceBatterySpot( < 1672, -2992, 207 > )
	Extraction_PlaceBatterySpot( < 3112, -519, 202 > )
	Extraction_PlaceBatterySpot( < 1135, 746, 304 > )
	Extraction_PlaceBatterySpot( < 1781, -1228, 264 > )
	Extraction_PlaceBatterySpot( < -1694, 679, 148 > )
	Extraction_PlaceBatterySpot( < -2181, 2620, 265 > )
	Extraction_PlaceBatterySpot( < -113, 1576, 400 > )
	Extraction_PlaceBatterySpot( < -3707, 2921, 295 > )
	Extraction_PlaceBatterySpot( < -2800, 327, 176 > )

	Extraction_PlaceHackStation( < 1300, 1536, 320 > )
	Extraction_PlaceHackStation( < -3127, 418, 184 > )
	Extraction_PlaceHackStation( < 227, -286, 136 > )
	Extraction_PlaceHackStation( < -3688, 2915, 135 > )
}

void function ExecBWCExtraction()
{
	Extraction_PlaceRespawnTerminal( < 909, -3434, -188 >, < 0, -45, 0 > )
	Extraction_PlaceTitanTerminal( < -992, 3425, -128 >, < 0, -90, 0 > )

	Extraction_AddExtractionPoint( < -476, 2430, 159 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < 1151, 2250, 255 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 3367, -3863, 214 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 2311, -2662, 288 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < 1589, -1268, 361 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 2003, 2102, 238 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < 2003, 2102, 238 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < -707, -1190, 368 >, < 0, 180, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < -1111, 1607, -123 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 332, 3556, -257 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2614, 2053, -30 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1154, 1781, -128 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1127, 3384, -252 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -490, 464, 128 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1525, 625, 64 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1400, -807, 0 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2266, -1052, -64 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 3205, -2063, -127 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 3417, -3266, 8 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1587, -2564, -127 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -220, -1243, 0 > )

	Extraction_PlaceWeaponCrate( < 1410, 4830, -127 >, < 0, 225, 0 > )
	Extraction_PlaceWeaponCrate( < 934, 3383, -257 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -1142, 3212, -252 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -1035, 1268, -119 >, < 0, 45, 0 > )
	Extraction_PlaceWeaponCrate( < 1259, 1793, -127 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 2336, 2083, -29 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 1540, -509, 64 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < -519, -1229, 0 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 1223, 501, 63 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 3764, -3344, -124 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 1606, -2230, 0 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -242, 367, 128 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 3333, -2013, -127 >, < 0, 180, 0 > )

	Extraction_PlaceRobotBank( < 3821, -3248, 8 > )
	Extraction_PlaceRobotBank( < 958, -2409, -127 > )
	Extraction_PlaceRobotBank( < -594, 440, 128 > )
	Extraction_PlaceRobotBank( < 152, 2239, -128 > )
	Extraction_PlaceRobotBank( < 2867, 2278, -31 > )
	Extraction_PlaceRobotBank( < 2296, -1056, -64 > )
	Extraction_PlaceRobotBank( < -1413, 2401, -5 > )

	Extraction_PlaceTerminalInteractor( < 1530, 4430, -89 > )
	Extraction_PlaceTerminalInteractor( < -65, 3940, -219 > )
	Extraction_PlaceTerminalInteractor( < 452, 1367, 317 > )
	Extraction_PlaceTerminalInteractor( < -892, 1765, 31 > )
	Extraction_PlaceTerminalInteractor( < -892, 1765, 31 > )

	Extraction_PlaceBatterySpot( < 1343, 577, 63 > )
	Extraction_PlaceBatterySpot( < 3040, -1898, -64 > )
	Extraction_PlaceBatterySpot( < 1841, -2638, -167 > )
	Extraction_PlaceBatterySpot( < 1255, 1943, -127 > )
	Extraction_PlaceBatterySpot( < -1181, 3385, -251 > )
	Extraction_PlaceBatterySpot( < 1549, 4727, -128 > )

	Extraction_PlaceHackStation( < -1288, 1608, -116 > )
	Extraction_PlaceHackStation( < -158, -1347, 8 > )
	Extraction_PlaceHackStation( < 1866, -938, -60 > )
	Extraction_PlaceHackStation( < 2489, 2009, -22 > )
	Extraction_PlaceHackStation( < 399, 3261, -121 > )
}

void function ExecExoplanetExtraction()
{
	foreach ( podPoint in SpawnPoints_GetDropPod() ) //Trim OOB spawns from FD pods
	{
		if ( Distance2D( podPoint.GetOrigin(), < -4528, 4095, 166 > ) < 2000 )
			podPoint.Destroy()
		else if ( Distance2D( podPoint.GetOrigin(), < -1770, 6094, 166 > ) < 2000 )
			podPoint.Destroy()
	}

	Extraction_PlaceRespawnTerminal( < 3266, -3896, -287 >, < 0, 145, 0 > )
	Extraction_PlaceTitanTerminal( < -622, 2490, -314 >, < 0, -65, 0 > )

	Extraction_AddExtractionPoint( < -889, 806, 64 >, < 0, -110, 0 > )
	Extraction_AddExtractionPoint( < 1291, -1493, 225 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 1281, -3978, 136 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < -520, -2768, 128 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 196, -1401, 64 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < 2492, -3191, 144 >, < 0, 0, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < -902, -744, -319 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -799, -1529, -319 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1280, -4741, -207 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 905, -2591, -255 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1802, -3064, -255 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1476, -787, -16 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1061, -167, -191 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -619, 1477, -319 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 3093, 1800, -64 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -553, -3195, -108 > )

	Extraction_PlaceWeaponCrate( < 2057, -2673, -255 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 1381, -1137, -224 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 829, -61, -192 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 2812, 2182, -287 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -574, -862, -191 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -895, -2016, -319 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -234, -2953, -108 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 1276, -5440, -143 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 405, -2694, -63 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -696, 1304, -159 >, < 0, 157.5, 0 > )
	Extraction_PlaceWeaponCrate( < 1164, 933, -162 >, < 0, 0, 0 > )

	Extraction_PlaceRobotBank( < -1022, -1625, -319 > )
	Extraction_PlaceRobotBank( < 1138, -594, -224 > )
	Extraction_PlaceRobotBank( < -408, 1736, -319 > )
	Extraction_PlaceRobotBank( < 650, -2512, -224 > )
	Extraction_PlaceRobotBank( < 1275, -5315, -143 > )
	Extraction_PlaceRobotBank( < 2953, -3750, -288 > )

	Extraction_PlaceTerminalInteractor( < -1238, -1310, -267 > )
	Extraction_PlaceTerminalInteractor( < 1217, -528, -166 > )
	Extraction_PlaceTerminalInteractor( < 3175, 1679, -20 > )
	Extraction_PlaceTerminalInteractor( < 2182, -2244, -204 > )
	Extraction_PlaceTerminalInteractor( < -310, -1535, -114 > )
	Extraction_PlaceTerminalInteractor( < -601, -1354, -125 > )
	Extraction_PlaceTerminalInteractor( < -692, 969, -98 > )
	Extraction_PlaceTerminalInteractor( < 1308, -528, 2 > )
	Extraction_PlaceTerminalInteractor( < 1771, -3503, -190 > )
	Extraction_PlaceTerminalInteractor( < 1168, -5167, -60 > )
	Extraction_PlaceTerminalInteractor( < 1388, -5167, -60 > )

	Extraction_PlaceBatterySpot( < 1938, -2949, -255 > )
	Extraction_PlaceBatterySpot( < -513, -3163, -107 > )
	Extraction_PlaceBatterySpot( < -302, -1388, -159 > )
	Extraction_PlaceBatterySpot( < -975, 1081, -160 > )
	Extraction_PlaceBatterySpot( < 1442, -605, -15 > )
	Extraction_PlaceBatterySpot( < 2891, 1581, -64 > )

	Extraction_PlaceHackStation( < -1022, -1120, -311 > )
	Extraction_PlaceHackStation( < 1982, -2339, -248 > )
	Extraction_PlaceHackStation( < 2979, 1793, -56 > )
	Extraction_PlaceHackStation( < 1279, -4786, -199 > )
}

void function ExecDrydockExtraction()
{
	foreach ( podPoint in SpawnPoints_GetDropPod() ) //Trim OOB spawns from FD pods
	{
		if ( Distance2D( podPoint.GetOrigin(), < 2759, -5899, 338 > ) < 2000 )
			podPoint.Destroy()
		else if ( Distance2D( podPoint.GetOrigin(), < 0, -6841, 338 > ) < 2000 )
			podPoint.Destroy()
	}

	Extraction_PlaceRespawnTerminal( < -2262, 151, 295 >, < 0, 180, 0 > )
	Extraction_PlaceTitanTerminal( < 3393, 326, 255 >, < 0, 180, 0 > )

	Extraction_AddExtractionPoint( < 1800, -2584, 447 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 3020, 370, 497 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < -416, 3019, 516 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 1322, 3163, 535 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 69, 2582, 472 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 2377, -1895, 319 >, < 0, 0, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < 362, -1851, 279 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1003, 60, 320 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1271, -103, 256 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1866, 414, 256 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1918, 2097, 256 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -415, 3594, 231 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1209, 3609, 96 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 411, 2075, 263 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 800, 925, 408 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -353, -618, 410 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -617, 839, 408 > )

	Extraction_PlaceWeaponCrate( < -413, 3652, 231 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 1068, 3835, 97 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 748, -1918, 416 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 938, -679, 416 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -1345, -737, 408 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -191, -4200, 144 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 1747, 2503, 259 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 468, 1952, 264 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -381, 629, 407 >, < 0, -90, 0 > )

	Extraction_PlaceRobotBank( < 1682, -2035, 241 > )
	Extraction_PlaceRobotBank( < -982, -2224, 407 > )
	Extraction_PlaceRobotBank( < -1418, 2018, 232 > )
	Extraction_PlaceRobotBank( < 1258, 3580, 95 > )
	Extraction_PlaceRobotBank( < 1785, 1661, 255 > )
	Extraction_PlaceRobotBank( < 436, 946, 408 > )
	Extraction_PlaceRobotBank( < 16, -816, 412 > )

	Extraction_PlaceTerminalInteractor( < 1500, 316, 304 > )
	Extraction_PlaceTerminalInteractor( < 1500, 360, 304 > )
	Extraction_PlaceTerminalInteractor( < 1500, 272, 304 > )
	Extraction_PlaceTerminalInteractor( < -545, 3511, 278 > )
	Extraction_PlaceTerminalInteractor( < -634, 344, 449 > )
	Extraction_PlaceTerminalInteractor( < -1053, 344, 365 > )
	Extraction_PlaceTerminalInteractor( < 236, -1763, 326 > )
	Extraction_PlaceTerminalInteractor( < -768, -782, 449 > )
	Extraction_PlaceTerminalInteractor( < -1071, -511, 449 > )

	Extraction_PlaceBatterySpot( < 467, -1654, 416 > )
	Extraction_PlaceBatterySpot( < 1827, 2328, 256 > )
	Extraction_PlaceBatterySpot( < -902, 809, 408 > )
	Extraction_PlaceBatterySpot( < -42, -4003, 144 > )
	Extraction_PlaceBatterySpot( < -923, 3631, 183 > )
	Extraction_PlaceBatterySpot( < 1912, -232, 256 > )

	Extraction_PlaceHackStation( < 127, 3774, 239 > )
	Extraction_PlaceHackStation( < -1189, 80, 328 > )
	Extraction_PlaceHackStation( < 1768, 316, 263 > )
}

void function ExecEdenExtraction()
{
	Extraction_PlaceRespawnTerminal( < -2482, -2466, 79 >, < 0, 90, 0 > )
	Extraction_PlaceTitanTerminal( < 2528, 3387, 120 >, < 0, -90, 0 > )

	Extraction_AddExtractionPoint( < 2498, -138, 463 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 2173, -1900, 440 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < -1333, 1723, 522 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < -1744, -445, 465 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 5076, -168, 603 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < 3431, -1444, 416 >, < 0, -90, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < -992, -693, 208 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -414, 572, 72 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1492, 2665, 167 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1983, 882, 48 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1892, 1450, 208 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 540, 526, 67 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1854, 337, 80 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 3065, 110, 72 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 3315, -1052, 218 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1888, -2297, 72 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1645, -849, 68 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2580, 3166, 119 > )

	Extraction_PlaceWeaponCrate( < 2021, -2129, 207 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 3553, -1140, 80 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 1948, 350, 56 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 342, 275, 72 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 431, -1376, 66 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -1315, -852, 208 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 1854, 1352, 207 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 2739, 3006, 119 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -2148, 1082, 76 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -1733, 2749, 305 >, < 0, -90, 0 > )

	Extraction_PlaceRobotBank( < -906, -523, 208 > )
	Extraction_PlaceRobotBank( < -1548, 2382, 305 > )
	Extraction_PlaceRobotBank( < 1546, -2504, 72 > )
	Extraction_PlaceRobotBank( < 4304, -290, 71 > )
	Extraction_PlaceRobotBank( < 559, 1727, 140 > )
	Extraction_PlaceRobotBank( < -417, 858, 72 > )
	Extraction_PlaceRobotBank( < 623, -1182, 65 > )

	Extraction_PlaceTerminalInteractor( < -2341, -1032, 142 > )
	Extraction_PlaceTerminalInteractor( < -1194, -663, 278 > )
	Extraction_PlaceTerminalInteractor( < -1101, -624, 249 > )
	Extraction_PlaceTerminalInteractor( < 1518, -1194, 131 > )
	Extraction_PlaceTerminalInteractor( < -1193, 2570, 214 > )
	Extraction_PlaceTerminalInteractor( < -1507, 2765, 338 > )
	Extraction_PlaceTerminalInteractor( < 471, 1810, 194 > )
	Extraction_PlaceTerminalInteractor( < 644, 1810, 194 > )
	Extraction_PlaceTerminalInteractor( < 2860, 3021, 166 > )
	Extraction_PlaceTerminalInteractor( < 1631, 1612, 254 > )
	Extraction_PlaceTerminalInteractor( < 1631, 1496, 254 > )
	Extraction_PlaceTerminalInteractor( < 1768, 1514, 274 > )
	Extraction_PlaceTerminalInteractor( < 1827, 1302, 250 > )
	Extraction_PlaceTerminalInteractor( < 2028, 1542, 274 > )
	Extraction_PlaceTerminalInteractor( < 1822, 1433, 274 > )
	Extraction_PlaceTerminalInteractor( < 1067, -646, 123 > )
	Extraction_PlaceTerminalInteractor( < -1113, -865, 245 > )
	Extraction_PlaceTerminalInteractor( < -1433, -718, 245 > )

	Extraction_PlaceBatterySpot( < 1457, -2503, 200 > )
	Extraction_PlaceBatterySpot( < 1922, 1484, 208 > )
	Extraction_PlaceBatterySpot( < -2213, 3037, 144 > )
	Extraction_PlaceBatterySpot( < -2452, -926, 72 > )
	Extraction_PlaceBatterySpot( < 3441, -1057, 218 > )
	Extraction_PlaceBatterySpot( < 2937, -16, 72 > )
	Extraction_PlaceBatterySpot( < 705, 917, 72 > )

	Extraction_PlaceHackStation( < -1308, 2758, 176 > )
	Extraction_PlaceHackStation( < 1437, -1095, 76 > )
	Extraction_PlaceHackStation( < 1714, 1148, 216 > )
	Extraction_PlaceHackStation( < -177, 232, 80 > )
}

void function ExecWarGamesExtraction()
{
	foreach ( spawnPoint in SpawnPoints_GetPilot() ) // Theres a building which grunts spawns too near walls and cant move
	{
		if ( Distance2D( spawnPoint.GetOrigin(), < -2191, 522, 117 > ) < 300 )
			spawnPoint.Destroy()
	}

	Extraction_PlaceRespawnTerminal( < 2044, -1136, 112 >, < 0, 0, 0 > )
	Extraction_PlaceTitanTerminal( < -1278, -2004, 263 >, < 0, -90, 0 > )

	Extraction_AddExtractionPoint( < -3610, -248, 240 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < -3623, 1509, 392 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < 1868, 1325, 167 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < -1523, 2401, 135 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 553, -1327, 317 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < -9, -1336, 317 >, < 0, 180, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < 1233, -1494, 40 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1828, -259, 112 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -361, -3, -23 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1417, -71, -24 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -3168, -84, -128 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -2745, 1408, -127 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1092, 1662, -127 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -736, -1673, 63 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -736, -1673, 63 > )

	Extraction_PlaceWeaponCrate( < -3022, 995, 112 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -2985, -388, -127 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -251, 1373, 111 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 1718, 661, 63 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -1514, 17, -23 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 1419, -834, 39 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < -1135, -1942, 0 >, < 0, 0, 0 > )

	Extraction_PlaceRobotBank( < -664, 1777, -127 > )
	Extraction_PlaceRobotBank( < 1820, -1089, -64 > )
	Extraction_PlaceRobotBank( < -424, -221, -23 > )
	Extraction_PlaceRobotBank( < -1115, -524, -127 > )
	Extraction_PlaceRobotBank( < -3014, 327, -127 > )
	Extraction_PlaceRobotBank( < 2220, 542, 64 > )
	Extraction_PlaceRobotBank( < -2864, 1779, -127 > )

	Extraction_PlaceTerminalInteractor( < 1815, -1539, -26 > )
	Extraction_PlaceTerminalInteractor( < 1240, -74, 115 > )
	Extraction_PlaceTerminalInteractor( < 1144, -74, 116 > )
	Extraction_PlaceTerminalInteractor( < 1191, 74, 115 > )
	Extraction_PlaceTerminalInteractor( < 1096, 75, 115 > )
	Extraction_PlaceTerminalInteractor( < -2181, 663, 12 > )
	Extraction_PlaceTerminalInteractor( < -2110, 410, 11 > )
	Extraction_PlaceTerminalInteractor( < -2347, 375, 28 > )

	Extraction_PlaceBatterySpot( < 153, -1568, -120 > )
	Extraction_PlaceBatterySpot( < 1800, -510, -63 > )
	Extraction_PlaceBatterySpot( < -319, 1683, 112 > )
	Extraction_PlaceBatterySpot( < -3036, 292, 36 > )
	Extraction_PlaceBatterySpot( < -1278, 3159, -128 > )
	Extraction_PlaceBatterySpot( < -681, 195, -25 > )

	Extraction_PlaceHackStation( < -2837, 1346, -119 > )
	Extraction_PlaceHackStation( < 1248, -1411, 47 > )
	Extraction_PlaceHackStation( < -1315, 95, -15 > )
}

void function ExecColonyExtraction()
{
	Extraction_PlaceRespawnTerminal( < 2624, 3807, 24 >, < 0, -90, 0 > )
	Extraction_PlaceTitanTerminal( < -1697, -2248, 319 >, < 0, 75, 0 > )

	Extraction_AddExtractionPoint( < -1288, 1079, 391 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 1213, -1088, 616 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < -113, -78, 451 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < 1646, 3640, 362 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < 156, 3195, 300 >, < 0, 70, 0 > )
	Extraction_AddExtractionPoint( < -367, 1433, 373 >, < 0, 180, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < 1418, -1734, 246 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1246, -583, 201 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -516, -25, 236 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1477, -2117, 184 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -149, -976, 177 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1321, 1455, 10 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -175, 1434, 23 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1239, 792, 56 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2285, 3607, 24 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 98, 2701, 7 > )

	Extraction_PlaceWeaponCrate( < -98, 2393, 256 >, < 0, 160, 0 > )
	Extraction_PlaceWeaponCrate( < -79, 1657, 22 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -1129, 673, 191 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -676, -221, 99 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 103, -1111, 177 >, < 0, 75, 0 > )
	Extraction_PlaceWeaponCrate( < 1644, -2420, 389 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 1704, 1575, 28 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 1871, 3680, 159 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -582, 833, 43 >, < 0, -50, 0 > )
	Extraction_PlaceWeaponCrate( < 891, -624, 240 >, < 0, 0, 0 > )

	Extraction_PlaceRobotBank( < 35, 2624, 259 > )
	Extraction_PlaceRobotBank( < 110, 1317, 22 > )
	Extraction_PlaceRobotBank( < 1027, 1307, 164 > )
	Extraction_PlaceRobotBank( < 1347, -1450, 382 > )
	Extraction_PlaceRobotBank( < -421, 100, 236 > )
	Extraction_PlaceRobotBank( < -1681, -1967, 184 > )
	Extraction_PlaceRobotBank( < 2343, 3656, 26 > )

	Extraction_PlaceTerminalInteractor( < -201, 2506, 69 > )
	Extraction_PlaceTerminalInteractor( < -162, 2614, 69 > )
	Extraction_PlaceTerminalInteractor( < 2596, 3900, 220 > )
	Extraction_PlaceTerminalInteractor( < 2250, 3666, 220 > )
	Extraction_PlaceTerminalInteractor( < 1680, -1665, 428 > )
	Extraction_PlaceTerminalInteractor( < 1600, -1374, 441 > )
	Extraction_PlaceTerminalInteractor( < 1704, -1548, 425 > )
	Extraction_PlaceTerminalInteractor( < 1459, -2498, 321 > )
	Extraction_PlaceTerminalInteractor( < 1425, -2498, 321 > )
	Extraction_PlaceTerminalInteractor( < -1370, -2008, 381 > )
	Extraction_PlaceTerminalInteractor( < -1263, -2226, 381 > )
	Extraction_PlaceTerminalInteractor( < -1199, 688, 116 > )
	Extraction_PlaceTerminalInteractor( < 1592, 1394, 163 > )
	Extraction_PlaceTerminalInteractor( < 15, -1275, 439 > )

	Extraction_PlaceBatterySpot( < 1642, -2449, 242 > )
	Extraction_PlaceBatterySpot( < -1291, -2124, 184 > )
	Extraction_PlaceBatterySpot( < -319, -906, 360 > )
	Extraction_PlaceBatterySpot( < -477, -85, 236 > )
	Extraction_PlaceBatterySpot( < -60, 1321, 161 > )
	Extraction_PlaceBatterySpot( < 2312, 3772, 159 > )
	Extraction_PlaceBatterySpot( < 1561, 1524, 28 > )
	Extraction_PlaceBatterySpot( < 941, -802, 240 > )

	Extraction_PlaceHackStation( < 2212, 3440, 34 > )
	Extraction_PlaceHackStation( < -496, 76, 107 > )
	Extraction_PlaceHackStation( < 1347, -267, 209 > )

	CreateFastZipline( < 2061, 3294, 590 >, < 1716, 1508, 597 > )
	CreateFastZipline( < 2061, 3294, 590 >, < 177, 2433, 676 > )
	CreateFastZipline( < 152, 2377, 804 >, < -1510, 524, 650 > )
	CreateFastZipline( < -1510, 524, 650 >, < -1728, -1878, 460 > )
	CreateFastZipline( < 1059, -1708, 860 >, < -1136, -2008, 502 > )
	CreateFastZipline( < -2921, 5036, 105 >, < -1500, 2791, 542 > )
	CreateFastZipline( < -1510, 524, 650 >, < -4534, 1180, 563 > )
}

void function CreateFastZipline( vector startPos, vector endPos )
{
	string startpointName = UniqueString( "rope_startpoint" )
	string endpointName = UniqueString( "rope_endpoint" )

	entity rope_start = CreateEntity( "move_rope" )
	SetTargetName( rope_start, startpointName )
	rope_start.kv.NextKey = endpointName
	rope_start.kv.MoveSpeed = 64
	rope_start.kv.Slack = 0
	rope_start.kv.Subdiv = "4"
	rope_start.kv.Width = "2"
	rope_start.kv.Type = "0"
	rope_start.kv.TextureScale = "1"
	rope_start.kv.RopeMaterial = "cable/zipline.vmt"
	rope_start.kv.PositionInterpolator = 2
	rope_start.kv.Zipline = "1"
	rope_start.kv.ZiplineAutoDetachDistance = "150"
	rope_start.kv.ZiplineSagEnable = "1"
	rope_start.kv.ZiplineSagHeight = "120"
	rope_start.kv.ZiplineMoveSpeedScale = "1.25"
	rope_start.SetOrigin( startPos )

	entity rope_end = CreateEntity( "keyframe_rope" )
	SetTargetName( rope_end, endpointName )
	rope_end.kv.MoveSpeed = 64
	rope_end.kv.Slack = 0
	rope_end.kv.Subdiv = "4"
	rope_end.kv.Width = "2"
	rope_end.kv.Type = "0"
	rope_end.kv.TextureScale = "1"
	rope_end.kv.RopeMaterial = "cable/zipline.vmt"
	rope_end.kv.PositionInterpolator = 2
	rope_end.kv.Zipline = "1"
	rope_end.kv.ZiplineAutoDetachDistance = "150"
	rope_end.kv.ZiplineSagEnable = "1"
	rope_end.kv.ZiplineSagHeight = "120"
	rope_start.kv.ZiplineMoveSpeedScale = "1.25"
	rope_end.SetOrigin( endPos )

	DispatchSpawn( rope_start )
	DispatchSpawn( rope_end )
}

void function ExecRelicExtraction()
{
	foreach ( podPoint in SpawnPoints_GetDropPod() ) //Trim OOB spawns from FD pods
	{
		if ( Distance( podPoint.GetOrigin(), < -37, -5950, 1796 > ) < 1200 )
			podPoint.Destroy()
		else if ( Distance( podPoint.GetOrigin(), < -37, -3674, 2146 > ) < 1200 )
			podPoint.Destroy()
	}

	Extraction_PlaceRespawnTerminal( < 1610, -872, 217 >, < 0, -90, 0 > )
	Extraction_PlaceTitanTerminal( < -3684, -3438, 503 >, < 0, 0, 0 > )

	Extraction_AddExtractionPoint( < 3748, -3821, 453 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < 2719, -5812, 536 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 2726, -2421, 608 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < -1672, -3375, 648 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < -3403, -3145, 791 >, < 0, 90, 0 > )
	Extraction_AddExtractionPoint( < 2382, -4208, 735 >, < 0, -45, 0 > )
	Extraction_AddExtractionPoint( < -2846, -1789, 760 >, < 0, 25, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < 3197, -3901, 55 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2094, -3840, 159 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2072, -5204, 164 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 700, -2759, 38 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -2181, -3200, 56 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -2205, -3882, 519 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1851, -5158, 356 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -3451, -2238, 368 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -505, -2760, -24 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1591, -1266, 183 > )

	Extraction_PlaceWeaponCrate( < -1829, -4858, 356 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < -2333, -4254, 519 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -2154, -2809, 56 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -3406, -2424, 367 >, < 0, -65, 0 > )
	Extraction_PlaceWeaponCrate( < -3416, -3662, 503 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -603, -2960, -24 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 1163, -2911, 151 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 1516, -1464, 184 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 2926, -2879, 144 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 3154, -4154, 191 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 2074, -5328, 127 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 809, -5082, 216 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -249, -3951, 236 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < -573, -3229, 466 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 175, -3692, 678 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 2074, -4128, 159 >, < 0, 0, 0 > )

	Extraction_PlaceRobotBank( < 1836, -4909, 128 > )
	Extraction_PlaceRobotBank( < 1842, -4093, 344 > )
	Extraction_PlaceRobotBank( < 623, -2792, -79 > )
	Extraction_PlaceRobotBank( < -742, -3443, 106 > )
	Extraction_PlaceRobotBank( < -2354, -3289, 56 > )
	Extraction_PlaceRobotBank( < -2060, -4203, 520 > )
	Extraction_PlaceRobotBank( < -2506, -4926, 356 > )

	Extraction_PlaceTerminalInteractor( < 3103, -3147, 178 > )
	Extraction_PlaceTerminalInteractor( < 1851, -4086, 233 > )
	Extraction_PlaceTerminalInteractor( < 1991, -3895, 205 > )
	Extraction_PlaceTerminalInteractor( < 2368, -3891, 222 > )
	Extraction_PlaceTerminalInteractor( < 2271, -3627, 281 > )
	Extraction_PlaceTerminalInteractor( < 1818, -3675, 409 > )
	Extraction_PlaceTerminalInteractor( < 1952, -4139, 389 > )
	Extraction_PlaceTerminalInteractor( < 2175, -4871, 206 > )
	Extraction_PlaceTerminalInteractor( < 305, -3417, 796 > )
	Extraction_PlaceTerminalInteractor( < 236, -3417, 796 > )
	Extraction_PlaceTerminalInteractor( < -617, -3509, 801 > )
	Extraction_PlaceTerminalInteractor( < -2270, -4010, 593 > )
	Extraction_PlaceTerminalInteractor( < -3743, -2680, 569 > )
	Extraction_PlaceTerminalInteractor( < -3404, -2590, 569 > )
	Extraction_PlaceTerminalInteractor( < -3418, -1962, 441 > )
	Extraction_PlaceTerminalInteractor( < -2365, -3476, 123 > )
	Extraction_PlaceTerminalInteractor( < -825, -2735, 57 > )
	Extraction_PlaceTerminalInteractor( < 815, -2698, 216 > )
	Extraction_PlaceTerminalInteractor( < 924, -3087, 193 > )
	Extraction_PlaceTerminalInteractor( < 925, -2943, 193 > )

	Extraction_PlaceBatterySpot( < 2981, -3017, 143 > )
	Extraction_PlaceBatterySpot( < 3469, -3940, 191 > )
	Extraction_PlaceBatterySpot( < 2177, -5477, 127 > )
	Extraction_PlaceBatterySpot( < 2169, -3907, 161 > )
	Extraction_PlaceBatterySpot( < -616, -2733, -23 > )
	Extraction_PlaceBatterySpot( < -1883, -3651, 56 > )
	Extraction_PlaceBatterySpot( < -3390, -3445, 504 > )
	Extraction_PlaceBatterySpot( < 838, -2488, 151 > )

	Extraction_PlaceHackStation( < 1890, -3782, 343 > )
	Extraction_PlaceHackStation( < 3122, -4007, 64 > )
	Extraction_PlaceHackStation( < -2192, -5286, 363 > )
	Extraction_PlaceHackStation( < -3354, -2086, 376 > )
	Extraction_PlaceHackStation( < -2097, -3205, 64 > )
}

void function ExecBoomtownExtraction()
{
	Extraction_PlaceRespawnTerminal( < 3826, -1395, 2304 >, < 0, -90, 0 > )
	Extraction_PlaceTitanTerminal( < 4037, -6558, 2241 >, < 0, 90, 0 > )

	Extraction_AddExtractionPoint( < 5051, -3825, 2603 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < -356, -5395, 2496 >, < 0, 180, 0 > )
	Extraction_AddExtractionPoint( < 6950, -5225, 2708 >, < 0, -45, 0 > )
	Extraction_AddExtractionPoint( < 4202, -2191, 2571 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 3228, -4428, 2576 >, < 0, 135, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < 1449, -4958, 2240 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 439, -4960, 2304 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2878, -3996, 2240 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 3610, -4807, 2375 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 4992, -2750, 2375 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 5720, -3857, 2252 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 7621, -2643, 2273 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 6197, -2211, 2243 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 6556, -4885, 2240 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 4100, -1556, 2304 > )

	Extraction_PlaceWeaponCrate( < 1581, -4195, 2241 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < 3708, -4565, 2239 >, < 0, -45, 0 > )
	Extraction_PlaceWeaponCrate( < 3013, -3422, 2112 >, < 0, -135, 0 > )
	Extraction_PlaceWeaponCrate( < 4820, -2592, 2128 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 5244, -2988, 2375 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 7290, -2275, 2408 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 6027, -4429, 2252 >, < 0, 45, 0 > )
	Extraction_PlaceWeaponCrate( < 6683, -4747, 2376 >, < 0, 135, 0 > )
	Extraction_PlaceWeaponCrate( < 4101, -6395, 2242 >, < 0, 180, 0 > )
	Extraction_PlaceWeaponCrate( < 4143, -1566, 2303 >, < 0, 180, 0 > )

	Extraction_PlaceRobotBank( < 1554, -5609, 2365 > )
	Extraction_PlaceRobotBank( < 4777, -6753, 2303 > )
	Extraction_PlaceRobotBank( < 6651, -5191, 2242 > )
	Extraction_PlaceRobotBank( < 7577, -1433, 2246 > )
	Extraction_PlaceRobotBank( < 6419, -2315, 2240 > )
	Extraction_PlaceRobotBank( < 5659, -3489, 2252 > )
	Extraction_PlaceRobotBank( < 3395, -5044, 2375 > )

	Extraction_PlaceBatterySpot( < 3257, -3654, 2375 > )
	Extraction_PlaceBatterySpot( < 920, -4957, 2240 > )
	Extraction_PlaceBatterySpot( < 3543, -4644, 2376 > )
	Extraction_PlaceBatterySpot( < 6308, -2543, 2239 > )
	Extraction_PlaceBatterySpot( < 7490, -3159, 2272 > )
	Extraction_PlaceBatterySpot( < 6875, -4649, 2240 > )
	Extraction_PlaceBatterySpot( < 4837, -6559, 2240 > )
	Extraction_PlaceBatterySpot( < 3593, -3155, 2112 > )

	Extraction_PlaceHackStation( < 2803, -4175, 2248 > )
	Extraction_PlaceHackStation( < 5542, -3987, 2259 > )
	Extraction_PlaceHackStation( < 7409, -1872, 2415 > )
	Extraction_PlaceHackStation( < 602, -4960, 2311 > )
}

void function ExecRiseExtraction()
{
	foreach ( podPoint in SpawnPoints_GetDropPod() ) //Trim OOB spawns from FD pods
	{
		if ( podPoint.GetOrigin().z >= 1200 ) // Above 1200 in Z coordinate means the desert area
			podPoint.Destroy()
	}

	foreach ( spawnPoint in SpawnPoints_GetPilot() ) //Trim Long Hallways and Huge Pipes spawns
	{
		if ( Distance2D( spawnPoint.GetOrigin(), < -7529, -802, 877 > ) < 2000 )
			spawnPoint.Destroy()
		else if ( Distance2D( spawnPoint.GetOrigin(), < 2183, 5235, 877 > ) < 2000 )
			spawnPoint.Destroy()
	}

	Extraction_PlaceRespawnTerminal( < -8474, -1433, 738 >, < 0, 90, 0 > )
	Extraction_PlaceTitanTerminal( < 3704, 3167, 110 >, < 0, -90, 0 > )

	Extraction_AddExtractionPoint( < 2269, 3396, 804 >, < 0, -90, 0 > )
	Extraction_AddExtractionPoint( < 1604, 1861, 576 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < -3736, -590, 708 >, < 0, 0, 0 > )
	Extraction_AddExtractionPoint( < -4508, -590, 708 >, < 0, 180, 0 > )

	Extraction_AddDefaultEnemyAssaultPoint( < -3878, -423, 382 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -2448, 997, 319 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -518, 828, 544 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 1346, 1961, 15 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2277, 2785, 3 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 2473, -861, 256 > )
	Extraction_AddDefaultEnemyAssaultPoint( < 126, -207, 258 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1158, -245, 544 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -1760, -1042, 364 > )
	Extraction_AddDefaultEnemyAssaultPoint( < -3172, -246, 384 > )

	Extraction_PlaceWeaponCrate( < 2125, 1831, 48 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 2456, 810, 543 >, < 0, -135, 0 > )
	Extraction_PlaceWeaponCrate( < -309, 817, 264 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < 2416, -1066, 254 >, < 0, 0, 0 > )
	Extraction_PlaceWeaponCrate( < -62, -87, 544 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -1017, -522, 248 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 109, 2498, 296 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -1869, -761, 328 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -6431, -1139, 740 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < -5335, -1022, 384 >, < 0, -90, 0 > )
	Extraction_PlaceWeaponCrate( < 3954, 2636, 110 >, < 0, 90, 0 > )
	Extraction_PlaceWeaponCrate( < -1888, -83, 647 >, < 0, 180, 0 > )

	Extraction_PlaceRobotBank( < -8435, -207, 738 > )
	Extraction_PlaceRobotBank( < -4077, -1017, 378 > )
	Extraction_PlaceRobotBank( < -3209, -1383, 776 > )
	Extraction_PlaceRobotBank( < -1569, -204, 544 > )
	Extraction_PlaceRobotBank( < -2363, 1252, 319 > )
	Extraction_PlaceRobotBank( < 220, 1021, 408 > )
	Extraction_PlaceRobotBank( < 2997, 1105, 543 > )
	Extraction_PlaceRobotBank( < 2249, 2934, 3 > )
	Extraction_PlaceRobotBank( < 123, -64, 258 > )

	Extraction_PlaceTerminalInteractor( < -5342, -1352, 422 > )
	Extraction_PlaceTerminalInteractor( < -3246, 3, 424 > )
	Extraction_PlaceTerminalInteractor( < -3002, -223, 422 > )
	Extraction_PlaceTerminalInteractor( < -4143, 854, 491 > )
	Extraction_PlaceTerminalInteractor( < -6407, -66, 780 > )
	Extraction_PlaceTerminalInteractor( < -6264, -1526, 784 > )
	Extraction_PlaceTerminalInteractor( < -1884, -895, 695 > )
	Extraction_PlaceTerminalInteractor( < -891, 112, 589 > )
	Extraction_PlaceTerminalInteractor( < -713, 14, 607 > )
	Extraction_PlaceTerminalInteractor( < -1949, -299, 285 > )
	Extraction_PlaceTerminalInteractor( < -41, -528, 300 > )
	Extraction_PlaceTerminalInteractor( < 744, -1045, 582 > )
	Extraction_PlaceTerminalInteractor( < 2768, -662, 296 > )
	Extraction_PlaceTerminalInteractor( < 2716, -420, 296 > )
	Extraction_PlaceTerminalInteractor( < 3028, 939, 229 > )
	Extraction_PlaceTerminalInteractor( < 3417, 1078, 608 > )
	Extraction_PlaceTerminalInteractor( < 2283, 352, 586 > )
	Extraction_PlaceTerminalInteractor( < 430, 2599, 212 > )
	Extraction_PlaceTerminalInteractor( < -717, 957, 586 > )
	Extraction_PlaceTerminalInteractor( < -1657, 725, 589 > )
	Extraction_PlaceTerminalInteractor( < -2528, 930, 359 > )
	Extraction_PlaceTerminalInteractor( < -2372, 1033, 364 > )

	Extraction_PlaceBatterySpot( < 3334, 1098, 144 > )
	Extraction_PlaceBatterySpot( < 1604, 2663, 5 > )
	Extraction_PlaceBatterySpot( < -237, 1930, 415 > )
	Extraction_PlaceBatterySpot( < -861, -20, 544 > )
	Extraction_PlaceBatterySpot( < -3001, -1290, 383 > )
	Extraction_PlaceBatterySpot( < -3977, 844, 445 > )
	Extraction_PlaceBatterySpot( < -1904, 831, 543 > )
	Extraction_PlaceBatterySpot( < -6287, -818, 740 > )

	Extraction_PlaceHackStation( < 1135, 1622, 136 > )
	Extraction_PlaceHackStation( < -1746, -1153, 370 > )
	Extraction_PlaceHackStation( < -5214, -1218, 390 > )

	CreateFastZipline( < -3387, -1168, 874 >, < -6079, -1771, 925 > )
}