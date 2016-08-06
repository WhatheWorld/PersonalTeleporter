--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({
  {
      type = "technology",
      name = "PersonalTeleportation",
      icon = "__PersonalTeleporter__/graphics/technology_icon.png",
	  effects =
	  {
	    {
		  type = "unlock-recipe",
		  recipe = "Teleporter_Beacon"
		},
		{
		  type = "unlock-recipe",
		  recipe = "TeleporterCore"
		},
		
		{
		  type = "unlock-recipe",
		  recipe = "liquid-alien-artifacts"
		},
		{
		  type = "unlock-recipe",
		  recipe = "Personal-Teleporter"
		},
		
	  },
      prerequisites = {"automation-3", "electronics", "circuit-network","fusion-reactor-equipment","rocket-silo"},
      unit =
      {
        count = 2000,
        ingredients =
        {
          {"science-pack-1", 5},
          {"science-pack-2", 5},
          {"science-pack-3", 5},
		  {"alien-science-pack", 5}
        },
        time = 15
      }
  },
  
  

})