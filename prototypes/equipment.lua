--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


data:extend(
{
  {
    type = "battery-equipment",
    name = "Personal-Teleporter",
    sprite =
    {
      filename = "__PersonalTeleporter__/graphics/Personal_Teleport_equipment.png",
      width = 48,
      height = 48,
      priority = "medium"
    },
    shape =
    {
      width = 2,
      height = 2,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      buffer_capacity = "10MJ",
      input_flow_limit = "50kW",
      output_flow_limit = "0W",
      usage_priority = "primary-input"
    }
  },
})