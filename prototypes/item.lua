--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend({

  {
		type = "item",
		name = "Teleporter-Beacon",
		subgroup = "production-machine",
		icon = "__PersonalTeleporter__/graphics/icon.png",
		flags = { "goes-to-quickbar" },
		order = "a[items]-b[Teleporter-Beacon]",
		place_result="Teleporter-Beacon",
		stack_size= 5,
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
  },
  {
    type = "item",
    name = "Portal",
    icon = "__PersonalTeleporter__/graphics/portal-32.png",
    flags = {"goes-to-quickbar"},
		subgroup = "capsule",
		order = "d[Portal]",
    place_result = "Portal",
    stack_size = 1
  }
})
