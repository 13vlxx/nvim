-- Source de vérité pour le colorscheme : liste des thèmes disponibles,
-- application (avec chargement lazy.nvim à la demande), changement à chaud
-- et persistance du dernier thème choisi.
--
--   require("alex.utils.colorscheme").set("kanagawa")
local M = {}

local state_file = vim.fn.stdpath("data") .. "/last-colorscheme"
M.default = "tokyonight"

-- Thème sauvegardé, ou nil
function M.get()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local name = vim.trim(f:read("*l") or "")
	f:close()
	return name ~= "" and name or nil
end

function M.save(name)
	local f = io.open(state_file, "w")
	if f then
		f:write(name .. "\n")
		f:close()
	end
end

-- Plugin lazy.nvim qui fournit `colors/<name>.{lua,vim}`, ou nil
local function plugin_for(name)
	for _, plugin in pairs(require("lazy.core.config").plugins) do
		for _, ext in ipairs({ "lua", "vim" }) do
			if vim.uv.fs_stat(plugin.dir .. "/colors/" .. name .. "." .. ext) then
				return plugin
			end
		end
	end
end

-- Thèmes disponibles : ceux déjà sur le runtimepath + ceux des plugins
-- lazy.nvim pas encore chargés
function M.available()
	local names = {}
	for _, name in ipairs(vim.fn.getcompletion("", "color")) do
		names[name] = true
	end
	for _, plugin in pairs(require("lazy.core.config").plugins) do
		for _, file in ipairs(vim.fn.glob(plugin.dir .. "/colors/*.{lua,vim}", true, true)) do
			names[vim.fn.fnamemodify(file, ":t:r")] = true
		end
	end
	return vim.tbl_keys(names)
end

-- Applique un thème : charge son plugin si besoin puis :colorscheme.
-- Retourne false (sans lever d'erreur) si le thème n'existe pas.
function M.set(name)
	local plugin = plugin_for(name)
	if plugin and not plugin._.loaded then
		require("lazy").load({ plugins = { plugin.name } })
	elseif not plugin and not vim.tbl_contains(vim.fn.getcompletion("", "color"), name) then
		return false
	end
	-- déclenche ColorSchemePre/ColorScheme ; la persistance se fait dans l'autocmd
	vim.cmd.colorscheme(name)
	return true
end

function M.setup()
	-- sauvegarde à chaque :colorscheme (via set() ou la commande directe)
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("alex_persist_colorscheme", { clear = true }),
		callback = function(ev)
			if ev.match and ev.match ~= "" then
				M.save(ev.match)
			end
		end,
	})

	-- applique le dernier thème, ou le défaut s'il n'existe plus
	local name = M.get() or M.default
	if not M.set(name) then
		vim.notify("Colorscheme '" .. name .. "' introuvable, retour à " .. M.default, vim.log.levels.WARN)
		M.set(M.default)
	end
end

return M
