require("nvchad.configs.lspconfig").defaults()

local nvlsp = require("nvchad.configs.lspconfig")

local base = {
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
}

-- Plain servers that only need NvChad defaults
for _, name in ipairs({ "ts_ls", "pyright", "ruff", "clangd" }) do
	vim.lsp.config(name, base)
end

-- TypeScript / JavaScript
vim.lsp.config(
	"ts_ls",
	vim.tbl_deep_extend("force", base, {
		init_options = {
			hostInfo = "neovim",
		},

	})
)

-- Enable after all configs are defined
vim.lsp.enable({ "pyright", "ruff", "clangd", "ts_ls" })
