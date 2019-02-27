--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({
  {
      type = "technology",
      name = "PersonalTeleportation",
      icon = "__PersonalTeleporter__/graphics/technology_icon.png",
      icon_size = 128,
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
          {"automation-science-pack", 5},
          {"logistic-science-pack", 5},
          {"chemical-science-pack", 5},
		      {"utility-science-pack", 5}
        },
        time = 15
      }
  },
  
  

})