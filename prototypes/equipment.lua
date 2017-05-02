--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend(
{

	{
		type = "energy-shield-equipment",
		name= "Personal-Teleporter",
		sprite =
		{
		  filename = "__PersonalTeleporter__/graphics/Personal_Teleport_equipment.png",
		  width = 48,
		  height = 48,
		  priority = "medium"
		},   
		shape =
		{
		  width = 3,
		  height = 3,
		  type = "full"
		},
    max_shield_value = 150,
		energy_source =
		{
		  type = "electric",
		  buffer_capacity = "10MJ",
		  input_flow_limit = "150kW",
		  usage_priority = "primary-input"
		},
    energy_per_shield = "30kJ",
    categories = {"armor"}
	}

})