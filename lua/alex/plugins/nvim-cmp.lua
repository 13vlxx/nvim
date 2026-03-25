return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"windwp/nvim-autopairs",
	},
	opts = function()
		local cmp = require("cmp")
		local defaults = require("cmp.config.default")()
		local auto_select = true

		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

		return {
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = auto_select })
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				["<C-CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp", group_index = 2 },
				{ name = "path", group_index = 2 },
			}, {
				{ name = "buffer", group_index = 2 },
			}),
			formatting = {
				format = function(entry, item)
					local icons = {
						Copilot = " ",
						Class = " ",
						Color = " ",
						Constant = " ",
						Constructor = " ",
						Enum = " ",
						EnumMember = " ",
						Event = " ",
						Field = " ",
						File = " ",
						Folder = " ",
						Function = " ",
						Interface = " ",
						Keyword = " ",
						Method = " ",
						Module = " ",
						Operator = " ",
						Property = " ",
						Reference = " ",
						Snippet = " ",
						Struct = " ",
						Text = " ",
						TypeParameter = " ",
						Unit = " ",
						Value = " ",
						Variable = " ",
					}

					if icons[item.kind] then
						item.kind = icons[item.kind] .. item.kind
					end

					-- Ajouter l'icône Copilot pour les suggestions copilot
					if entry.source.name == "copilot" then
						item.kind = icons.Copilot .. "Copilot"
					end

					return item
				end,
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
			sorting = defaults.sorting,
		}
	end,
}
