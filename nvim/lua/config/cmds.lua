-- Command to create a new zettelkasten style note in 0-inbox
vim.api.nvim_create_user_command("Zet", function()
	local directory = os.getenv("SECOND_BRAIN") .. "/0-inbox" or os.getenv("HOME") .. "secondbrain/0-inbox/"

	-- Try to get the file name from the user
	local status, result = pcall(function()
		Fname = vim.fn.input("File name: ", "", "file")
	end)
	-- Handle error (e.g. keyboard interrupt)
	if not status then
		print("Aborted:", result)
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
		error("Error creating file: " .. fpath)
	end
end, { desc = "Create a new zettelkasten style note" })

-- Add a keymap to create a new zettelkasten style note
vim.api.nvim_set_keymap("n", "<leader>Z", ":Zet<CR>", { desc = "New zettelkasten note" })

-- Command to insert a decision template
vim.api.nvim_create_user_command("Decision", function()
	local template = [[
**Mental/physical state:**

- [ ] Energized
- [ ] Focused
- [ ] Relaxed
- [ ] Confident
- [ ] Tired
- [ ] Accepting
- [ ] Accommodating
- [ ] Anxious
- [ ] Resigned
- [ ] Frustrated
- [ ] Angry

**Decision opportunity:**

**Variables:**

**Alternatives:**

**The decision:**

**Expected outcome and probabilities:**

**Additional context:**
    ]]

	-- Get the current cursor position
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	-- Insert the template at the current line
	vim.api.nvim_buf_set_lines(0, row, row, false, vim.split(template, "\n"))
end, {})

-- Add a keymap to insert a decision template
vim.api.nvim_set_keymap("n", "<leader>D", ":Decision<CR>", { desc = "New decision template" })
