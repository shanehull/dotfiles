return {
	"epwalsh/obsidian.nvim",
	version = "*", -- use latest release instead of latest commit
	lazy = true,
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/secondbrain/**/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/secondbrain/**/**.md",
		--"BufReadPre " .. vim.fn.expand("$SECOND_BRAIN") .. "/**/**.md",
		--"BufNewFile " .. vim.fn.expand("$SECOND_BRAIN") .. "/**/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "secondbrain",
				path = "~/secondbrain",
			},
		},
	},
	cmd = function()
		vim.opt.conceallevel = 2

		-- Command to create a new zettelkasten style note in 0-inbox
		vim.api.nvim_create_user_command("Zet", function()
			local directory = os.getenv("SECOND_BRAIN") .. "/0-inbox" or os.getenv("HOME") .. "secondbrain/0-inbox/"

			-- Try to get the file name from the user
			local status, result = pcall(function()
				Fname = vim.fn.input("File name: ", "", "file")
			end)
			-- Handle error (e.g. keyboard interrupt)
			if not status then
				print("An error occurred:", result)
				return
			end

			local fpath = directory .. "/" .. Fname .. ".md"

			local current_date = os.date("%Y-%m-%d")

			local title = Fname:gsub("%-", " "):gsub("(%w)(%w*)", function(first, rest)
				return first:upper() .. rest:lower()
			end)

			local template = [[
---
id: %s
aliases:
tags:
  - change-me
date: "%s"
---

# %s

]]

			local file_content = string.format(template, Fname, current_date, title)

			-- Write the content to the file
			local file = io.open(fpath, "w")
			if file then
				file:write(file_content)
				file:close()
				print("File created: " .. fpath)

				-- Open the file for writing
				vim.api.nvim_command("edit " .. fpath)
				vim.api.nvim_command("normal G")
				vim.api.nvim_command("startinsert")
			else
				print("Error creating file: " .. fpath)
			end
		end, {})
	end,
}
