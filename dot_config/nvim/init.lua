vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("nvchad.autocmds")

vim.schedule(function()
	require("mappings")
end)

if vim.g.neovide then
	-- Font (string is safest)
	vim.o.guifont = "CaskaydiaCove Nerd Font:h12:b"

	-- Scale / perf
	vim.g.neovide_scale_factor = 0.75
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_scroll_animation_length = 0.3

	-- Transparency
	vim.g.transparency = 0.65
	local function alpha()
		return string.format("%02x", math.floor(255 * vim.g.transparency))
	end
	vim.g.neovide_opacity = vim.g.transparency
	vim.g.neovide_normal_opacity = vim.g.transparency

	-- Use RGBA hex for the window bg (append alpha!)
	-- This gives you a purple acrylic vibe with the compositor’s blur.
	vim.g.neovide_background_color = "#6b37c0" .. alpha()

	-- Floating blur (Neovide-internal; compositor handles window blur)
	vim.g.neovide_floating_blur_amount_x = 2
	vim.g.neovide_floating_blur_amount_y = 2

	-- Cursor
	vim.g.neovide_cursor_hack = true
	vim.g.neovide_cursor_animation_length = 0.150
	-- vim.g.neovide_cursor_vfx_mode = "sonicboom"

	-- Window behavior
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_fullscreen = false
	vim.keymap.set("n", "<F11>", function()
		vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
	end, { noremap = true, silent = true })

	-- Clipboard maps
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("v", "<C-c>", '"+y', opts)
	vim.api.nvim_set_keymap("n", "<C-c>", '"+y', opts)
	vim.api.nvim_set_keymap("i", "<C-v>", "<C-r>+", opts)
	vim.api.nvim_set_keymap("c", "<C-v>", "<C-r>+", opts)
end
