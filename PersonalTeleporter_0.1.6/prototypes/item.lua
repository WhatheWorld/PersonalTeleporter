--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({

{
		type = "item",
		name = "Teleporter_Beacon",
		subgroup = "production-machine",
		icon = "__PersonalTeleporter__/graphics/icon.png",
		flags = { "goes-to-quickbar" },
		order = "a[items]-b[Teleporter_Beacon]",
		place_result="Teleporter_Beacon",
		stack_size= 2,
	},
  
  
  {
	type = "fluid",
	name = "liquid-alien-artifacts",
	default_temperature = 50,
	heat_capacity = "1KJ",
    base_color = {r=0, g=0, b=0},
    flow_color = {r=1, g=0, b=1},
	max_temperature = 200,
	icon = "__PersonalTeleporter__/graphics/liquid-alien.png",
	pressure_to_speed_ratio = 0.4,
	flow_to_energy_ratio = 0.59,
	order = "a[fluid]-y[liquid-alien-artifacts]"
  },
  {
    type = "item",
	name = "TeleporterCore",
	subgroup = "intermediate-product",
	icon = "__PersonalTeleporter__/graphics/teleporter-core.png",
	flags = { "goes-to-main-inventory" },
	order = "a[items]-c[TeleporterCore]",
	stack_size = 16
  },
  
  
  
  
  {
	type = "item",
	name = "Personal-Teleporter",
	icon = "__PersonalTeleporter__/graphics/Personal_Teleporter_item.png",
	flags = {"goes-to-main-inventory"},
	placed_as_equipment_result = "Personal-Teleporter",
	subgroup = "equipment",
	order = "g-a-a",
	stack_size= 1,
	  
  }
  
})