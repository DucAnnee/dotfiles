local options = {
	formatters_by_ft = {
		typescriptreact = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		javascript = { "prettierd" },
		assembly = { "asmfmt" },
		markdown = { "prettierd" },
		python = { "black" },
		assembly = { "asmfmt" },
		json = { "prettierd" },
		lua = { "stylua" },
		cpp = { "clang-format" },
		c = { "clang-format" },
	},

	format_on_save = {
		timeout_ms = 5000,
		lsp_fallback = true,
	},
}

return options
