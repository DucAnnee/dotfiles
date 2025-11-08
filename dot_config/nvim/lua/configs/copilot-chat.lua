local icons = require("configs.icons")

return {
	temperature = 0.1,
	window = {
		layout = "vertical",
		width = 0.3,
		border = "rounded",
		zindex = 100,
	},
	model = "gpt-5-codex",
	sticky = {
		"#buffer:listed",
		"#glob:**/*.tsx",
	},
	diff = "block",
	show_help = true,
	auto_fold = true,
	headers = {
		user = icons.ui.User,
		assistant = icons.ui.Bot,
		tool = icons.ui.Tool,
	},
}
