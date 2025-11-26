local icons = require("configs.icons")

return {
	temperature = 0.1,
	window = {
		layout = "vertical",
		width = 0.3,
		border = "rounded",
		zindex = 100,
	},
	model = "claude-sonnet-4.5",
	sticky = {
		"#buffer:listed",
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
