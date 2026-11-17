vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

-- Au démarrage : ajoute le bin/ de mason au PATH avant que les serveurs LSP se lancent
require("mason").setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Noms de paquets mason (pas ceux de lspconfig) : mason-lspconfig n'est plus utile
-- pour les traduire, et son setup coûtait ~4 ms au démarrage. L'installation est
-- vérifiée après le démarrage (VimEnter). Les serveurs sont activés dans lsp-config.lua
require("mason-tool-installer").setup({
	ensure_installed = {
		-- serveurs LSP
		"lua-language-server",
		"typescript-language-server",
		"html-lsp",
		"css-lsp",
		"tailwindcss-language-server",
		"prisma-language-server",
		"emmet-ls",
		"emmet-language-server",
		"eslint-lsp",
		"marksman",
		"angular-language-server",
		"json-lsp",
		"pyright",
		"rust-analyzer",
		"dockerfile-language-server",
		"docker-compose-language-service",
		"yaml-language-server",
		"taplo",
		"terraform-ls",
		"astro-language-server",
		"jdtls", -- installé ici, mais démarré par nvim-jdtls (pas vim.lsp.enable)

		-- formatters / linters
		-- conform formate JS/TS/HTML/CSS/YAML/Markdown avec prettierd
		-- (daemon) quand le projet n'utilise ni biome ni oxfmt
		"prettierd",
		"stylua",
		"isort",
		"pylint",
		-- conform formate le python avec ruff (organize_imports + format) :
		-- sans ce binaire, le formatage à la sauvegarde échoue en silence
		"ruff",
		"clangd",
		"biome",
		"oxlint",
		"oxfmt",
		-- CLI terraform : utilisé par conform (terraform fmt) et par terraform-ls
		-- pour la validation ; sans lui, aucun formatage des .tf
		"terraform",
		-- java: formatter + jdtls debug/test bundles
		"google-java-format",
		"java-debug-adapter",
		"java-test",
	},
})
