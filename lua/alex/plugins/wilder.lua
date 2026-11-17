vim.pack.add({
	"https://github.com/gelguy/wilder.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/romgrk/fzy-lua-native",
})

local wilder = require("wilder")

wilder.setup({ modes = { ":", "/", "?" } })

wilder.set_option("pipeline", {
	wilder.branch(
		wilder.cmdline_pipeline({
			language = "vim",
			fuzzy = 1,
		}),
		wilder.search_pipeline()
	),
})

wilder.set_option("highlighter", {
	wilder.lua_fzy_highlighter(),
	wilder.lua_pcre2_highlighter(),
})
