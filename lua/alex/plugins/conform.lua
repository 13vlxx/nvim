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
				javascript = { "biome", "prettier", "prettier_global", stop_after_first = true },
				typescript = { "biome", "prettier", "prettier_global", stop_after_first = true },
				javascriptreact = { "biome", "prettier", "prettier_global", stop_after_first = true },
				typescriptreact = { "biome", "prettier", "prettier_global", stop_after_first = true },
				html = { "biome", "prettier", "prettier_global", stop_after_first = true },
				css = { "biome", "prettier", "prettier_global", stop_after_first = true },
				scss = { "biome", "prettier", "prettier_global", stop_after_first = true },
				json = { "biome", "prettier", "prettier_global", stop_after_first = true },
				jsonc = { "biome", "prettier", "prettier_global", stop_after_first = true },
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
					timeout_ms = 500,
				})
			end,
		})
	end,
}
