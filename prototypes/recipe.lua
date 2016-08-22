--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({
	{
		type = "recipe",
		name = "Teleporter-Beacon",
		ingredients =
		{
			{"steel-plate", 100},
			{"copper-plate", 100},
			{"advanced-circuit", 100},
			{"alien-artifact",20}
		},
		result = "Teleporter-Beacon",
		enabled = "false"	
	},
	{
		type = "recipe",
		name = "Personal-Teleporter",
		enabled = "false",
		energy_required = 10,
		ingredients = 
		{
			{"Teleporter-Beacon", 1},
			{"rocket-control-unit", 100},
			{"low-density-structure",50},
			{"fusion-reactor-equipment", 100}
		},
		result = "Personal-Teleporter",
	},
  {
    type = "recipe",
    name = "Portal",
    ingredients = {
      {"fusion-reactor-equipment", 20},
      {"alien-artifact", 100}
    },
    result = "Portal",
    energy_required = 30,
    enabled = false
  }
})