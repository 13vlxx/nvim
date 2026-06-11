return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		{ "MaximilianLloyd/ascii.nvim", dependencies = { "MunifTanjim/nui.nvim" } },
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local ascii = require("ascii")

		local function i(n)
			return vim.fn.nr2char(n)
		end

		-- Set header
		dashboard.section.header.val = ascii.art.text.neovim.sharp

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("SPC ee", i(0xf115) .. "  File Explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", i(0xf0fbc) .. "  Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", i(0xf002) .. "  Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC xt", i(0xf00c) .. "  TODOs", "<cmd>Trouble todo toggle<CR>"),
			dashboard.button("SPC D", i(0xf188) .. "  Diagnostics", "<cmd>Telescope diagnostics<CR>"),
			dashboard.button("l", i(0xf487) .. "  Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("q", i(0xf011) .. "  Quit", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
