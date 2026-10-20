return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- nom du dossier courant, pour la statusline de nvim-tree
		local tree_folder = {
			function()
				return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			end,
			icon = "󰉋",
		}

		-- theme = "auto" : lualine suit le colorscheme actif
		lualine.setup({
			options = {
				theme = "auto",
			},
			-- statusline dédiée pour la fenêtre nvim-tree : nom du dossier courant,
			-- + la branche git seulement quand l'arbre a le focus
			extensions = {
				{
					filetypes = { "NvimTree" },
					sections = {
						lualine_a = { tree_folder },
						lualine_b = {
							{
								"branch",
								-- tronque la branche pour qu'elle tienne dans la largeur de l'arbre
								fmt = function(str)
									local folder = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
									-- ~11 colonnes prises par les icônes, paddings et séparateurs
									local max = vim.api.nvim_win_get_width(0) - vim.fn.strdisplaywidth(folder) - 11
									if max < 5 then
										return ""
									end
									if vim.fn.strdisplaywidth(str) > max then
										return vim.fn.strcharpart(str, 0, max - 1) .. "…"
									end
									return str
								end,
							},
						},
					},
					inactive_sections = {
						lualine_a = { vim.deepcopy(tree_folder) },
					},
				},
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat", symbols = { unix = "" } },
					{ "filetype" },
				},
			},
		})
	end,
}
