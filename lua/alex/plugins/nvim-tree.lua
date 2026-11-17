vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local nvimtree = require("nvim-tree")

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
	view = {
		width = 40,
		relativenumber = true,
	},
	renderer = {
		-- chemin de la racine avec ~ (ex: ~/Documents/Pro/oreus/oreus_back_end_v1)
		root_folder_label = ":~",
		highlight_git = "name", -- noms colorés selon leur état git (modifié, nouveau, ignoré…)
		indent_markers = {
			enable = true,
			icons = { corner = "╰" }, -- arrondi, comme les bordures des fenêtres flottantes
		},
		icons = {
			-- statut git dans la colonne de signes, à gauche : les noms restent alignés, et un
			-- nom long n'est pas recouvert comme avec "right_align"
			git_placement = "signcolumn",
			glyphs = {
				git = {
					unstaged = "●",
					staged = "✓",
					unmerged = "\u{e727}",
					renamed = "➜",
					untracked = "★",
					deleted = "\u{f458}",
					ignored = "◌",
				},
				-- mêmes chevrons que les plis (fillchars dans options.lua)
				folder = {
					arrow_closed = "\u{f460}",
					arrow_open = "\u{f47c}",
				},
			},
		},
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	filters = {
		custom = { ".DS_Store", "^\\.git$" }, -- U pour les réafficher
	},
	git = {
		ignore = false,
	},
})

-- séparateur arbre/éditeur de la couleur de l'arbre : sur la ligne de statut, nvim peint
-- cette colonne avec la statusline de l'arbre, sinon un cran apparaît avant « NORMAL »
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local bg = vim.api.nvim_get_hl(0, { name = "NvimTreeNormal", link = false }).bg
		if bg then -- thème transparent ou sans fond d'arbre : rien à aligner, on garde son séparateur
			vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = bg, bg = bg })
		end
	end,
})

-- set keymaps
local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
