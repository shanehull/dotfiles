local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.filetype.add({
	pattern = {
		["*.hujson"] = "hujson",
	},
})
-- Set hujson to jsonc
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("hujson_ft"),
	pattern = { "hujson" },
	callback = function()
		vim.opt_local.ft = "jsonc"
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
