-- Persistance du colorscheme : le dernier thème appliqué avec :colorscheme
-- est écrit dans un fichier et rechargé au prochain démarrage.
local M = {}

local state_file = vim.fn.stdpath("data") .. "/last-colorscheme"
M.default = "tokyonight"

local function read()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local name = vim.trim(f:read("*l") or "")
	f:close()
	return name ~= "" and name or nil
end

local function write(name)
	local f = io.open(state_file, "w")
	if f then
		f:write(name .. "\n")
		f:close()
	end
end

function M.setup()
	-- sauvegarde à chaque :colorscheme
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("alex_persist_colorscheme", { clear = true }),
		callback = function(ev)
			if ev.match and ev.match ~= "" then
				write(ev.match)
			end
		end,
	})

	-- applique le dernier thème, ou le défaut s'il n'existe plus
	local name = read() or M.default
	if not pcall(vim.cmd.colorscheme, name) then
		vim.notify("Colorscheme '" .. name .. "' introuvable, retour à " .. M.default, vim.log.levels.WARN)
		vim.cmd.colorscheme(M.default)
	end
end

return M
