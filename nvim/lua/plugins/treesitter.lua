return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"bash",
				"javascript",
				"typescript",
				"c",
				"lua",
				"go",
				"terraform",
				"vim",
				"vimdoc",
				"yaml",
				"make",
				"nix",
				"gitcommit",
				"css",
				"regex",
				"markdown",
				"markdown_inline",
				"elixir",
				"heex",
				"eex",
			}

			require("nvim-treesitter").install(parsers)

			-- The `main` branch no longer auto-enables highlighting via opts;
			-- start it per buffer for any filetype that has an installed parser.
			vim.treesitter.language.register("eex", "eelixir")
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					if not lang then
						return
					end
					-- language.add reports (false, err) when no parser is installed;
					-- pcall's success flag alone isn't enough, so check the real return.
					local ok, added = pcall(vim.treesitter.language.add, lang)
					if ok and added then
						pcall(vim.treesitter.start, args.buf, lang)
					end
				end,
			})
		end,
	},
}
