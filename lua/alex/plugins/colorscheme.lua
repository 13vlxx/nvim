return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = false,
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha", -- latte, frappe, macchiato, mocha, auto
			background = { -- utilisé quand flavour = "auto" (:h background)
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false, -- désactive la couleur de fond
			float = {
				transparent = false, -- fenêtres flottantes transparentes
				solid = false, -- style "solid" pour les bordures (voir :h winborder)
			},
			term_colors = false, -- définit g:terminal_color_*
			dim_inactive = {
				enabled = false, -- assombrit les fenêtres inactives
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = { -- styles des groupes généraux (:h highlight-args)
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			lsp_styles = { -- styles des diagnostics LSP (:h lsp-highlight)
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			color_overrides = {},
			custom_highlights = {},
			-- détecte automatiquement les plugins installés via lazy.nvim
			-- (cmp, gitsigns, nvim-tree, telescope, treesitter, which-key, noice, ufo, …)
			auto_integrations = true,
		},
	},
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = false,
			styles = { comments = { italic = true } },
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			contrast = "", -- "hard", "soft" ou "" (défaut)
			transparent_mode = false,
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		opts = {
			variant = "main", -- main, moon, dawn
			styles = { transparency = false },
		},
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent_bg = false,
			italic_comment = true,
		},
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			options = { transparency = false },
		},
	},
	{
		"rafamadriz/neon",
		lazy = false,
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = false,
			theme = "wave", -- wave, dragon, lotus
		},
	},
}
