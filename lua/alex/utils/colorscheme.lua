-- Source de vérité pour le colorscheme : liste des thèmes disponibles,
-- application, changement à chaud
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

-- Applique un thème (tous sont sur le runtimepath via vim.pack).
-- Retourne false (sans lever d'erreur) si le thème n'existe pas.
function M.set(name)
	if not vim.tbl_contains(vim.fn.getcompletion("", "color"), name) then
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
