return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

	init = function()
		-- dans init : le plugin se charge sur BufReadPost, après le FileType du premier buffer.
		-- La branche main ne démarre rien toute seule : coloration et indentation sont à activer ici
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("alex-treesitter", { clear = true }),
			callback = function(args)
				-- filetype composé : yaml.docker-compose utilise le parser yaml
				local lang = vim.treesitter.language.get_lang(args.match:match("^[^.]+"))
				-- pas d'erreur si le parser n'est pas (encore) installé
				if not pcall(vim.treesitter.start, args.buf, lang) then
					return
				end
				if vim.treesitter.query.get(lang, "indents") then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,

	config = function()
		-- install() ne fait rien pour les parsers déjà présents
		require("nvim-treesitter").install({
			"json",
			"javascript",
			"typescript",
			"tsx",
			"go",
			"yaml",
			"html",
			"css",
			"scss",
			"python",
			"http",
			"prisma",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"cpp",
			"gitignore",
			"query",
			"vimdoc",
			"c",
			"java",
			"rust",
			"ron",
			"angular",
			"terraform",
			"hcl",
			"astro",
		})
	end,
}
