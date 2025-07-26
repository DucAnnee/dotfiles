local M = {}

M.base_30 = {
  white = "#ffffff", -- custom
  darker_black = "#0A1019",
  black = "#0F1721",
  black2 = "#202a37",
  one_bg = "#252f3c", -- real bg of onedark
  one_bg2 = "#313b48",
  one_bg3 = "#3d4754",
  grey = "#495360",
  grey_fg = "#535d6a",
  grey_fg2 = "#5c6673",
  light_grey = "#d9dce0",
  red = "#f07178",
  baby_pink = "#ffd1dc",
  pink = "#ff9eb5", -- base16
  line = "#2a3441", -- for lines like vertsplit
  green = "#c8ffa8", --base16
  vibrant_green = "#66ff01", -- custom
  nord_blue = "#9eb5ff",
  blue = "#89ddff", -- base16
  yellow = "#FFFCB9", -- base17
  sun = "#DFC783",
  purple = "#baa1e2", -- base16
  dark_purple = "#6b37c0", --custom
  teal = "#BCFFE8", -- custom
  orange = "#fe9373", -- base16
  cyan = "#90FFFE", -- base16
  statusline_bg = "#2f3242",
  lightbg = "#3c4051",
  pmenu_bg = "#82aaff", -- custom
  folder_bg = "#82aaff",
}

M.base_16 = {
  base00 = "#0F1721",
  base01 = "#252f3c",
  base02 = "#313b48",
  base03 = "#3d4754",
  base04 = "#495360",
  base05 = "#c0c8d5",
  base06 = "#c7cfdc",
  base07 = "#ced6e3",
  base08 = "#f07178",
  base09 = "#fe9373",
  base0A = "#FFFCB9",
  base0B = "#91E5D4",
  base0C = "#89ddff",
  base0D = "#86abdc",
  base0E = "#baa1e2",
  base0F = "#c0c8d5",
}

M.polish_hl = {
  -- nvimtree
  Comment = { italic = true },

  CmpDocBorder = { fg = { M.base_30.white, 3 }, bg = M.base_30.darker_black },
  CmpPmenu = { fg = M.base_30.white, bg = M.base_30.darker_black },
  CmpBorder = { fg = { M.base_30.white, 3 }, bg = M.base_30.darker_black },

  -- telescope
  TelescopeBorder = { fg = M.base_30.white, bg = M.base_30.darker_black },
  TelescopePromptBorder = { fg = M.base_30.white, bg = M.base_30.darker_black },
  TelescopeNormal = { bg = M.base_30.darker_black },
  TelescopePromptNormal = { bg = M.base_30.darker_black },

  -- syntax
  Label = { fg = M.base_30.white },
  PreProc = { fg = M.base_30.white },
  StorageClass = { fg = M.base_30.white },
  Type = { fg = M.base_30.dark_purple },
  Typedef = { fg = M.base_30.white },

  -- treesitter
  treesitter = {
    ["@comment"] = { fg = M.base_30.grey, italic = true },
    ["@variable"] = { fg = M.base_30.white },
    ["@variable.builtin"] = { fg = M.base_30.purple },
    ["@variable.parameter"] = { fg = M.base_30.white },
    ["@variable.member"] = { fg = M.base_30.cyan },
    ["@variable.member.key"] = { fg = M.base_30.white },
    --
    ["@boolean"] = { fg = M.base_30.nord_blue },
    --
    ["@module"] = { fg = M.base_30.blue },
    --
    ["@constant"] = { fg = M.base_30.red },
    ["@constant.builtin"] = { fg = M.base_30.red },
    ["@constant.macro"] = { fg = M.base_30.red },
    --
    ["@string"] = { fg = M.base_30.teal },
    ["@string.regex"] = { fg = M.base_30.nord_blue },
    ["@string.escape"] = { fg = M.base_30.nord_blue },
    ["@character"] = { fg = M.base_30.vibrant_green },
    ["@character.special"] = { fg = M.base_30.vibrant_green },
    ["@number"] = { fg = M.base_30.white },
    ["@number.float"] = { fg = M.base_30.white },
    --pen
    ["@annotation"] = { fg = M.base_30.white },
    ["@attribute"] = { fg = M.base_30.white },
    ["@error"] = { fg = M.base_30.red },
    --
    ["@keyword.exception"] = { fg = M.base_30.red },
    ["@keyword"] = { fg = M.base_30.white },
    ["@keyword.function"] = { fg = M.base_30.white },
    ["@keyword.return"] = { fg = M.base_30.red },
    ["@keyword.operator"] = { fg = M.base_30.purple },
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.conditional"] = { fg = M.base_30.purple },
    ["@keyword.conditional.ternary"] = { fg = M.base_30.dark_purple },
    ["@keyword.repeat"] = { fg = M.base_30.purple },
    ["@keyword.storage"] = { fg = M.base_30.red },
    ["@keyword.directive.define"] = { fg = M.base_30.red },
    ["@keyword.directive"] = { fg = M.base_30.white },
    ["@keyword.type"] = { fg = M.base_30.teal },
    --
    ["@function"] = { fg = M.base_30.cyan },
    ["@function.builtin"] = { fg = M.base_30.white },
    ["@function.macro"] = { fg = M.base_30.red },
    ["@function.call"] = { fg = M.base_30.cyan },
    ["@function.method"] = { fg = M.base_30.cyan },
    ["@function.method.call"] = { fg = M.base_30.cyan },
    ["@constructor"] = { fg = M.base_30.dark_purple },
    --
    ["@operator"] = { fg = M.base_30.purple },
    ["@reference"] = { fg = M.base_30.red },
    ["@symbol"] = { fg = M.base_30.white },
    ["@tag"] = { fg = M.base_30.white },
    ["@tag.attribute"] = { fg = M.base_30.white },
    ["@tag.delimiter"] = { fg = M.base_30.white },
    ["@text"] = { fg = M.base_30.white },
    ["@text.emphasis"] = { fg = M.base_30.white },
    ["@text.strike"] = { fg = M.base_30.light_grey, strikethrough = true },
    ["@type"] = { fg = M.base_30.blue },
    ["@type.builtin"] = { fg = M.base_30.purple },
    ["@definition"] = { sp = M.base_30.red, underline = true },
    ["@scope"] = { bold = true },
    ["@property"] = { fg = M.base_30.dark_purple },
  },
}

M.type = "dark"

return M
