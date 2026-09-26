local icons = require("configs.icons")

return {
	temperature = 0.2,
	window = {
		layout = "vertical",
		width = 0.4,
		border = "rounded",
		zindex = 100,
	},
	model = "gpt-5.4-mini",
	sticky = {
		"#buffer:listed",
		"#file:../AGENTS.md",
		"#file:./guidelines.md",
		"#file:./src/components/code-template.txt",
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
