local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

function M.setup()
	local dial = wezterm.home_dir .. "/Documents/GitHub/DialLink"

	-- Phone System
	local phone_sys_tab, _, window = mux.spawn_window({
		workspace = "diallink",
		cwd = dial,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd diallink-server-phone-system; nvim .",
		},
	})
	phone_sys_tab:set_title("Phone System")

	-- OpenAPI
	local openapi_tab, _ = window:spawn_tab({
		cwd = dial,
		args = {
			"pwsh",
			"-NoExit",
			"-Command",
			"cd diallink-openapi-development; nvim .",
		},
	})
	openapi_tab:set_title("OpenAPI")
end

return M
