-- Command to create a new zettelkasten style note in 0-inbox
vim.api.nvim_create_user_command("Zet", function()
	local root = os.getenv("SECOND_BRAIN") or (os.getenv("HOME") .. "/secondbrain")
	local directory = root .. "/0-inbox"

	local status, title = pcall(function()
		return vim.fn.input("Note Title: ")
	end)

	if not status or title == "" then
		print("Aborted.")
		return
	end

	local slug = title:lower()
	slug = slug:gsub("[^a-z0-9%s-]", "")
	slug = slug:gsub("%s+", "-")
	slug = slug:gsub("-+", "-")
	slug = slug:gsub("^%-+", ""):gsub("%-+$", "")

	if slug == "" then
		print("Error: Title generated an empty ID.")
		return
	end

	local fpath = directory .. "/" .. slug .. ".md"

	local f_check = io.open(fpath, "r")
	if f_check then
		f_check:close()
		print("Error: Note already exists with ID: " .. slug)
		return
	end

	local current_date = os.date("%Y-%m-%d")

	local template = [[
---
id: %s
aliases: []
tags:
  - change-me
date: "%s"
---

# %s

]]

	local file_content = string.format(template, slug, current_date, title)

	local file = io.open(fpath, "w")
	if file then
		file:write(file_content)
		file:close()
		print("File created: " .. slug)

		vim.api.nvim_command("edit " .. fpath)
		vim.api.nvim_command("normal G")
		vim.api.nvim_command("startinsert")
	else
		error("Error creating file: " .. fpath)
	end
end, { desc = "Create a new zettelkasten note from Title" })

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
