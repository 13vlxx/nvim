vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	{ src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") },
})

require("bufferline").setup({
	options = {
		mode = "tabs",
		diagnostics = "nvim_lsp", -- nombre d'erreurs/warnings sur chaque onglet
		-- sans ça, bufferline pose ses couleurs en « default » : celles calculées au démarrage avec
		-- le thème par défaut de nvim (barre noire) restent quand le vrai thème est appliqué
		themable = false,
		-- arbre au focus : l'onglet garde le nom du fichier ouvert au lieu de « NvimTree_1 »
		custom_filter = function(buf)
			return vim.bo[buf].filetype ~= "NvimTree"
		end,
	},
	-- toute la barre, onglet actif compris, du fond de l'arbre : un onglet de la couleur de
	-- l'éditeur faisait un bloc clair au-dessus de l'arbre. L'onglet actif se distingue par son
	-- texte clair et gras. Appelé à chaque changement de thème
	highlights = function(defaults)
		local tree_bg = vim.api.nvim_get_hl(0, { name = "NvimTreeNormal", link = false }).bg
		if not tree_bg then -- thème transparent : on garde les couleurs de bufferline
			return {}
		end
		local dark = {}
		for _, group in ipairs({ "fill", "background", "buffer_selected" }) do
			local bg = defaults.highlights[group].bg
			if bg then -- nil quand l'éditeur est transparent
				dark[bg] = true
			end
		end
		local hl = {}
		for name, attrs in pairs(defaults.highlights) do
			for key, value in pairs(attrs) do
				if dark[value] then
					hl[name] = hl[name] or {}
					hl[name][key] = ("#%06x"):format(tree_bg)
				end
			end
		end
		return hl
	end,
})
