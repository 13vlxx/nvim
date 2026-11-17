-- aucun plugin distant (python, node…) : sans ça, chaque has('python3') lance un sondage coûteux
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window on the right
opt.splitbelow = true -- split horizontal window on the bottom

-- folds (nvim-ufo, chargé après le premier affichage) : tout ouvert par défaut
opt.foldcolumn = "0" -- les icônes de pli sont dans la statuscolumn de snacks
opt.foldlevel = 99
opt.foldlevelstart = 99
-- icônes de pli (lues par snacks.statuscolumn), pas de « ~ » après la fin du fichier,
-- lignes supprimées hachurées dans les diffs. Glyphes en \u{…} : collés tels quels, ils se perdent
opt.fillchars = { eob = " ", fold = " ", foldopen = "\u{f47c}", foldclose = "\u{f460}", foldsep = " ", diff = "╱" }

-- lualine affiche déjà le mode : noice ne garde ainsi que « recording @q » pour lualine
opt.showmode = false
