-- Collage depuis le presse-papier système (macOS).
--
-- Deux consommateurs se partagent ce module, et surtout se partagent la même
-- règle de destination :
--   * img-clip  (<leader>pi) pour les données image
--   * paste_files (<leader>pf) pour les fichiers et dossiers du Finder
--
-- Une copie Finder ne met aucun pixel dans le presse-papier, seulement des
-- références `public.file-url`. `pbpaste` ne sait pas les lire : il faut passer
-- par NSPasteboard, d'où l'aller-retour osascript/JXA ci-dessous.

local M = {}

-- Chemins de fichiers présents dans le presse-papier.
-- Renvoie une liste (éventuellement vide), ou nil si la lecture a échoué.
local function clipboard_files()
	if vim.fn.has("mac") ~= 1 then
		return {}
	end

	local script = [[
ObjC.import('AppKit');
function run() {
  const pb = $.NSPasteboard.generalPasteboard;
  const o = $.NSDictionary.dictionaryWithObjectForKey($.NSNumber.numberWithBool(true), $.NSPasteboardURLReadingFileURLsOnlyKey);
  const u = pb.readObjectsForClassesOptions($.NSArray.arrayWithObject($.NSURL), o);
  const r = [];
  if (!u.isNil()) { for (let i = 0; i < u.count; i++) r.push(ObjC.unwrap(u.objectAtIndex(i).path)); }
  return JSON.stringify(r);
}
]]

	local res = vim.system({ "osascript", "-l", "JavaScript", "-" }, { stdin = script }, nil):wait(2000)
	if res.code ~= 0 then
		return nil
	end

	local ok, decoded = pcall(vim.json.decode, vim.trim(res.stdout or ""))
	if not ok or type(decoded) ~= "table" then
		return nil
	end
	return decoded
end

-- Dossier pointé par le nœud sous le curseur dans nvim-tree, sinon nil.
local function tree_dir()
	local ok, api = pcall(require, "nvim-tree.api")
	if not ok then
		return nil
	end
	local node = api.tree.get_node_under_cursor()
	if not (node and node.absolute_path) then
		return nil
	end
	if node.type == "file" then
		return vim.fn.fnamemodify(node.absolute_path, ":h")
	end
	return node.absolute_path
end

-- Sous-dossier de dépôt, relatif : vault ou assets/.
local function assets_subdir()
	return vim.fn.getcwd():match("sethVault") and "Archives/All-Vault-Images/" or "assets"
end

-- Destination telle que la veut img-clip. Doit rester RELATIVE hors nvim-tree :
-- un chemin absolu ici court-circuite use_absolute_path=false et le lien inséré
-- devient absolu.
function M.img_dir_path()
	return tree_dir() or assets_subdir()
end

-- Même destination, mais en absolu, parce que `cp` l'exige. On résout comme
-- img-clip le ferait avec relative_to_current_file, pour que fichiers et images
-- atterrissent bien au même endroit.
local function target_dir()
	local from_tree = tree_dir()
	if from_tree then
		return from_tree
	end

	local base = vim.fn.getcwd()
	local current = vim.api.nvim_buf_get_name(0)
	if current ~= "" and vim.bo.filetype ~= "NvimTree" then
		base = vim.fn.fnamemodify(current, ":h")
	end

	return vim.fs.normalize(base .. "/" .. assets_subdir())
end

-- Ne jamais écraser : `photo.png` déjà pris devient `photo-1.png`.
local function unique_path(dir, name)
	local candidate = dir .. "/" .. name
	if vim.uv.fs_lstat(candidate) == nil then
		return candidate
	end

	local stem, ext = name:match("^(.*)(%.[^.]+)$")
	stem, ext = stem or name, ext or ""

	local i = 1
	while true do
		candidate = string.format("%s/%s-%d%s", dir, stem, i, ext)
		if vim.uv.fs_lstat(candidate) == nil then
			return candidate
		end
		i = i + 1
	end
end

-- <leader>pf : copie les fichiers/dossiers du presse-papier dans le dossier cible.
function M.paste_files()
	local files = clipboard_files()

	if files == nil then
		vim.notify("Lecture du presse-papier impossible", vim.log.levels.ERROR)
		return
	end
	if #files == 0 then
		vim.notify("Aucun fichier dans le presse-papier", vim.log.levels.WARN)
		return
	end

	local dir = target_dir()
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local pasted, failed = {}, {}
	for _, src in ipairs(files) do
		-- copier un dossier dans lui-même partirait en récursion infinie
		if vim.fs.normalize(dir):find(vim.fs.normalize(src), 1, true) == 1 then
			table.insert(failed, vim.fs.basename(src) .. " (dossier cible)")
		else
			local dest = unique_path(dir, vim.fs.basename(src))
			local res = vim.system({ "cp", "-R", "--", src, dest }, nil, nil):wait(30000)
			if res.code == 0 then
				table.insert(pasted, dest)
			else
				table.insert(failed, vim.fs.basename(src))
			end
		end
	end

	local ok, api = pcall(require, "nvim-tree.api")
	if ok then
		pcall(api.tree.reload)
	end

	-- Hors nvim-tree, on insère le chemin relatif comme le fait img-clip
	if #pasted > 0 and vim.bo.modifiable and vim.bo.filetype ~= "NvimTree" then
		local here = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
		local lines = {}
		for _, p in ipairs(pasted) do
			table.insert(lines, vim.fs.relpath(here, p) or p)
		end
		vim.api.nvim_put(lines, "c", true, true)
	end

	if #pasted > 0 then
		vim.notify(
			string.format("%d élément(s) collé(s) dans %s", #pasted, vim.fn.fnamemodify(dir, ":~:.")),
			vim.log.levels.INFO
		)
	end
	if #failed > 0 then
		vim.notify("Échec : " .. table.concat(failed, ", "), vim.log.levels.ERROR)
	end
end

return M
