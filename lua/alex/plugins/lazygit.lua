vim.pack.add({
	"https://github.com/kdheepak/lazygit.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

-- appelé par lazygit (os.edit) avant de quitter ; le fichier est ouvert
-- une fois la fenêtre flottante fermée, dans la fenêtre d'origine
local pending
_G.LazygitEdit = function(file, line)
	pending = { file = file, line = line }
end
vim.g.lazygit_on_exit_callback = function()
	if not pending then
		return
	end
	vim.cmd.edit(vim.fn.fnameescape(pending.file))
	if pending.line then
		vim.cmd(tostring(pending.line))
	end
	pending = nil
end

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazy git" })
