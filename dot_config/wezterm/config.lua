local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

local podi = require("workspaces.podi")
local diallink = require("workspaces.diallink")
local conf = require("workspaces.conf")

local function workspace_exists(name)
	for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
		if workspace == name then
			return true
		end
	end

	return false
end

local function switch_workspace(name, setup)
	if not workspace_exists(name) then
		setup()
	end

	wezterm.mux.set_active_workspace(name)
end

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local target = wezterm.target_triple
local default_prog = nil

if target:find("windows") then
	default_prog = {
		"pwsh.exe",
		"-NoLogo",
	}
elseif target:find("linux") then
	default_prog = { "zsh", "-l" }
end

config.default_prog = default_prog

-- 2️⃣ Font and font-weight control:
config.font = wezterm.font_with_fallback({
	{ family = "CaskaydiaCove Nerd Font", weight = "Bold" },
})
config.font_size = 12.0

-- 3️⃣ Appearance tweaks:
config.color_scheme = "Catppuccin Frappe"
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.97
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = 25,
	right = 25,
	top = 25,
	bottom = 25,
}

config.text_background_opacity = 1.0

local bg_img = wezterm.home_dir .. "/assets/background.jpg"

local function exists(path)
	local f = io.open(path, "r")
	return f and f:close() or false
end

config.background = exists(bg_img)
		and {
			{
				source = { File = bg_img },
				hsb = { hue = 1.0, saturation = 1.02, brightness = 0.25 },
				vertical_align = "Middle",
				horizontal_align = "Center",
			},
			{
				source = { Color = "#282c35" },
				width = "100%",
				height = "100%",
				opacity = 0.8,
			},
		}
	or {
		{
			source = { Color = "#191724" },
			width = "100%",
			height = "100%",
			opacity = 0.8,
		},
	}

-- 4️⃣ Performance flags (GPU path):
config.front_end = "Software"
-- webgpu_power_preference = "LowPower"
config.enable_wayland = false
config.animation_fps = 60
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseIn"

config.term = "wezterm"
config.keys = {
	-- Alt+Right → next tab
	{
		key = "RightArrow",
		mods = "ALT",
		action = act.ActivateTabRelative(1),
	},
	-- Alt+Left → prev tab
	{
		key = "LeftArrow",
		mods = "ALT",
		action = act.ActivateTabRelative(-1),
	},
	-- Alt+T → new tab
	{
		key = "t",
		mods = "ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- {
	-- 	key = "c",
	-- 	mods = "CTRL",
	-- 	action = act.CopyTo("ClipboardAndPrimarySelection"),
	-- },
	{
		key = "v",
		mods = "CTRL",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	-- Reload
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},

	-- Workspaces
	-- Ctrl+Shift+W → Show Launcher with Fuzzy and Workspaces flags
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{
		key = "1",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function()
			switch_workspace("podi", podi.setup)
		end),
	},

	{
		key = "2",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function()
			switch_workspace("diallink", diallink.setup)
		end),
	},

	{
		key = "3",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function()
			switch_workspace("conf", conf.setup)
		end),
	},
}

return config
