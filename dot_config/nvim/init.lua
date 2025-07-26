vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

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

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

if vim.g.neovide then
  vim.opt.guifont = { "CaskaydiaCove Nerd Font", ":h12" }
  -- Optional: scale UI on HiDPI displays:
  vim.g.neovide_scale_factor = 1.0

  -- 2) Transparency & blur
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency))
  end
  vim.g.neovide_opacity = 1.0 -- window background opacity
  vim.g.transparency = 1.0
  vim.g.neovide_floating_blur_amount_x = 2 -- blur radius for floating windows
  vim.g.neovide_floating_blur_amount_y = 2
  vim.g.neovide_background_color = "#6b37c0"
  -- 3) Cursor effects
  vim.g.neovide_cursor_hack = true
  -- vim.g.neovide_cursor_vfx_mode = "sonicboom" -- choices: "pixiedust", "railgun", "sonicboom", "ripple", "wireframe", "torpedo", "", etc.
  vim.g.neovide_cursor_animation_length = 0.150

  -- vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  -- vim.g.neovide_cursor_vfx_particle_density = 10.0
  -- vim.g.neovide_cursor_vfx_particle_speed = 20.0
  -- vim.g.neovide_cursor_vfx_particle_phase = 1.5
  -- vim.g.neovide_cursor_vfx_particle_curl = 1.0

  -- 4) Smooth scrolling & framerate
  vim.g.neovide_refresh_rate = 60 -- target FPS
  vim.g.neovide_refresh_rate_idle = 5 -- FPS when idle
  vim.g.neovide_scroll_animation_length = 0.3 -- seconds per scroll step

  -- 5) Input tweaks
  vim.g.neovide_input_use_logo = true -- allow Super/Win for mappings
  -- 6) Window behavior
  vim.g.neovide_remember_window_size = true -- persist window size between sessions
  vim.g.neovide_fullscreen = false -- start in windowed mode
  -- (You can also bind fullscreen toggle:)
  vim.keymap.set("n", "<F11>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)

  local opts = { noremap = true, silent = true }

  -- Visual & Normal: Ctrl+C → copy to system clipboard
  vim.api.nvim_set_keymap("v", "<C-c>", '"+y', opts)
  vim.api.nvim_set_keymap("n", "<C-c>", '"+y', opts)

  -- Insert & Command-line: Ctrl+V → paste from system clipboard
  vim.api.nvim_set_keymap("i", "<C-v>", "<C-r>+", opts)
  vim.api.nvim_set_keymap("c", "<C-v>", "<C-r>+", opts)
end
