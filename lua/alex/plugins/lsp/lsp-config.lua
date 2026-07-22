return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp", lazy = false },
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"b0o/schemastore.nvim",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })
		keymap.set("n", "<leader>D", builtin.diagnostics, { noremap = true, silent = true })

		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

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
		end

		local capabilities = cmp_nvim_lsp.default_capabilities()
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			virtual_text = { prefix = "●" },
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = true, wrap = true, max_width = 80 },
		})

		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--cross-file-rename",
				"--header-insertion=never",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			root_dir = vim.fs.root(0, {
				"compile_commands.json",
				".clangd",
				"CMakeLists.txt",
				".git",
			}),
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				clangd = {
					fallbackFlags = { "-std=c++17", "-Wall", "-Wextra" },
				},
			},
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
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

		vim.lsp.config("gopls", {
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				gopls = {
					staticcheck = true,
					completeUnimported = true,
					usePlaceholders = true,
					semanticTokens = true,
				},
			},
		})

		vim.lsp.config("ts_ls", {
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
			capabilities = capabilities,
			on_attach = on_attach,
			init_options = {
				hostInfo = "neovim",
				maxTsServerMemory = 4096,
			},
		})

		-- lspconfig's default on_attach registers the LspEslintFixAll command; keep it
		local eslint_base_on_attach = vim.lsp.config.eslint.on_attach
		vim.lsp.config("eslint", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				if eslint_base_on_attach then
					eslint_base_on_attach(client, bufnr)
				end
				on_attach(client, bufnr)
				-- Auto-fix eslint rules on save (formatting stays with conform)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "LspEslintFixAll",
				})
			end,
		})

		vim.lsp.config("angularls", {
			root_markers = { "angular.json" },
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("html", {
			filetypes = { "html", "htmlangular" },
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
			on_attach = on_attach,
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
			root_dir = vim.fs.root(0, {
				"tailwind.config.js",
				"tailwind.config.cjs",
				"tailwind.config.mjs",
				"tailwind.config.ts",
				"postcss.config.js",
				"postcss.config.cjs",
				"postcss.config.mjs",
				"postcss.config.ts",
				"package.json",
			}),
			capabilities = capabilities,
			on_attach = on_attach,
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
			filetypes = { "json", "jsonc" },
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})

		vim.lsp.config("pyright", {
			capabilities = capabilities,
			on_attach = on_attach,
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
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					check = {
						command = "clippy",
						extraArgs = { "--no-deps" },
					},
				},
			},
		})

		vim.lsp.config("dockerls", {
			filetypes = { "dockerfile" },
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("docker_compose_language_service", {
			filetypes = { "yaml.docker-compose" },
			root_dir = vim.fs.root(0, { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" }),
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.config("yamlls", {
			filetypes = { "yaml", "yml" },
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				yaml = {
					validate = true,
					hover = true,
					completion = true,
					schemaStore = { enable = false, url = "" },
					schemas = {
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
					},
				},
			},
		})

		vim.lsp.enable({
			"clangd",
			"lua_ls",
			"gopls",
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
		})
	end,
}
