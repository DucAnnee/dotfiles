local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local target = wezterm.target_triple
local default_prog = nil

if target:find("windows") then
	default_prog = {
		"pwsh.exe",
		"-NoLogo",
		"-NoExit",
		"-ExecutionPolicy",
		"Bypass",
	}
elseif target:find("linux") then
	default_prog = { "zsh", "-l" }
end

config.default_prog = default_prog

config.front_end = "WebGpu"
-- webgpu_power_preference = "LowPower"

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

local bg_img = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/assets/background.jpg"

local function exists(path)
	local f = io.open(path, "r")
	return f and f:close() or false
end

config.background = exists(bg_img)
		and {
			{
				source = { File = bg_img },
				hsb = { hue = 1.0, saturation = 1.02, brightness = 0.25 },
			},
			{
				source = { Color = "#282c35" },
				width = "100%",
				height = "100%",
				opacity = 0.6,
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
config.enable_wayland = false
config.animation_fps = 2
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
}

return config
