require("nvchad.configs.lspconfig").defaults()

local nvlsp = require("nvchad.configs.lspconfig")

local base = {
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
}

-- Plain servers that only need NvChad defaults
for _, name in ipairs({ "pyright", "ruff", "clangd", "jdtls", "ts_ls" }) do
	vim.lsp.config(name, base)
end

-- TypeScript / JavaScript
-- vim.lsp.config("tsc_native", {
-- 	cmd = function(dispatchers, config)
-- 		local root = config.root_dir
-- 		if not root then
-- 			return
-- 		end
--
-- 		local tsc = vim.fs.joinpath(root, "node_modules", ".bin", vim.fn.has("win32") == 1 and "tsc.cmd" or "tsc")
--
-- 		local cmd
--
-- 		if vim.fn.has("win32") == 1 then
-- 			cmd = {
-- 				"cmd.exe",
-- 				"/C",
-- 				tsc,
-- 				"--lsp",
-- 				"--stdio",
-- 			}
-- 		else
-- 			cmd = {
-- 				tsc,
-- 				"--lsp",
-- 				"--stdio",
-- 			}
-- 		end
--
-- 		return vim.lsp.rpc.start(cmd, dispatchers)
-- 	end,
--
-- 	filetypes = {
-- 		"javascript",
-- 		"javascriptreact",
-- 		"typescript",
-- 		"typescriptreact",
-- 	},
--
-- 	root_dir = function(bufnr, on_dir)
-- 		local root = vim.fs.root(bufnr, { ".git" })
--
-- 		if root then
-- 			on_dir(root)
-- 		end
-- 	end,
-- })

vim.lsp.enable("tsc_native")

-- Enable after all configs are defined
vim.lsp.enable({ "pyright", "ruff", "clangd", "jdtls", "ts_ls" })
