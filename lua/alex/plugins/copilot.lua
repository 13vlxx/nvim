return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		lazy = false, -- démarre le serveur dès l'ouverture de nvim
		config = function()
			require("copilot").setup({
				-- serveur natif au lieu de l'agent Node : démarrage et overhead réduits
				server = {
					type = "binary",
					custom_server_filepath = nil,
				},
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true, -- ghost text
					auto_trigger = true,
					hide_during_completion = true, -- évite le clignotement quand cmp s'ouvre
					debounce = 15,
					trigger_on_accept = true,
					keymap = {
						accept = "<Tab>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
						toggle_auto_trigger = false,
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				server_opts_overrides = {},
			})
		end,
	},
}
