--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({
	{
		type = "recipe",
		name = "Teleporter_Beacon",
    enabled = false,
		ingredients =
		{
			{type="item",name="steel-plate", amount=100},
			{type="item",name="copper-plate", amount=100},
			{type="item",name="processing-unit", amount=100},
			{type="item",name="TeleporterCore",amount=1}
		},
		--result = "Teleporter_Beacon",
    results = { {type="item", name="Teleporter_Beacon", amount=1} }
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
		enabled = false
  },
	{
		type = "recipe",
		name = "TeleporterCore",
		category = "crafting-with-fluid",
		ingredients =
		{	
			{type="fluid", name = "liquid-alien-artifacts", amount = 10}
		},
    results=
		{
			{type="item", name="TeleporterCore", amount=1}
		},
		enabled = false
	},
	{
		type = "recipe",
		name = "Personal-Teleporter",
		enabled = false,
		energy_required = 10,
		ingredients = 
		{
			{type="item", name="Teleporter_Beacon", amount=1},
			{type="item", name="processing-unit", amount=10},
			{type="item", name="low-density-structure",amount=10},
			{type="item", name="fission-reactor-equipment", amount=1}
		},
    results=
		{
			{type="item", name="Personal-Teleporter", amount=1}
		}
	}
})