vim.pack.add({
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = true, -- Auto close on trailing </
	},
	-- Liste des filetypes où l'auto-closing est actif
	filetypes = {
		"html",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"tsx",
		"jsx",
		"rescript",
		"xml",
		"php",
		"markdown",
		"astro",
		"glimmer",
		"handlebars",
		"hbs",
	},
})
