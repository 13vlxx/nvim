vim.loader.enable() -- cache du bytecode Lua (lazy.nvim l'activait tout seul)
require("alex.core")
require("alex.pack")
require("alex.utils.colorscheme").setup() -- applique le dernier thème choisi
