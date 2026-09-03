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
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
				}),
			},
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Entrée pour accepter le menu cmp
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				["<C-CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP (Tailwind, TypeScript, etc.)
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
			-- Supermaven fournit le ghost text, pas de source cmp
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
				ghost_text = false, -- le ghost text vient de Supermaven
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					-- Priorité basée sur le group_index et priority
					require("cmp.config.compare").offset,
					require("cmp.config.compare").exact,
					require("cmp.config.compare").score,
					require("cmp.config.compare").recently_used,
					require("cmp.config.compare").locality,
					require("cmp.config.compare").kind,
					require("cmp.config.compare").sort_text,
					require("cmp.config.compare").length,
					require("cmp.config.compare").order,
				},
			},
		}
	end,
}
