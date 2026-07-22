return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		dashboard = { enabled = false },
		image = { enabled = true },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		-- snacks.image doesn't re-render a standalone image buffer when you leave
		-- and come back (update() dedups on unchanged window state while the
		-- terminal already cleared the image). Re-attach to force a redraw.
		--
		-- Crucially, only do this on a *real* re-entry, never on the first open:
		-- re-attaching mid-first-conversion aborts the in-flight `magick` job and
		-- can deadlock snacks' conversion queue. On re-entry the image is already
		-- converted (disk cache), so this redraws without spawning any process.
		local seen = {}
		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = vim.api.nvim_create_augroup("snacks_image_rerender", { clear = true }),
			callback = function(ev)
				if vim.bo[ev.buf].filetype ~= "image" then
					return
				end
				if seen[ev.buf] then
					require("snacks.image.buf").attach(ev.buf)
				end
				seen[ev.buf] = true
			end,
		})
		vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
			group = "snacks_image_rerender",
			callback = function(ev)
				seen[ev.buf] = nil
			end,
		})
	end,
}
