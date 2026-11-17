-- :TSUpdate après chaque mise à jour : hook PackChanged dans alex/pack.lua
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

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
		-- get_files ne compile pas la requête (~7 ms pour typescript), indentexpr le fera au besoin
		if #vim.treesitter.query.get_files(lang, "indents") > 0 then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

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
