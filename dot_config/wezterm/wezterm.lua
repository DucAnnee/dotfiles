local wezterm = require("wezterm")
local config = require("config")
require("events")

config.exit_behavior = "Close"
-- -- Workspaces Config
-- local podi = require("workspaces.podi")
-- wezterm.on("gui-startup", function()
-- 	podi.setup()
-- 	wezterm.mux.set_active_workspace("podi")
-- end)

return config
