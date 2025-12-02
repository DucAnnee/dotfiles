local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

local autocmd = vim.api.nvim_create_autocmd

-- Auto-save when leaving insert mode
autocmd("InsertLeave", {
	pattern = "*",
	command = "silent! write",
})

-- Open PDFs with zathura (non-Windows only)
autocmd("BufReadCmd", {
	pattern = "*.pdf",
	callback = function(args)
		if is_windows then
			return
		end
		if vim.fn.executable("zathura") ~= 1 then
			return
		end

		local filename = vim.api.nvim_buf_get_name(args.buf)
		if filename == "" then
			return
		end

		vim.fn.jobstart({ "zathura", filename }, { detach = true })

		-- close the dummy buffer after spawning viewer
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end)
	end,
})

-- Open images with sxiv (non-Windows only)
autocmd("BufReadCmd", {
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
	callback = function(args)
		if is_windows then
			return
		end
		if vim.fn.executable("sxiv") ~= 1 then
			return
		end

		local filename = vim.api.nvim_buf_get_name(args.buf)
		if filename == "" then
			return
		end

		vim.fn.jobstart({ "sxiv", filename }, { detach = true })

		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end)
	end,
})
