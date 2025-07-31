local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		cpp = { "clang-format" },
		c = { "clang-format" },
		javascriptreact = { "prettierd" },
		javascript = { "prettierd" },
		json = { "prettierd" },
	},

	format_on_save = {
		timeout_ms = 5000,
		lsp_fallback = true,
	},
}

return options
