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
				-- biome et oxfmt ne tournent qu'avec leur config dans le projet ;
				-- prettierd prend tout le reste (voir formatters plus bas)
				javascript = { "biome", "oxfmt", "prettierd", stop_after_first = true },
				typescript = { "biome", "oxfmt", "prettierd", stop_after_first = true },
				javascriptreact = { "biome", "oxfmt", "prettierd", stop_after_first = true },
				typescriptreact = { "biome", "oxfmt", "prettierd", stop_after_first = true },
				html = { "biome", "prettierd", stop_after_first = true },
				css = { "biome", "prettierd", stop_after_first = true },
				scss = { "biome", "prettierd", stop_after_first = true },
				json = { "biome", "oxfmt", "prettierd", stop_after_first = true },
				jsonc = { "biome", "oxfmt", "prettierd", stop_after_first = true },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				prisma = { "prisma_format" },
				astro = { "biome", "prettierd_project", stop_after_first = true },
				terraform = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
			},
			formatters = {
				-- prettierd garde prettier chargé en mémoire (~60-130 ms de moins par
				-- sauvegarde qu'un `prettier` relancé à chaque fois). Avec un
				-- .prettierrc, il utilise le prettier et les plugins du projet ; sans
				-- config, son prettier embarqué, ce qui couvre les fichiers isolés.
				-- Si un .prettierrc modifié n'est pas pris en compte : `prettierd restart`
				-- astro a besoin du prettier-plugin-astro du projet : sans config
				-- prettier, prettierd échouerait faute de parser .astro
				prettierd_project = {
					inherit = "prettierd",
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
				prisma_format = {
					command = "node",
					args = {
						"-e",
						[=[
							const [lsDir, file] = process.argv.slice(1);
							const wasm = require(require.resolve("@prisma/prisma-schema-wasm", { paths: [lsDir] }));
							const uri = require("url").pathToFileURL(file).href;
							let src = "";
							process.stdin.setEncoding("utf8");
							process.stdin.on("data", (d) => (src += d));
							process.stdin.on("end", () => {
								const params = { textDocument: { uri }, options: { tabSize: 2, insertSpaces: true } };
								const out = JSON.parse(wasm.format(JSON.stringify([[uri, src]]), JSON.stringify(params)));
								process.stdout.write(out[0][1]);
							});
						]=],
						vim.fn.stdpath("data")
							.. "/mason/packages/prisma-language-server/node_modules/@prisma/language-server",
						"$FILENAME",
					},
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
