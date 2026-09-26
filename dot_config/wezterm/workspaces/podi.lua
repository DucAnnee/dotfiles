local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

function M.setup()
	local github = wezterm.home_dir .. "/Documents/GitHub"

	-- Management
	local mgmt_tab, _, window = mux.spawn_window({
		workspace = "podi",
		cwd = github,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd management-website; nvim .",
		},
	})
	mgmt_tab:set_title("Management")

	-- Booth App
	local booth_tab = window:spawn_tab({
		cwd = github,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd booth-app; nvim .",
		},
	})
	booth_tab:set_title("Booth App")

	-- Podi Core
	local core_tab = window:spawn_tab({
		cwd = github,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd podi-core; nvim .",
		},
	})
	core_tab:set_title("Podi Core")
end

return M
