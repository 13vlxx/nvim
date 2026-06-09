return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},

	opts = {
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

			dir_path = function()
				local ok, nvim_tree_api = pcall(require, "nvim-tree.api")
				if ok then
					local node = nvim_tree_api.tree.get_node_under_cursor()
					if node and node.absolute_path then
						if node.type == "file" then
							return vim.fn.fnamemodify(node.absolute_path, ":h")
						else
							return node.absolute_path
						end
					end
				end

				local cwd = vim.fn.getcwd()
				local vault_name = "sethVault"
				local vault_images_path = "Archives/All-Vault-Images/"

				if cwd:match(vault_name) then
					return vault_images_path
				else
					return "assets"
				end
			end,
		},
	},
}
