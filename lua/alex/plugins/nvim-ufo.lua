vim.pack.add({
	"https://github.com/kevinhwang91/nvim-ufo",
	"https://github.com/kevinhwang91/promise-async",
})

-- Pli fermé : « function foo() { ⋯ }        12 lines », la ligne colorée comme le code et le
-- nombre de lignes en gris, calé à droite. La dernière ligne n'est ajoutée que si elle ferme
-- le bloc (}, ), end, </div>…)
local closers = { "^[%)%]}]", "^end%f[^%w_]", "^</" }

local function fold_text(virt_text, lnum, end_lnum, width, truncate, ctx)
	local chunks = vim.list_extend({}, virt_text)
	table.insert(chunks, { " ⋯ ", "Comment" })

	local last = ctx.get_fold_virt_text(end_lnum)
	local last_text = vim.trim(table.concat(vim.tbl_map(function(c)
		return c[1]
	end, last)))
	for _, pattern in ipairs(closers) do
		if last_text:find(pattern) then
			local started = false
			for _, c in ipairs(last) do
				local text = started and c[1] or c[1]:gsub("^%s+", "")
				if text ~= "" then
					started = true
					table.insert(chunks, { text, c[2] })
				end
			end
			break
		end
	end

	local n = end_lnum - lnum + 1
	local suffix = (" %d %s "):format(n, n == 1 and "line" or "lines")
	local target = width - vim.fn.strdisplaywidth(suffix)
	local result, cur = {}, 0
	for _, c in ipairs(chunks) do
		local w = vim.fn.strdisplaywidth(c[1])
		if cur + w > target then
			local cut = truncate(c[1], math.max(target - cur, 0))
			table.insert(result, { cut, c[2] })
			cur = cur + vim.fn.strdisplaywidth(cut)
			break
		end
		table.insert(result, c)
		cur = cur + w
	end
	table.insert(result, { (" "):rep(math.max(target - cur, 0)) .. suffix, "Comment" })
	return result
end

require("ufo").setup({
	provider_selector = function(_, _, _)
		return { "treesitter", "indent" }
	end,
	open_fold_hl_timeout = 0,
	fold_virt_text_handler = fold_text,
	enable_get_fold_virt_text = true, -- fournit ctx.get_fold_virt_text à fold_text
})

-- pas de bande de fond sur les plis fermés : le chevron de la statuscolumn et le ⋯ suffisent.
-- nvim peint la ligne avec Folded, ufo avec UfoFoldedBg. Après le setup d'ufo, pour passer
-- après son propre autocmd ColorScheme qui recalcule UfoFoldedBg
local function no_fold_band()
	local folded = vim.api.nvim_get_hl(0, { name = "Folded", link = false })
	folded.bg = nil
	vim.api.nvim_set_hl(0, "Folded", folded)
	vim.api.nvim_set_hl(0, "UfoFoldedBg", {})
end
no_fold_band()
vim.api.nvim_create_autocmd("ColorScheme", { callback = no_fold_band })

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
