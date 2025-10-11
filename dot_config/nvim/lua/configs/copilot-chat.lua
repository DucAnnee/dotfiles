local icons = require("configs.icons")

local opts = {
	debug = false,
	temperature = 0,
	sticky = {
		"#buffers",
		"#gitdiff",
	},
	diff = "block",
	chat_autocomplete = false,
	auto_fold = true,
	headers = {
		user = icons.ui.User,
		assistant = icons.ui.Bot,
		tool = icons.ui.Tool,
	},
	mappings = {
		reset = false,
		complete = {
			insert = "<Tab>",
		},
	},
	prompts = {
		Explain = {
			mapping = "<leader>ae",
			description = "AI Explain",
		},
		Review = {
			mapping = "<leader>ar",
			description = "AI Review",
		},
		Tests = {
			mapping = "<leader>at",
			description = "AI Tests",
		},
		Fix = {
			mapping = "<leader>af",
			description = "AI Fix",
		},
		Optimize = {
			mapping = "<leader>ao",
			description = "AI Optimize",
		},
		Docs = {
			mapping = "<leader>ad",
			description = "AI Documentation",
		},
		Commit = {
			mapping = "<leader>ac",
			description = "AI Generate Commit",
		},
	},
	providers = {
		github_models = {
			disabled = false,
		},
	},
}
return opts
