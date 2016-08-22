local portal_targeter = util.table.deepcopy(data.raw["ammo-turret"]["gun-turret"])

portal_targeter.name = "Portal"
portal_targeter.icon = "__PersonalTeleporter__/graphics/portal-32.png"
portal_targeter.flags = {"placeable-neutral", "player-creation","placeable-off-grid"}
portal_targeter.collision_mask = {}
portal_targeter.max_health = 0
portal_targeter.inventory_size = 0
portal_targeter.collision_box = {{ 0, 0}, {0, 0}}
portal_targeter.selection_box = {{ 0, 0}, {0, 0}}
portal_targeter.folded_animation =
{
	layers =
	{
		{
			filename = "__PersonalTeleporter__/graphics/null.png",
			priority = "medium",
			width = 32,
			height = 32,
			frame_count = 1,
			line_length = 1,
			run_mode = "forward",
			axially_symmetrical = false,
			direction_count = 1,
			shift = {0, 0}
		}
	}
}
portal_targeter.base_picture =
{
	layers =
	{
		{
			filename = "__PersonalTeleporter__/graphics/portal-64.png",
			line_length = 1,
			width = 64,
			height = 64,
			frame_count = 1,
			axially_symmetrical = false,
			direction_count = 1,
			shift = {0, 0}
		}
	}
}
portal_targeter.attack_parameters =
{
	type = "projectile",
	ammo_category = "melee",
	cooldown = 30,
	projectile_center = {0, 0},
	projectile_creation_distance = 1.4,
	range = 0,
	damage_modifier = 0,
	ammo_type =
	{
		type = "projectile",
		category = "melee",
		energy_consumption = "0J"
	}
}

data:extend({portal_targeter})

data:extend({
  {
    type = "explosion",
    name = "teleport-sound",
    animation_speed = 5,
    animations =
    {
      {
        filename = "__PersonalTeleporter__/graphics/empty.png",
        priority = "extra-high",
        width = 33,
        height = 32,
        frame_count = 1,
        line_length = 1,
        shift = {0, 0}
      }
    },
    light = {intensity = 1, size = 20, color={r=0,g=0.3,b=1} },
    smoke = "smoke",
    smoke_count = 1,
    smoke_slow_down_factor = 1,
  }
})