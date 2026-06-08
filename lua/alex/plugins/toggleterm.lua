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
			open_mapping = [[<D-j>]],
			hide_numbers = true,
			autochdir = true,
			shade_terminals = false,
			highlights = {
				Normal = { link = "Normal" },
				NormalFloat = { link = "NormalFloat" },
				FloatBorder = { link = "FloatBorder" },
			},
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
			on_open = function(term)
				vim.opt_local.signcolumn = "no"
				vim.opt_local.foldcolumn = "0"
				vim.opt_local.statuscolumn = ""
			end,
			float_opts = {
				border = "curved",
				width = function()
					return math.floor(vim.o.columns * 0.85)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.8)
				end,
				winblend = 5,
				title_pos = "center",
			},
			winbar = {
				enabled = true,
				name_formatter = function(term)
					return "Terminal n°" .. term.id
				end,
			},
			responsiveness = {
				horizontal_breakpoint = 135,
			},
		})
		local function set_terminal_keymaps()
			local opts = { buffer = 0 }
			if vim.bo.filetype == "lazygit" or vim.api.nvim_buf_get_name(0):match("lazygit") then
				return
			end
			vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = set_terminal_keymaps,
		})

		vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<CR>", { desc = "Toggle terminal 1" })
		vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<CR>", { desc = "Toggle terminal 2" })
		vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<CR>", { desc = "Toggle terminal 3" })
		vim.keymap.set("n", "<leader>t4", "<cmd>4ToggleTerm<CR>", { desc = "Toggle terminal 4" })

		vim.keymap.set("n", "gx", function()
			local line = vim.api.nvim_get_current_line()
			local url = line:match("https?://[%w-._~:/?#%[%]@!$&'()*+,;=%%]+")
			if url then
				vim.ui.open(url)
			else
				print("No URL found on this line")
			end
		end, { desc = "Open URL under cursor" })
	end,
}
