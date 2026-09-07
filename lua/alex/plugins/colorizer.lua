-- fork maintenu de norcalli/nvim-colorizer.lua (l'original est archivé)
return {
	"catgoose/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{ "<leader>ct", "<cmd>ColorizerToggle<cr>", desc = "Toggle colorizer" },
	},
	opts = {
		filetypes = {
			"*",
			-- les buffers de sortie n'ont rien à coloriser et repeignent souvent
			"!lazy",
			"!mason",
			"!TelescopePrompt",
			"!trouble",
			-- les noms de couleurs ("red", "steelblue") sont des valeurs réelles dans
			-- une feuille de style, mais de simples mots ailleurs : on ne les active
			-- que là où ils veulent dire quelque chose
			css = { names = true },
			scss = { names = true },
			sass = { names = true },
			less = { names = true },
			html = { names = true },
		},
		user_default_options = {
			names = false,
			RRGGBBAA = true, -- #RRGGBBAA
			AARRGGBB = true, -- 0xAARRGGBB (couleurs Android/Compose)
			rgb_fn = true, -- rgb() / rgba()
			hsl_fn = true, -- hsl() / hsla()
			css_fn = true, -- toutes les fonctions couleur CSS
			-- "both" = table statique des classes Tailwind + noms remontés par le
			-- LSP tailwindcss (donc les couleurs custom du tailwind.config aussi)
			tailwind = "both",
			tailwind_opts = { update_names = true },
			sass = { enable = true, parsers = { "css" } },
			-- pastille inline plutôt que de repeindre le texte : lisible aussi bien
			-- sur `#1a1b26` que sur une classe `bg-primary-500`
			mode = "virtualtext",
			virtualtext = "󱓻",
			virtualtext_inline = "before",
			virtualtext_mode = "foreground",
		},
	},
}
