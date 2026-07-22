return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local mason = vim.fn.expand("$MASON/packages")
		local jdtls_path = mason .. "/jdtls"

		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		if launcher_jar == "" then
			vim.notify(
				"jdtls launcher jar not found — run :Mason and install/reinstall 'jdtls', then reopen this file",
				vim.log.levels.ERROR
			)
			return
		end

		-- Debug + test bundles (loaded only if installed via mason)
		local bundles = {}
		vim.list_extend(
			bundles,
			vim.split(
				vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
				"\n",
				{ trimempty = true }
			)
		)
		vim.list_extend(
			bundles,
			vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar"), "\n", { trimempty = true })
		)

		-- jdtls ships per-OS/arch configuration dirs (config_mac_arm, config_linux, …)
		local os_config = (function()
			if vim.fn.has("win32") == 1 then
				return "config_win"
			end
			local arch = vim.uv.os_uname().machine
			local suffix = (arch == "arm64" or arch == "aarch64") and "_arm" or ""
			return (vim.fn.has("mac") == 1 and "config_mac" or "config_linux") .. suffix
		end)()

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(client, bufnr)
			-- Formatting is handled exclusively by conform.nvim
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()
		end

		-- Built per-buffer so each project gets its own root_dir + workspace
		local function start_jdtls()
			local root_dir =
				vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts", "mvnw", "gradlew", ".git" })
			local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

			require("jdtls").start_or_attach({
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xmx1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					launcher_jar,
					"-configuration",
					jdtls_path .. "/" .. os_config,
					"-data",
					workspace_dir,
				},
				root_dir = root_dir,
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = { bundles = bundles },
				settings = {
					java = {
						eclipse = { downloadSources = true },
						configuration = { updateBuildConfiguration = "interactive" },
						maven = { downloadSources = true },
						gradle = { enabled = true },
						implementationsCodeLens = { enabled = true },
						referencesCodeLens = { enabled = true },
						references = { includeDecompiledSources = true },
						format = { enabled = false },
						signatureHelp = { enabled = true },
						completion = {
							favoriteStaticMembers = {
								"org.junit.Assert.*",
								"org.junit.jupiter.api.Assertions.*",
								"org.mockito.Mockito.*",
								"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
								"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
							},
						},
					},
				},
			})
		end

		-- Attach to future java buffers, and to the one that triggered loading
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = start_jdtls,
		})
		start_jdtls()
	end,
}
