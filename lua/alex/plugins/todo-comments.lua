vim.pack.add({
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

local todo_comments = require("todo-comments")

-- set keymaps
local keymap = vim.keymap -- for conciseness

keymap.set("n", "]t", function()
	todo_comments.jump_next()
end, { desc = "Next todo comment" })

keymap.set("n", "[t", function()
	todo_comments.jump_prev()
end, { desc = "Previous todo comment" })

todo_comments.setup()
