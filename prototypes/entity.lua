--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


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