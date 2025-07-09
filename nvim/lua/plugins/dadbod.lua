return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		config = function()
			-- Get PostgreSQL environment vars
			local pg_host = vim.env.PGHOST
			local pg_port = vim.env.PGPORT
			local pg_user = vim.env.PGUSER
			local pg_password = vim.env.PGPASSWORD -- Can be nil
			local pg_database = vim.env.PGDATABASE

			-- Check if environment vars are set (PGPASSWORD optional)
			if pg_host and pg_port and pg_user and pg_database then
				local db_url_full = "postgresql://" .. pg_user
				local db_url_display = "postgresql://" .. pg_user
				local db_name = pg_database

				if pg_password then
					db_url_full = db_url_full .. ":" .. pg_password
					-- Mask the password
					db_url_display = db_url_display .. ":********"
				end

				db_url_full = db_url_full .. "@" .. pg_host .. ":" .. pg_port .. "/" .. pg_database
				db_url_display = db_url_display .. "@" .. pg_host .. ":" .. pg_port .. "/" .. pg_database

				-- If this is prod, name the connection accordingly
				if string.find(string.lower(pg_host), "prod", 1, true) then
					db_name = db_name .. " (prod)"
				end

				-- Set the vars that dadbod uses
				vim.env.DBUI_URL = db_url_full
				vim.env.DBUI_NAME = db_name

				vim.notify("Using DB_NAME: " .. db_name .. ", DBUI_URL: " .. db_url_display, vim.log.levels.INFO)
			end
		end,
	},
}
