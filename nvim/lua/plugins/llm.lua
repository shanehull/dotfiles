return {
	{
		"huggingface/llm.nvim",
		opts = {
			enable_suggestions_on_files = {
				"*.*",
			},
			backend = "ollama",
			model = "magicoder:latest",
			url = "http://192.168.1.34:11434/api/generate",
			debounce_ms = 1000,
			lsp = {
				bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
			},
			tokenizer = {
				repository = "ise-uiuc/Magicoder-S-CL-7B",
			},
			request_body = {
				options = {
					--temperature = 0.1,
					num_predict = 200,
				},
			},
			fim = {
				enabled = true,
				prefix = "<｜fim▁begin｜>",
				middle = "<｜fim▁hole｜>",
				suffix = "<｜fim▁end｜>",
			},
		},
	},
}
