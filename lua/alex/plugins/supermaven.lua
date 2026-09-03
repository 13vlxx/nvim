return {
	"supermaven-inc/supermaven-nvim",
	lazy = false, -- démarre le serveur dès l'ouverture de nvim, pas seulement en insert mode
	priority = 100,
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-l>",
			},
			ignore_filetypes = {
				yaml = true,
				markdown = true,
				help = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				cvs = true,
				[""] = true,
			},
			color = {
				suggestion_color = "#6c7086",
				cterm = 244,
			},
			log_level = "warn",
			disable_inline_completion = false, -- ghost text activé
			disable_keymaps = false,
			condition = function()
				return false
			end,
		})
	end,
}
