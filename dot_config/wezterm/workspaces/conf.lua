local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

function M.setup()
	local config_path = wezterm.home_dir .. "/.config"

	-- Nvim
	local nvim_tab, _, window = mux.spawn_window({
		workspace = "conf",
		cwd = config_path,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd nvim; nvim .",
		},
	})
	nvim_tab:set_title("Nvim")

	-- WezTerm
	local wez_tab, _ = window:spawn_tab({
		cwd = config_path,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd wezterm; nvim .",
		},
	})
	wez_tab:set_title("WezTerm")
end

return M
