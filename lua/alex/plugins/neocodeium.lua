return {
	"monkoose/neocodeium",
	event = "VeryLazy", -- démarre le serveur dès l'ouverture de nvim, pas seulement en insert mode
	config = function()
		local neocodeium = require("neocodeium")

		neocodeium.setup({
			silent = true, -- pas de "NeoCodeium: server started..." à chaque démarrage
			show_label = false, -- pas de compteur "1/7" dans la colonne des numéros
			filetypes = {
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				TelescopePrompt = false,
				[""] = false,
				["."] = false,
			},
		})

		-- Tab accepte la suggestion si elle est affichée, sinon Tab normal
		vim.keymap.set("i", "<Tab>", function()
			if neocodeium.visible() then
				neocodeium.accept()
			else
				-- "i" : insère le Tab en tête de la typeahead, avant les touches déjà tapées
				vim.api.nvim_feedkeys(vim.keycode("<Tab>"), "ni", false)
			end
		end, { desc = "NeoCodeium: accept suggestion" })
		vim.keymap.set("i", "<C-]>", neocodeium.clear, { desc = "NeoCodeium: clear suggestion" })
		vim.keymap.set("i", "<C-l>", neocodeium.accept_word, { desc = "NeoCodeium: accept word" })

		-- même couleur que l'ancien ghost text Supermaven, réappliquée à chaque :colorscheme
		local function set_hl()
			vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { fg = "#6c7086", ctermfg = 244 })
		end
		set_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("alex_neocodeium_hl", { clear = true }),
			callback = set_hl,
		})
	end,
}
