return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		-- Neovim détecte les fichiers compose comme du simple yaml : sans ce filetype,
		-- docker_compose_language_service ne s'attache jamais
		vim.filetype.add({
			pattern = {
				[".*/compose%.ya?ml"] = "yaml.docker-compose",
				[".*/compose%..+%.ya?ml"] = "yaml.docker-compose",
				[".*/docker%-compose%.ya?ml"] = "yaml.docker-compose",
				[".*/docker%-compose%..+%.ya?ml"] = "yaml.docker-compose",
			},
		})
	end,
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp", lazy = false },
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"b0o/schemastore.nvim",
	},
	config = function()
		local keymap = vim.keymap
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })
		keymap.set("n", "<leader>D", builtin.diagnostics, { noremap = true, silent = true })

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			virtual_text = { prefix = "●" },
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = true, wrap = true, max_width = 80 },
		})

		-- Commun à tous les serveurs. Les keymaps passent par LspAttach plutôt que par un
		-- on_attach par serveur, qui écrasait celui de lspconfig (:ClangdSwitchSourceHeader,
		-- :LspEslintFixAll, :LspPyrightOrganizeImports…)
		vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

		local eslint_fix_group = vim.api.nvim_create_augroup("alex-eslint-fix", { clear = true })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("alex-lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if not client then
					return
				end
				local bufnr = event.buf
				local opts = { noremap = true, silent = true, buffer = bufnr }

				-- Le formatage est géré uniquement par conform.nvim
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				if client.server_capabilities.definitionProvider then
					keymap.set("n", "gd", builtin.lsp_definitions, opts)
				end
				if client.server_capabilities.referencesProvider then
					keymap.set("n", "gR", builtin.lsp_references, opts)
				end
				if client.server_capabilities.implementationProvider then
					keymap.set("n", "gi", builtin.lsp_implementations, opts)
				end
				if client.server_capabilities.typeDefinitionProvider then
					keymap.set("n", "gt", builtin.lsp_type_definitions, opts)
				end

				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)
				keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

				-- yamlls (schéma compose de SchemaStore) propose déjà toutes ces clés : sans
				-- ça, chacune apparaît en double dans le menu. Hover et diagnostics restent
				if client.name == "docker_compose_language_service" then
					client.server_capabilities.completionProvider = nil
				end

				-- Auto-fix eslint à la sauvegarde (le formatage reste à conform)
				if client.name == "eslint" then
					vim.api.nvim_clear_autocmds({ group = eslint_fix_group, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = eslint_fix_group,
						buffer = bufnr,
						command = "LspEslintFixAll",
					})
				end
			end,
		})

		-- root_dir et filetypes sont laissés à lspconfig quand ses défauts conviennent :
		-- un vim.fs.root(0, …) ici n'était calculé qu'une fois, pour le premier buffer

		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--header-insertion=never",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			settings = {
				clangd = {
					fallbackFlags = { "-std=c++17", "-Wall", "-Wextra" },
				},
			},
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
					workspace = {
						library = {
							vim.fn.expand("$VIMRUNTIME/lua"),
							vim.fn.stdpath("config") .. "/lua",
						},
					},
					telemetry = { enable = false },
				},
			},
		})

		vim.lsp.config("ts_ls", {
			init_options = {
				hostInfo = "neovim",
				maxTsServerMemory = 4096,
			},
		})

		vim.lsp.config("angularls", {
			root_markers = { "angular.json" },
			-- sans ça, ngserver est lancé sur chaque fichier TS hors projet Angular
			workspace_required = true,
		})

		vim.lsp.config("html", {
			filetypes = { "html", "htmlangular" },
		})

		vim.lsp.config("tailwindcss", {
			filetypes = {
				"html",
				"htmlangular",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			},
			settings = {
				tailwindCSS = {
					includeLanguages = {
						htmlangular = "html",
						typescript = "javascript",
						typescriptreact = "javascript",
					},
					classAttributes = {
						"class",
						"className",
						"class:list",
						"classList",
						"ngClass",
					},
					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidConfigPath = "error",
						invalidScreen = "error",
						invalidTailwindDirective = "error",
						invalidVariant = "error",
						recommendedVariantOrder = "warning",
					},
					validate = true,
					experimental = {
						classRegex = {
							{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
						},
					},
				},
			},
		})

		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly",
						typeCheckingMode = "basic",
					},
				},
			},
		})

		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					check = {
						command = "clippy",
						extraArgs = { "--no-deps" },
					},
				},
			},
		})

		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					validate = true,
					hover = true,
					completion = true,
					-- catalogue SchemaStore fourni par schemastore.nvim (compose, GitHub Actions,
					-- GitLab CI…) plutôt que téléchargé par le serveur
					schemaStore = { enable = false, url = "" },
					schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
						kubernetes = {
							"*-deployment.yaml",
							"*-service.yaml",
							"*-ingress.yaml",
							"*-configmap.yaml",
							"*-secret.yaml",
							"*-pod.yaml",
							"*-daemonset.yaml",
							"*-statefulset.yaml",
							"*-cronjob.yaml",
							"*-job.yaml",
							"k8s/**/*.yaml",
							"k8s/**/*.yml",
							"kubernetes/**/*.yaml",
							"kubernetes/**/*.yml",
							"manifests/**/*.yaml",
							"manifests/**/*.yml",
						},
					}),
				},
			},
		})

		-- taplo 0.10 ne sait plus lire le catalogue SchemaStore (format changé) : sans
		-- association explicite, aucune complétion dans Cargo.toml / pyproject.toml
		vim.lsp.config("taplo", {
			settings = {
				evenBetterToml = {
					schema = {
						associations = {
							["Cargo\\.toml$"] = "https://www.schemastore.org/cargo.json",
							["pyproject\\.toml$"] = "https://www.schemastore.org/pyproject.json",
						},
					},
				},
			},
		})

		vim.lsp.enable({
			"clangd",
			"lua_ls",
			"ts_ls",
			"eslint",
			"angularls",
			"html",
			"cssls",
			"tailwindcss",
			"jsonls",
			"pyright",
			"rust_analyzer",
			"dockerls",
			"docker_compose_language_service",
			"yamlls",
			"taplo",
		})
	end,
}
