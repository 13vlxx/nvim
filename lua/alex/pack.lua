-- Plugins gérés par vim.pack (natif depuis Nvim 0.12) : chaque fichier de
-- plugins/ puis plugins/lsp/ ajoute ses plugins avec vim.pack.add() et les configure.
-- Mise à jour : :lua vim.pack.update() (:write pour valider, :quit pour annuler).

-- Avant le premier vim.pack.add() : sur une machine neuve, tout le lockfile s'installe dès cet appel
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and kind ~= "delete" then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		elseif name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- Fichiers chargés plus tard, comme les event = … de lazy.nvim : au premier fichier
-- ouvert, ou juste après le premier affichage (UIEnter + vim.schedule = VeryLazy)
local file, ui = { "BufReadPre", "BufNewFile" }, { "UIEnter" }
local deferred = {
	conform = file,
	["git-signs"] = file,
	["indent-blankline"] = file,
	linting = file,
	["lsp-config"] = file,
	treesitter = file,
	autopairs = ui,
	colorizer = ui,
	copilot = ui,
	dressing = ui,
	["image-support"] = ui,
	noice = ui,
	["nvim-cmp"] = ui,
	["nvim-ts-autotag"] = ui,
	["nvim-ufo"] = ui,
	["render-markdown"] = ui,
	substitute = ui,
	surround = ui,
	telescope = ui,
	["todo-comments"] = ui,
	toggleterm = ui,
	trouble = ui,
	wilder = ui,
}

local function load(mod)
	local rtp = vim.api.nvim_list_runtime_paths()
	-- comme lazy.nvim : un fichier en erreur ne bloque pas les autres
	local ok, err = pcall(require, mod)
	if not ok then
		vim.notify(err, vim.log.levels.ERROR)
	end
	-- vim.pack ne source after/plugin/ qu'après VimEnter : pour un fichier passé en argument,
	-- le groupe « file » est chargé avant, et ibl n'aurait pas :IBLEnable
	if vim.v.vim_did_enter == 1 then
		return
	end
	for _, dir in ipairs(vim.api.nvim_list_runtime_paths()) do
		if dir:match("/after$") and not vim.tbl_contains(rtp, dir) then
			for _, f in ipairs(vim.fn.glob(dir .. "/plugin/**/*.{vim,lua}", false, true)) do
				vim.cmd.source(f)
			end
		end
	end
end

local queues = { [file] = {}, [ui] = {} }
for _, mod in ipairs({ "alex.plugins", "alex.plugins.lsp" }) do
	local dir = vim.fn.stdpath("config") .. "/lua/" .. mod:gsub("%.", "/")
	for _, path in ipairs(vim.fn.glob(dir .. "/*.lua", false, true)) do
		local name = vim.fn.fnamemodify(path, ":t:r")
		if deferred[name] then
			table.insert(queues[deferred[name]], mod .. "." .. name)
		else
			load(mod .. "." .. name)
		end
	end
end

for events, mods in pairs(queues) do
	local group = vim.api.nvim_create_augroup("alex-pack-" .. events[1], { clear = true })
	vim.api.nvim_create_autocmd(events, {
		group = group,
		callback = function()
			vim.api.nvim_del_augroup_by_id(group) -- une seule fois, quel que soit l'événement
			local function run()
				for _, mod in ipairs(mods) do
					load(mod)
				end
			end
			if events == ui then
				vim.schedule(run)
			else
				run()
			end
		end,
	})
end
