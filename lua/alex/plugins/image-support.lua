return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},

	opts = {
		-- Pasting from nvim-tree only saves the image to the folder under the
		-- cursor; the tree buffer isn't modifiable, so skip markup insertion there
		-- (empty template makes img-clip a no-op on insertion). Avoids E21.
		filetypes = {
			NvimTree = { template = "" },
		},

		default = {
			insert_mode_after_paste = true,
			url_encode_path = true,
			template = "$FILE_PATH$CURSOR",
			use_cursor_in_template = true,

			prompt_for_file_name = true,
			show_dir_path_in_prompt = true,

			use_absolute_path = false,
			relative_to_current_file = true,

			embed_image_as_base64 = false,
			max_base64_size = 10,

			-- destination partagée avec <leader>pf (voir lua/alex/util/paste.lua),
			-- pour que les images et les fichiers collés atterrissent au même endroit
			dir_path = function()
				return require("alex.util.paste").img_dir_path()
			end,
		},
	},
}
