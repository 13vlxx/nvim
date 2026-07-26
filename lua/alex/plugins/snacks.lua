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
		-- snacks.image also renders images inline in *documents*, for every language
		-- it ships a treesitter query for (html, css, jsx/tsx, vue, svelte...).
		-- That's welcome in markdown, but in code buffers an `<img src="...">`
		-- explodes into a full-size preview mid-file. doc.attach() bails on a buffer
		-- already flagged as attached, and snacks schedules its own attach from
		-- FileType, so setting the flag synchronously here wins the race.
		local no_doc_images = {
			html = true,
			css = true,
			scss = true,
			javascript = true,
			javascriptreact = true,
			typescript = true,
			typescriptreact = true,
			vue = true,
			svelte = true,
		}
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("snacks_image_no_doc", { clear = true }),
			callback = function(ev)
				if no_doc_images[vim.bo[ev.buf].filetype] then
					vim.b[ev.buf].snacks_image_attached = true
				end
			end,
		})

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
