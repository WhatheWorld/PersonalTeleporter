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
      prerequisites = {"automation-3","fusion-reactor-equipment","uranium-processing","rocket-control-unit"},
      unit =
      {
        count = 2000,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
		      {"utility-science-pack", 1}
        },
        time = 15
      }
  },
  
  

})