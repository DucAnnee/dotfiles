local options = {
	formatters_by_ft = {
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		javascript = { "prettier" },
		markdown = { "prettier" },
		python = { "black" },
		-- java = { "google-java-format" },
		json = { "prettier" },
		lua = { "stylua" },
		cpp = { "clang-format" },
		c = { "clang-format" },
		mermaid = { "mermaidfmt" },
	},

	formatters = {
		mermaidfmt = {
			command = "mermaidfmt",
			args = {},
			stdin = true,
		},
	},

	format_on_save = {
		timeout_ms = 5000,
		lsp_fallback = false,
	},
}

return options
