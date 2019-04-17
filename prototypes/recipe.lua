--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({
	{
		type = "recipe",
		name = "Teleporter_Beacon",
		ingredients =
		{
			{"steel-plate", 100},
			{"copper-plate", 100},
			{"advanced-circuit", 100},
			{"TeleporterCore",1}
		},
		result = "Teleporter_Beacon",
		enabled = "false"	
	},
	
	
	
    {
		type = "recipe",
		name = "liquid-alien-artifacts",
		category = "chemistry",
		energy_required = 1,
		ingredients =
		{
			{type="item", name="uranium-238", amount=10},
			{type="fluid", name="light-oil", amount=10}
		},
		results=
		{
			{type="fluid", name="liquid-alien-artifacts", amount=1}
		},
		subgroup = "fluid-recipes",
		enabled = "false"
    },
	{
		type = "recipe",
		name = "TeleporterCore",
		category = "crafting-with-fluid",
		ingredients =
		{	
			{type="fluid", name = "liquid-alien-artifacts", amount = 10}
		},
		result = "TeleporterCore",
		enabled = "false"
	},
	
	{
		type = "recipe",
		name = "Personal-Teleporter",
		enabled = "false",
		energy_required = 10,
		ingredients = 
		{
			{"Teleporter_Beacon", 1},
			{"rocket-control-unit", 10},
			{"low-density-structure",10},
			{"fusion-reactor-equipment", 5}
		},
		result = "Personal-Teleporter",
	
	}
})