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
				javascript = { "biome", "prettier", stop_after_first = true },
				typescript = { "biome", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettier", stop_after_first = true },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "biome", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettier", stop_after_first = true },
				yaml = { "prettier" },
				markdown = { "prettier" },
				prisma = { "prettier" },
			},
			formatters = {
				-- Prettier : utilise UNIQUEMENT la config du projet, sans override
				prettier = {
					-- Ne pas ajouter d'args, laisse la config du projet décider
					require_cwd = true, -- Utilise le working directory du projet
				},
				-- Biome : utilise UNIQUEMENT la config du projet
				biome = {
					require_cwd = true,
				},
			},
		})

		-- Format à la sauvegarde
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function(args)
				conform.format({
					bufnr = args.buf,
					lsp_fallback = true,
					timeout_ms = 1000,
				})
			end,
		})

		-- Raccourci manuel pour formater
		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range" })
	end,
}
