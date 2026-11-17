vim.pack.add({
	"https://github.com/folke/noice.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/rcarriga/nvim-notify",
})

require("notify").setup({
	max_width = 40,
	max_height = 3,
})

require("noice").setup({
	lsp = {
		-- markdown coloré par treesitter aussi dans la doc de nvim-cmp
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		lsp_doc_border = true, -- bordure autour du hover (K) et de la signature
		long_message_to_split = true, -- un long message s'ouvre dans un split au lieu d'être tronqué
	},
	routes = {
		{
			filter = {
				event = "notify",
				find = "No information available",
			},
			opts = { skip = true },
		},
	},
})
