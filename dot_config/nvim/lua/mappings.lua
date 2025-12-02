require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Split
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>ss", "<cmd>split<CR>", { desc = "Horizontal split" })

-- conda nvim
map("n", "<leader>cc", function()
	vim.cmd("CondaActivate")
end, { desc = "Choose conda environment" })

-- Copitlot Chat
local chat = require("CopilotChat")
map("n", "<leader>aa", chat.toggle, { desc = "AI Toggle" })
map("v", "<leader>aa", chat.open, { desc = "AI Open" })
map("n", "<leader>ax", chat.reset, { desc = "AI Reset" })
map("n", "<leader>as", chat.stop, { desc = "AI Stop" })
map("n", "<leader>am", chat.select_model, { desc = "AI Models" })
map({ "n", "v" }, "<leader>ap", chat.select_prompt, { desc = "AI Prompts" })
map({ "n", "v" }, "<leader>aq", function()
	vim.ui.input({
		prompt = "AI Question> ",
	}, function(input)
		if input ~= "" then
			chat.ask(input)
		end
	end)
end, { desc = "AI Question" })

-- Resizing splits
map("n", "<C-S-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- Navigation
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
