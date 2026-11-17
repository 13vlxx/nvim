-- Colorschemes disponibles. Tous sont ajoutés au démarrage pour apparaître
-- dans la complétion de :colorscheme <Tab>.
-- La sélection/persistance est dans alex.utils.colorscheme.
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/gbprod/nord.nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	"https://github.com/Mofiqul/dracula.nvim",
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/rafamadriz/neon",
	"https://github.com/rebelot/kanagawa.nvim",
})

-- Le setup() d'un thème n'est lancé qu'avant son premier :colorscheme (ColorSchemePre) :
-- configurer les 8 thèmes au démarrage coûtait ~4 ms pour un seul affiché
local function on_load(pattern, setup)
	vim.api.nvim_create_autocmd("ColorSchemePre", { pattern = pattern, once = true, callback = setup })
end

on_load("tokyonight*", function()
	require("tokyonight").setup({
		style = "night",
		transparent = false,
	})
end)

on_load("catppuccin*", function()
	require("catppuccin").setup({
		flavour = "macchiato", -- latte, frappe, macchiato, mocha, auto
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
		-- détecte automatiquement les plugins installés via vim.pack
		-- (cmp, gitsigns, nvim-tree, telescope, treesitter, which-key, noice, ufo, …)
		auto_integrations = true,
	})
end)

on_load("nord", function()
	require("nord").setup({
		transparent = false,
		styles = { comments = { italic = true } },
	})
end)

on_load("gruvbox", function()
	require("gruvbox").setup({
		contrast = "", -- "hard", "soft" ou "" (défaut)
		transparent_mode = false,
	})
end)

on_load("rose-pine*", function()
	require("rose-pine").setup({
		variant = "main", -- main, moon, dawn
		styles = { transparency = false },
	})
end)

on_load("dracula*", function()
	require("dracula").setup({
		transparent_bg = false,
		italic_comment = true,
	})
end)

on_load({ "onedark*", "onelight", "vaporwave" }, function()
	require("onedarkpro").setup({
		options = { transparency = false },
	})
end)

on_load("kanagawa*", function()
	require("kanagawa").setup({
		transparent = false,
		theme = "wave", -- wave, dragon, lotus
	})
end)
