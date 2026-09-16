local local_registry = vim.fn.stdpath("config"):gsub("\\", "/") .. "/mason-local-registry"

local options = {
	ensure_installed = {
		"lua-language-server",
		"ruff",
		"black",
		"isort",
		"clangd",
		"clang-format",
		"stylua",
		"prettier",
	}, -- not an option from mason.nvim

	PATH = "skip",

	ui = {
		icons = {
			package_pending = " ",
			package_installed = "󰄳 ",
			package_uninstalled = " 󰚌",
		},

		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
			cancel_installation = "<C-c>",
		},
	},

	max_concurrent_installers = 10,

	registries = {
		"file:" .. local_registry,
		"github:mason-org/mason-registry",
	},
}

return options
