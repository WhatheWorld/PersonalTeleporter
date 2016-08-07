--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics

--this is not used in personal Teleporter but is left over from simpleTeleporter
--[[
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SimpleTeleporters Config File

Short tutorial:
	To the left you see the variable names
	After the equal sign, you see the value which you can change
	
Do not delete anything, this will break the mod.

### Variable Definitions ###

	TIER_X_BUFFER_CAPACITY
		Defines how much buffer capacity the teleporter has.
		In MegaJoule (MJ)
	TIER_X_TELEPORT_POWER
		Defines how much power the teleporter needs to teleport.
		In MegaJoule (MJ)
	TIER_X_DISTANCE
		Defines the distance the teleporter can handle.
		In Tiles (1 Tile = Size of one belt)
	TIER_X_COOLDOWN
		The cooldown per tier.
		In Seconds

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
]]--

-- General Settings
MSG_OUTPUT_MODE = 2 -- 1 is FlyingText; 2 is Chat
FLOW_DIVIDER = 60 -- Global Dividier for calculation Flow limit values

-- TIER 1
TIER_01_BUFFER_CAPACITY = 60
TIER_01_TELEPORT_POWER = 15
TIER_01_DISTANCE = 200
TIER_01_FLOW_LIMIT = TIER_01_BUFFER_CAPACITY / FLOW_DIVIDER
TIER_01_COOLDOWN = 10

