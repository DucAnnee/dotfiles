require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Split
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>ss", "<cmd>split<CR>", { desc = "Horizontal split" })

-- conda nvim
map("n", "<leader>cc", function()
  vim.cmd "CondaActivate"
end, { desc = "Choose conda environment" })

-- Obsidian
-- local obs = require "obsidian"
-- -- Quick switch another note
-- map("n", "<leader>oo", function()
--   vim.cmd "ObsidianQuickSwitch"
-- end, { desc = "Obsidian Quick switch" })
-- -- Create new note
-- map("n", "<leader>on", function()
--   vim.cmd "ObsidianNew"
-- end, { desc = "Obsidian New note" })
-- -- Insert template
-- map("n", "<leader>otp", function()
--   vim.cmd "ObsidianTemplate"
-- end, { desc = "Obsidian Insert template" })
-- -- Create new note with template
-- map("n", "<leader>otn", function()
--   vim.cmd "ObsidianNewFromTemplate"
-- end, { desc = "Obsidian New note from Template" })
-- -- Paste image from clipboard
-- map("n", "<leader>oi", function()
--   vim.cmd "ObsidianPasteImg"
-- end, { desc = "Obsidian Paste image" })
-- -- Open TOC
-- map("n", "<leader>otc", function()
--   vim.cmd "ObsidianTOC"
-- end, { desc = "Obsidian Open TOC" })
-- -- Smart action
-- map("n", "<leader>o<CR>", function()
--   return obs.util.smart_action()
-- end, { desc = "Obsidian Smart action" })
