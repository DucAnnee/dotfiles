local colors = require("base46").get_theme_tb "base_30"

-- setup new highlight group with base45 colors
vim.cmd("highlight RainbowDelimiterRed guifg=" .. colors.red)
vim.cmd("highlight RainbowDelimiterYellow guifg=" .. colors.yellow)
vim.cmd("highlight RainbowDelimiterBlue guifg=" .. colors.blue)
vim.cmd("highlight RainbowDelimiterOrange guifg=" .. colors.orange)
vim.cmd("highlight RainbowDelimiterGreen guifg=" .. colors.green)
vim.cmd("highlight RainbowDelimiterViolet guifg=" .. colors.purple)
vim.cmd("highlight RainbowDelimiterCyan guifg=" .. colors.cyan)

local opts = {
  highlight = {
    'RainbowDelimiterCyan',
    'RainbowDelimiterViolet',
    'RainbowDelimiterBlue',
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
  },
}

return opts
