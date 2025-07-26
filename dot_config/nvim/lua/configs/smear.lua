local opts = {
  stiffness = 0.6, -- 0.6      [0, 1]
  trailing_stiffness = 0.4, -- 0.3      [0, 1]
  distance_stop_animating = 0.3,
  time_interval = 17,
  max_slope_horizontal = 0.5,
  min_slope_vertical = 2,
  trailing_exponent = 0.1,
}
return opts
