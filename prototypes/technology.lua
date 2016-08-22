data:extend({
  {
    type = "technology",
    name = "Personal-Teleportation",
    icon = "__PersonalTeleporter__/graphics/technology_icon.png",
	  effects =
	  {
	    {
        type = "unlock-recipe",
        recipe = "Teleporter-Beacon"
      }
	  },
    prerequisites = {"logistic-system", "alien-technology"},
    unit =
    {
      count = 500,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"alien-science-pack", 1}
      },
      time = 60
    }
  },
  {
    type = "technology",
    name = "Personal-Teleportation-Adv",
    icon = "__PersonalTeleporter__/graphics/technology_adv_icon.png",
	  effects =
	  {
      {
        type = "unlock-recipe",
        recipe = "Personal-Teleporter"
      },
      {
        type = "unlock-recipe",
        recipe = "Portal",
      }
	  },
    prerequisites = {"Personal-Teleportation", "fusion-reactor-equipment", "rocket-silo"},
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
  }
})
