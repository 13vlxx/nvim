vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local lualine = require("lualine")

-- nom du dossier courant, pour la statusline de nvim-tree
local tree_folder = {
	function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
	icon = "󰉋",
}

-- formateur conform qui tournera à la sauvegarde. Mis en cache par buffer : le calcul
-- (~0,6 ms, cherche les configs biome/oxfmt) se referait à chaque rafraîchissement
local function formatter()
	if vim.b.formatter == nil then
		local names = vim.tbl_map(function(f)
			return f.name
		end, require("conform").list_formatters_to_run(0))
		vim.b.formatter = table.concat(names, " ")
	end
	return vim.b.formatter
end
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "BufWritePost" }, {
	callback = function(args)
		vim.b[args.buf].formatter = nil
	end,
})

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
			-- noice masque « recording @q » : sans ça, rien n'indique qu'une macro s'enregistre
			{
				function()
					return require("noice").api.status.mode.get()
				end,
				cond = function()
					return package.loaded.noice ~= nil and require("noice").api.status.mode.has()
				end,
				color = "WarningMsg",
			},
			-- serveurs LSP attachés, avec un spinner pendant l'indexation
			{ "lsp_status", ignore_lsp = { "copilot" } },
			-- conform est chargé à la première ouverture de fichier
			{
				formatter,
				icon = "\u{f0262}",
				cond = function()
					return package.loaded.conform ~= nil
				end,
			},
			-- encodage et fins de ligne seulement quand ils sortent de l'ordinaire (latin1, CRLF…)
			{
				"encoding",
				cond = function()
					return vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8"
				end,
			},
			{
				"fileformat",
				cond = function()
					return vim.bo.fileformat ~= "unix"
				end,
			},
			{ "filetype" },
		},
	},
})
