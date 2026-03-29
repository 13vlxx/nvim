-- Configuration des highlights pour les fenêtres flottantes
-- Fond bleu uniforme pour tous les popups

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- Couleur de fond bleu foncé uniforme pour tous les popups
		local bg_color = "#1a1f2e" -- Bleu foncé
		
		-- Menu de complétion (Ctrl+Space)
		vim.api.nvim_set_hl(0, "Pmenu", { bg = bg_color, fg = "#e4e4e4" })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2d3548", fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = bg_color })
		vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#3d4556" })
		
		-- Fenêtres flottantes (Shift+K, diagnostics, etc.)
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color, fg = "#e4e4e4" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg_color, fg = "#3d4556" })
		
		-- Items de complétion
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82aaff", bold = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82aaff" })
		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#7ee787" })
	end,
})

-- Appliquer immédiatement si un colorscheme est déjà chargé
vim.schedule(function()
	vim.cmd("doautocmd ColorScheme")
end)
