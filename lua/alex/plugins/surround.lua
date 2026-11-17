-- tags stables plutôt que la branche main
vim.pack.add({
	{ src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("*") },
})

require("nvim-surround").setup()
