--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics

data:extend({
  {
    type = "accumulator",
    name = "Teleporter-Beacon",
    icon = "__PersonalTeleporter__/graphics/icon.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "Teleporter-Beacon"},
    max_health = 150,
    corpse = "medium-remnants",
    collision_box = {{-2, -2}, {2,2}},
    collision_mask = {"water-tile", "item-layer", "object-layer"},
    selection_box = {{-2, -2}, {2, 2}},
    render_layer = decorative,
    energy_source =
    {
      type = "electric",
      buffer_capacity = "60MJ",
      usage_priority = "terciary",
      input_flow_limit = "1MW",
      output_flow_limit = "0W"
    },
    picture =
    {
      filename = "__PersonalTeleporter__/graphics/tiers/orange/spritesheet.png",
      priority = "extra-high",
      width = 128,
      height = 128,
	  line_length = 16,
	  frame_count = 16,
      shift = {0, 0}
    },
    charge_animation =
    {
      filename = "__PersonalTeleporter__/graphics/tiers/orange/spritesheet.png",
      width = 128,
      height = 128,
      line_length = 16,
      frame_count = 16,
      shift = {0, 0},
      animation_speed = 0.5
    },
    charge_cooldown = 30,
    charge_light = {intensity = 0.3, size = 7},
    discharge_animation =
    {
      filename = "__PersonalTeleporter__/graphics/tiers/orange/spritesheet.png",
      width = 128,
      height = 128,
      line_length = 16,
      frame_count = 16,
      shift = {0, 0},
      animation_speed = 0.5
    },
    discharge_cooldown = 60,
    discharge_light = {intensity = 0.7, size = 7},
  }
})