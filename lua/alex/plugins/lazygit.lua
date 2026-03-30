return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
	},
	config = function()
		-- Permet à ESC de fonctionner correctement dans Lazygit
		vim.g.lazygit_floating_window_use_plenary = 0
		-- Configure les mappings pour le terminal Lazygit
		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "*lazygit*",
			callback = function()
				-- Désactive le mapping ESC pour ce buffer spécifique
				vim.keymap.set("t", "<esc>", "<esc>", { buffer = true, noremap = true, silent = true })
			end,
		})
	end,
}
