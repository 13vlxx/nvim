vim.pack.add({
	"https://github.com/mbbill/undotree",
})

vim.g.undotree_SetFocusWhenToggle = 1
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
