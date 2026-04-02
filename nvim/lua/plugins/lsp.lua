return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v4.x",
		lazy = true,
		config = function()
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 1
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("gopls", {
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			vim.lsp.config("expert", {
				capabilities = capabilities,
				cmd = { "expert", "--stdio" },
				filetypes = { "elixir", "eelixir", "heex" },
				root_markers = { "mix.exs", ".git" },
				settings = {},
			})

			vim.lsp.config("ocamllsp", {
				fileypes = { "ocaml" },
			})

			vim.lsp.enable("gopls")
			vim.lsp.enable("expert")
			vim.lsp.enable("ocamllsp")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("eslint")
		end,
	},
}
