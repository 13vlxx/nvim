return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				go = { "goimports", "gofumpt" },
				java = { "google-java-format" },
				javascript = { "biome", "oxfmt", "prettier", "prettier_global", stop_after_first = true },
				typescript = { "biome", "oxfmt", "prettier", "prettier_global", stop_after_first = true },
				javascriptreact = { "biome", "oxfmt", "prettier", "prettier_global", stop_after_first = true },
				typescriptreact = { "biome", "oxfmt", "prettier", "prettier_global", stop_after_first = true },
				html = { "biome", "prettier", "prettier_global", stop_after_first = true },
				css = { "biome", "prettier", "prettier_global", stop_after_first = true },
				scss = { "biome", "prettier", "prettier_global", stop_after_first = true },
				json = { "biome", "oxfmt", "prettier", "prettier_global", stop_after_first = true },
				jsonc = { "biome", "oxfmt", "prettier", "prettier_global", stop_after_first = true },
				yaml = { "prettier", "prettier_global", stop_after_first = true },
				markdown = { "prettier", "prettier_global", stop_after_first = true },
				prisma = { "prettier", "prettier_global", stop_after_first = true },
			},
			formatters = {
				prettier = {
					require_cwd = true,
				},
				biome = {
					require_cwd = true,
				},
				oxfmt = {
					require_cwd = true,
					-- le défaut de conform inclut vite.config.ts/js : sans ça, oxfmt
					-- formaterait n'importe quel projet Vite, même ceux sous prettier
					cwd = require("conform.util").root_file({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }),
				},
				prettier_global = {
					command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
					args = { "--stdin-filepath", "$FILENAME" },
					stdin = true,
				},
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function(args)
				conform.format({
					bufnr = args.buf,
					lsp_fallback = true,
					-- 500 ms suffit à chaud, mais pas au premier lancement d'un
					-- formateur fraîchement installé (vérification Gatekeeper) :
					-- le formatage échouait alors sans rien afficher
					timeout_ms = 2000,
				})
			end,
		})
	end,
}
