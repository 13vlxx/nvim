return {
	"okuuva/auto-save.nvim",
	event = { "InsertLeave", "TextChanged" },
	opts = {
		enabled = true,
		trigger_events = {
			immediate_save = { "BufLeave", "FocusLost" }, -- Sauvegarde quand tu quittes le buffer ou la fenêtre
			defer_save = { "InsertLeave", "TextChanged" }, -- Sauvegarde après modification
			cancel_deferred_save = { "InsertEnter" },
		},
		condition = function(buf)
			local fn = vim.fn
			local utils = require("auto-save.utils.data")

			-- Ne pas autosave pour certains types de fichiers
			if utils.not_in(fn.getbufvar(buf, "&filetype"), { "oil", "harpoon", "toggleterm" }) then
				return true
			end
			return false
		end,
		write_all_buffers = false, -- Sauvegarde seulement le buffer actuel
		debounce_delay = 500, -- Attend 0.5 seconde après la dernière modification avant de sauvegarder
		callbacks = {
			enabling = function()
				print("AutoSave activé")
			end,
			disabling = function()
				print("AutoSave désactivé")
			end,
		},
	},
	config = function(_, opts)
		require("auto-save").setup(opts)

		-- Raccourci pour toggle autosave on/off
		vim.keymap.set("n", "<leader>as", "<cmd>ASToggle<CR>", { desc = "Toggle AutoSave" })
	end,
}
