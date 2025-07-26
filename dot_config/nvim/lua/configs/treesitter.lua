local opts = {
  ensure_installed = {
    "vim",
    "lua",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "json",
    "yaml",
    "toml",
    "python",
    "c",
    "cpp",
    "markdown",
    "markdown_inline",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "ruby", "markdown" },
  },
  indent = { enable = true, disable = { "ruby" } },
}
return opts
