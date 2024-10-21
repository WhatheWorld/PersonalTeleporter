--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics

DIVIDER = 60

data:extend({
  {
    type = "electric-energy-interface",
    name = "Teleporter_Beacon",
    icon = "__PersonalTeleporter__/graphics/icon.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "Teleporter_Beacon"},
    max_health = 150,
    corpse = "medium-remnants",
    collision_box = {{-2, -2}, {2,2}},
    collision_mask = {layers = {item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true, is_lower_object = true}},
    selection_box = {{-2, -2}, {2, 2}},
	render_layer = decorative,
    energy_source =
    {
      type = "electric",
      buffer_capacity = "60MJ",
      usage_priority = "secondary-input",
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
  },
  
  {
		type = "train-stop",
		name = "TP_marker",
		icon = "__PersonalTeleporter__/graphics/icon.png",
		flags = {"placeable-off-grid", "placeable-neutral", "player-creation", "filter-directions"},
		order = "y",
		selectable_in_game = false,
		minable = {mining_time = 1, result = "train-stop"},
		max_health = 1,
		render_layer = "tile",
		final_render_layer = "tile",
		collision_box = {{0,0}, {0,0}},
		selection_box = {{0,0}, {0,0}},
		drawing_box = {{0,0}, {0,0}},
		tile_width = 1,
		tile_height = 1,
    icon_size = 32,
		animation_ticks_per_frame = 0,
	
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0 },
		working_sound =
		{
			sound = { filename = "__base__/sound/train-stop.ogg", volume = 0 }
		},
		circuit_wire_connection_points = {},
		circuit_connector_sprites = circuit_connector_definitions["train-station"].sprites,
	}
  
  
  
})