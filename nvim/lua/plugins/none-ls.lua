return {
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		config = function()
			local null_ls = require("null-ls")

			local eslint_d_diag = require("none-ls.diagnostics.eslint_d")
			local eslint_d_actions = require("none-ls.code_actions.eslint_d")

			local h = require("null-ls.helpers")
			local cmd_resolver = require("null-ls.helpers.command_resolver")
			local methods = require("null-ls.methods")
			local u = require("null-ls.utils")

			local FORMATTING = methods.internal.FORMATTING

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.golines,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.alejandra,
					null_ls.builtins.formatting.terraform_fmt,
					null_ls.builtins.formatting.yamlfmt,
					null_ls.builtins.formatting.prettierd.with({
						filetypes = {
							"javascript",
							"typescript",
							"css",
							"scss",
							"html",
							"json",
							"jsonc",
							"graphql",
							"pandoc",
							"markdown",
							"md",
						},
						args = function(params)
							if params.method == FORMATTING then
								return { "$FILENAME" }
							end

							local row, end_row = params.range.row - 1, params.range.end_row - 1
							local col, end_col = params.range.col - 1, params.range.end_col - 1
							local start_offset = vim.api.nvim_buf_get_offset(params.bufnr, row) + col
							local end_offset = vim.api.nvim_buf_get_offset(params.bufnr, end_row) + end_col

							return {
								"--single-quote",
								"$FILENAME",
								"--range-start=" .. start_offset,
								"--range-end=" .. end_offset,
							}
						end,
						dynamic_command = cmd_resolver.from_node_modules(),
						to_stdin = true,
						cwd = h.cache.by_bufnr(function(params)
							return u.cosmiconfig("prettier")(params.bufname)
						end),
					}),
					eslint_d_diag,
					null_ls.builtins.formatting.mix,
					null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.diagnostics.statix,
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.yamllint,
					null_ls.builtins.diagnostics.credo,
					null_ls.builtins.completion.spell,
					null_ls.builtins.completion.luasnip,
					eslint_d_actions,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

						vim.api.nvim_clear_autocmds({
							group = augroup,
							buffer = bufnr,
						})

						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
}
