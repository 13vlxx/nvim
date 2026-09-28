# Neovim Motions

> Leader = `<Space>`

## Basics

### Movement

| Key Binding | Description                          |
| ----------- | ------------------------------------ |
| `h`         | Move left                            |
| `j`         | Move down                            |
| `k`         | Move up                              |
| `l`         | Move right                           |
| `w`         | Next word start                      |
| `b`         | Previous word start                  |
| `e`         | Next word end                        |
| `0`         | Start of line                        |
| `^`         | First non-blank char of line         |
| `$`         | End of line                          |
| `f{c}`      | Jump to next `{c}` on the line       |
| `t{c}`      | Jump just before next `{c}`          |
| `;` / `,`   | Repeat last `f`/`t` forward/backward |
| `%`         | Jump to matching bracket             |

### Insert Mode

| Key Binding | Description                   |
| ----------- | ----------------------------- |
| `i` / `a`   | Insert before / after cursor  |
| `I` / `A`   | Insert at start / end of line |
| `o` / `O`   | New line below / above        |
| `jk`        | Exit insert mode              |

## Visual Mode

| Key Binding | Description                           |
| ----------- | ------------------------------------- |
| `v`         | Enter visual mode                     |
| `V`         | Enter visual line mode                |
| `<C-v>`     | Enter visual block mode               |
| `J` / `K`   | Move selected lines down / up         |
| `<` / `>`   | Indent left / right (keeps selection) |
| `<leader>y` | Duplicate selection below             |

## Sentences & Paragraphs

| Key Binding | Description               |
| ----------- | ------------------------- |
| `(` / `)`   | Previous / next sentence  |
| `{` / `}`   | Previous / next paragraph |

## Text Objects (operator + `i`/`a` + object)

`i` = inside, `a` = around (includes the delimiters / surrounding space).

| Key Binding | Description                          |
| ----------- | ------------------------------------ |
| `yap`       | Yank (copy) a paragraph              |
| `dap`       | Delete a paragraph                   |
| `cap`       | Change a paragraph                   |
| `ciw`       | Change inside word                   |
| `diw`       | Delete inside word                   |
| `cib`       | Change inside parentheses `()`       |
| `ciB`       | Change inside braces `{}`            |
| `ci"`       | Change inside double quotes          |
| `ci'`       | Change inside single quotes          |
| `ci[`       | Change inside brackets `[]`          |
| `cit`       | Change inside HTML/XML tag           |
| `dab`       | Delete parentheses and their content |
| `vi"`       | Select inside double quotes          |

## Editing

| Key Binding    | Description                                 |
| -------------- | ------------------------------------------- |
| `yy`           | Yank line                                   |
| `dd`           | Delete line                                 |
| `cc`           | Change line                                 |
| `p` / `P`      | Paste after / before                        |
| `u`            | Undo                                        |
| `<C-r>`        | Redo                                        |
| `.`            | Repeat last change                          |
| `<leader>y`    | Duplicate line below                        |
| `<leader>+`    | Increment number                            |
| `<leader>-`    | Decrement number                            |
| `<leader>r{m}` | Substitute with motion (e.g. `<leader>riw`) |
| `<leader>rr`   | Substitute line                             |
| `<leader>R`    | Substitute to end of line                   |

### Surround (nvim-surround)

| Key Binding | Description                               |
| ----------- | ----------------------------------------- |
| `ysiw"`     | Surround word with `"`                    |
| `ds"`       | Delete surrounding `"`                    |
| `cs"'`      | Change surrounding `"` to `'`             |
| `S"`        | Surround selection (visual mode) with `"` |

## File Navigation

| Key Binding | Description             |
| ----------- | ----------------------- |
| `gg`        | Go to top of file       |
| `G`         | Go to bottom of file    |
| `{n}G`      | Go to line `{n}`        |
| `<C-d>`     | Scroll half page down   |
| `<C-u>`     | Scroll half page up     |
| `zz`        | Center cursor on screen |
| `<C-o>`     | Jump back               |
| `<C-i>`     | Jump forward            |

## Search

| Key Binding  | Description              |
| ------------ | ------------------------ |
| `/text`      | Search forward           |
| `?text`      | Search backward          |
| `n` / `N`    | Next / previous match    |
| `*`          | Search word under cursor |
| `<Esc>`      | Clear search highlight   |
| `<leader>nh` | Clear search highlight   |

## Splits & Windows

| Key Binding  | Description                 |
| ------------ | --------------------------- |
| `<C-h>`      | Go to left split            |
| `<C-j>`      | Go to split below           |
| `<C-k>`      | Go to split above           |
| `<C-l>`      | Go to right split           |
| `<leader>sv` | Split vertically            |
| `<leader>sh` | Split horizontally          |
| `<leader>se` | Make splits equal size      |
| `<leader>sx` | Close current split         |
| `<leader>sm` | Maximize / minimize a split |

## Tabs

| Key Binding  | Description                    |
| ------------ | ------------------------------ |
| `<leader>to` | Open new tab                   |
| `<leader>tx` | Close current tab              |
| `<leader>tn` | Next tab                       |
| `<leader>tp` | Previous tab                   |
| `<leader>tf` | Open current buffer in new tab |

## LSP

| Key Binding   | Description                          |
| ------------- | ------------------------------------ |
| `gd`          | Go to definition                     |
| `gD`          | Go to declaration                    |
| `gR`          | Show references (where it's used)    |
| `gi`          | Go to implementation                 |
| `gt`          | Go to type definition                |
| `K`           | Hover documentation                  |
| `<leader>vca` | Code actions (imports, quick fixes…) |
| `<leader>rn`  | Rename symbol                        |
| `<leader>rs`  | Restart LSP                          |
| `<leader>d`   | Show diagnostic under cursor         |
| `<leader>D`   | List all diagnostics (Telescope)     |

## Telescope (Find)

| Key Binding       | Description                        |
| ----------------- | ---------------------------------- |
| `<leader>ff`      | Find file                          |
| `<leader>fr`      | Recent files                       |
| `<leader>fs`      | Find a string in the project       |
| `<leader>fc`      | Find word under cursor in project  |
| `<leader>fb`      | Open buffers                       |
| `<leader>ft`      | Find TODOs                         |
| `<C-j>` / `<C-k>` | Next / previous result (in picker) |
| `<C-q>`           | Send results to quickfix list      |

## File Explorer (nvim-tree)

| Key Binding  | Description                     |
| ------------ | ------------------------------- |
| `<leader>ee` | Toggle file explorer            |
| `<leader>ef` | Toggle explorer on current file |
| `<leader>ec` | Collapse file explorer          |
| `<leader>er` | Refresh file explorer           |
| `<leader>pf` | Paste files copied from Finder  |

## Diagnostics & TODOs (Trouble)

| Key Binding  | Description                  |
| ------------ | ---------------------------- |
| `<leader>xw` | Workspace diagnostics        |
| `<leader>xd` | Document diagnostics         |
| `<leader>xq` | Quickfix list                |
| `<leader>xl` | Location list                |
| `<leader>xt` | TODOs                        |
| `]t` / `[t`  | Next / previous TODO comment |

## Folds

| Key Binding | Description     |
| ----------- | --------------- |
| `za`        | Toggle fold     |
| `zR`        | Open all folds  |
| `zM`        | Close all folds |

## Terminal

| Key Binding       | Description                 |
| ----------------- | --------------------------- |
| `<D-j>`           | Toggle terminal             |
| `<leader>t1`–`t4` | Toggle terminal 1–4         |
| `<Esc><Esc>`      | Exit terminal mode          |
| `<C-h/j/k/l>`     | Move to split from terminal |

## Completion & AI

| Key Binding       | Description                     |
| ----------------- | ------------------------------- |
| `<C-j>` / `<C-k>` | Next / previous completion item |
| `<CR>`            | Confirm completion              |
| `<C-Space>`       | Trigger completion              |
| `<C-b>` / `<C-f>` | Scroll completion docs          |
| `<Tab>`           | Accept Supermaven suggestion    |
| `<C-l>`           | Accept Supermaven word (insert) |
| `<C-]>`           | Clear Supermaven suggestion     |

## Misc

| Key Binding  | Description                |
| ------------ | -------------------------- |
| `<leader>lg` | Open LazyGit               |
| `<leader>u`  | Toggle Undotree            |
| `<leader>ct` | Toggle colorizer           |
| `<leader>pi` | Paste image from clipboard |
| `gx`         | Open URL on current line   |
