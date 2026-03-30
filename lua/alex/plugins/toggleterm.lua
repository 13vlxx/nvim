return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<D-j>]], -- Command+j sur Mac
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true, -- Fonctionne aussi en mode insertion
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		})

		-- Keymaps additionnels
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts) -- ESC pour sortir du mode terminal
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Raccourcis pour les terminaux multiples (comme des tabs)
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
		vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
		vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
		vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })

		-- Terminaux multiples (comme des onglets) - utilise des numéros
		vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<CR>", { desc = "Toggle terminal 1" })
		vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<CR>", { desc = "Toggle terminal 2" })
		vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<CR>", { desc = "Toggle terminal 3" })
		vim.keymap.set("n", "<leader>t4", "<cmd>4ToggleTerm<CR>", { desc = "Toggle terminal 4" })

		-- Ouvrir des liens dans le terminal (en mode normal)
		vim.keymap.set("n", "gx", function()
			local line = vim.api.nvim_get_current_line()
			local url = line:match("https?://[%w-._~:/?#%[%]@!$&'()*+,;=%%]+")
			if url then
				vim.fn.jobstart({ "open", url }, { detach = true })
				print("Opening: " .. url)
			else
				print("No URL found on this line")
			end
		end, { desc = "Open URL under cursor" })
	end,
}
