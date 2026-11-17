vim.pack.add({
	"https://github.com/kevinhwang91/nvim-ufo",
	"https://github.com/kevinhwang91/promise-async",
})

require("ufo").setup({
	provider_selector = function(_, _, _)
		return { "treesitter", "indent" }
	end,
	open_fold_hl_timeout = 0,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
