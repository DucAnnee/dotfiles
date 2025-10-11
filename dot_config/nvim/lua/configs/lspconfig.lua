-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

local servers = { "ts_ls", "pyright", "ruff", "clangd" }
local nvlsp = require("nvchad.configs.lspconfig")

-- lsps with default config
-- for _, lsp in ipairs(servers) do
-- 	lspconfig[lsp].setup({
-- 		on_attach = nvlsp.on_attach,
-- 		on_init = nvlsp.on_init,
-- 		capabilities = nvlsp.capabilities,
-- 		-- handlers = {
-- 		--   ["textDocument/publishDiagnostics"] = function(...) end,
-- 		-- },
-- 	})
-- end

local lsps = {
	{ "ts_ls" },
	{ "pyright" },
	{ "ruff" },
	{ "clangd" },
}

for _, lsp in pairs(lsps) do
	local name, config = lsp[1], lsp[2]
	if not config then
		config = {
			on_attach = nvlsp.on_attach,
			on_init = nvlsp.on_init,
			capabilities = nvlsp.capabilities,
		}
	end

	vim.lsp.enable(name)

	if config then
		vim.lsp.config(name, config)
	end
end
