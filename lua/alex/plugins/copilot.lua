-- Autocomplétion IA en ghost text via GitHub Copilot (plan étudiant : complétions illimitées).
-- Première utilisation : `:Copilot auth` pour connecter le compte GitHub.
--
-- Lignes vs blocs : c'est le serveur Copilot qui décide, le même que VS Code, Zed et JetBrains.
-- En TS/JS/Go il fait de la « révélation progressive » : sur une ligne vide, une seule ligne
-- d'abord, puis chaque <Tab> renvoie le bloc suivant (3-4 lignes, ~250 ms). Taper la ligne
-- soi-même au lieu de <Tab> le fait repartir en une ligne (Zed et VS Code font pareil).
-- Python et les autres langages reçoivent directement le bloc entier sur une ligne vide.
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VeryLazy", -- démarre le serveur dès l'ouverture de nvim, pas seulement en insert mode
	opts = {
		-- serveur natif au lieu de l'agent Node : démarrage et overhead réduits
		server = { type = "binary" },
		panel = { enabled = false },
		suggestion = {
			enabled = true,
			auto_trigger = true,
			-- nvim-cmp ouvre son menu presque à chaque frappe : sans ça, Copilot ne proposerait quasi rien
			hide_during_completion = false,
			debounce = 15,
			max_lines = nil,
			-- pas de max_lines : il ne fait que couper les suggestions multi-lignes
			trigger_on_accept = true,
			-- sans suggestion affichée, chaque touche garde son comportement normal
			keymap = {
				accept = "<Tab>",
				accept_word = "<C-l>",
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
				toggle_auto_trigger = false,
			},
		},
		filetypes = {
			yaml = true, -- désactivé par défaut dans copilot.lua
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			TelescopePrompt = false,
			["."] = false,
		},
	},
	config = function(_, opts)
		require("copilot").setup(opts)

		-- Correctif d'un bug de copilot.lua (commit f643a64, avril 2025, toujours là en v3.2.3) :
		-- après une acceptation complète, il ignore le déplacement du curseur et ne redemande rien
		-- au serveur. Or c'est cette requête qui renvoie le bloc suivant (VS Code, Zed et le client
		-- natif de Neovim la font). Amont, le fix tient en une ligne :
		-- `ignore_next_cursor_moved = accepted_partial` dans M.accept().
		-- Ici, si l'acceptation était complète (plus rien d'affiché ensuite), on relance accept() :
		-- sans suggestion visible, trigger_on_accept en fait une nouvelle requête.
		local suggestion = require("copilot.suggestion")
		local accept = suggestion.accept
		suggestion.accept = function(modifier)
			local was_visible = suggestion.is_visible()
			accept(modifier)
			if was_visible then
				-- passe après l'insertion du texte, que copilot.lua planifie lui aussi
				vim.schedule(function()
					if not suggestion.is_visible() then
						accept()
					end
				end)
			end
		end

		-- même gris que l'ancien ghost text, réappliqué à chaque :colorscheme
		local function set_hl()
			vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#6c7086", ctermfg = 244 })
		end
		set_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("alex_copilot", { clear = true }),
			callback = set_hl,
		})
	end,
}
