--[[Defines how many teleporter beacons should be on page. NOT ZERO VALUE!
    Default is 10. ]]
PersonalTeleporter.config.page_size = 10

--[[Defines what should be shown in pager.
    • "true" for pages (e.g. "2/4")
    • "false" for beacons count (e.g. "11-20/37", if page_size is 10)
    Default is "true". ]]
--PersonalTeleporter.config.show_page_numbers = true; TODO. Not yet implemented. I'm lazy))) But should I? Maybe it's quite useless?

--[[Defines whether all players can use all beacons in spite of force membership or not.
    • "true" members of opposing force can use your beacons
    • "false" all beacons are common only inside one force
    Default is "false". ]]
PersonalTeleporter.config.all_beacons_for_all = false

--[[Defines whether straight jumping ignores collisions (buildings, trees, water) or not.
    • "true" is for ignoring all collisions
    • "false" is for normal behaviour of collisions check
    Default is "false". ]]
PersonalTeleporter.config.straight_jump_ignores_collisions = false

--[[Defines how much energy should be in Personal Teleporter equipment to use Portal for straight jump. NOT ZERO VALUE!
    Note: Personal Teleporter stats are: buffer = 10MJ, input limit = 50kW.
    Default is 10000 (10kJ/m). ]]
PersonalTeleporter.config.energy_in_personal_teleporter_to_use_portal = 10000

--[[Defines how much energy should be in Personal Teleporter equipment to jump to Teleporter Beacon. NOT ZERO VALUE!
    Note: Personal Teleporter stats are: buffer = 10MJ, input limit = 50kW.
    Default is 2000000 (2MJ). ]]
PersonalTeleporter.config.energy_in_personal_teleporter_to_use_beacon = 2000000

--[[Defines how much energy should be in Teleporter Beacon to accept it's activation. NOT ZERO VALUE!
    Note: Teleporter Beacon stats are: buffer = 60MJ, input limit = 1MW.
    Default is 10000000 (10MJ). ]]
PersonalTeleporter.config.energy_in_beacon_to_activate = 10000000
