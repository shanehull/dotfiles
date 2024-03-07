return {
	{
		"huggingface/llm.nvim",
		enabled = false,
		opts = {
			enable_suggestions_on_files = {
				"*.*",
			},
			backend = "ollama",
			model = "starcoder2:7b",
			url = "http://192.168.1.34:11434/api/generate",
			--url = "http://127.0.0.1:11434/api/generate",
			debounce_ms = 1000,
			lsp = {
				bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
			},
			tokenizer = {
				repository = "bigcode/starcoder2-7b",
			},
			request_body = {
				parameters = {
					max_new_tokens = 128,
					temperature = 0.2,
					top_p = 0.95,
				},
			},
			fim = {
				enabled = true,
				prefix = "<fim_prefix>",
				middle = "<fim_middle>",
				suffix = "<fim_suffix>",
			},
			context_window = 8192,
		},
	},
}
