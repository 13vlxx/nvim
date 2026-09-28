return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = function(_, path)
					local parts = vim.split(path, "/", { plain = true })
					if #parts <= 3 then
						return path
					end
					return "../" .. table.concat(parts, "/", #parts - 2)
				end,
				preview = { filesize_limit = 0.5 },
				layout_config = {
					width = 0.95,
					horizontal = { preview_width = 0.6 },
					vertical = { preview_width = 0.6 },
				},
				wrap_results = true,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--no-ignore-vcs",
						"--glob", "!**/.git/*",
						"--glob", "!**/node_modules/*",
						"--glob", "!**/dist/*",
						"--glob", "!**/.venv/*",
						"--glob", "!**/target/*",
						"--glob", "!*.pyc",
						"--glob", "!*.o",
					},
				},
				diagnostics = {
					line_width = "full",
					trim_text = false,
				},
			},
		})

		telescope.load_extension("fzf")

		vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		vim.keymap.set(
			"n",
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "Find string under cursor in cwd" }
		)
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
