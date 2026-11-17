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
