return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		local function find_project_root()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname == "" then
				return vim.fn.getcwd()
			end

			local root_patterns = {
				"biome.json",
				"biome.jsonc",
				"package.json",
				".git",
			}

			local root = vim.fs.dirname(vim.fs.find(root_patterns, {
				upward = true,
				path = vim.fs.dirname(bufname),
			})[1])

			return root or vim.fn.getcwd()
		end

		local function has_biome_config()
			local root = find_project_root()
			local biome_files = {
				"biome.json",
				"biome.jsonc",
				".biomerc",
				".biomerc.json",
				".biomerc.jsonc",
				".biomerc.cjs",
			}

			for _, file in ipairs(biome_files) do
				local full_path = root .. "/" .. file
				if vim.fn.filereadable(full_path) == 1 then
					return true
				end
			end
			return false
		end

		-- eslint is handled by the eslint LSP; nvim-lint only covers biome for JS/TS
		local function get_js_linters()
			return has_biome_config() and { "biomejs" } or {}
		end

		local js_filetypes = {
			javascript = true,
			typescript = true,
			javascriptreact = true,
			typescriptreact = true,
			json = true,
			jsonc = true,
		}

		lint.linters_by_ft = {
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Decide biome vs nothing per buffer, so the choice follows the project
				if js_filetypes[vim.bo.filetype] then
					lint.try_lint(get_js_linters())
				else
					lint.try_lint()
				end
			end,
		})
	end,
}
