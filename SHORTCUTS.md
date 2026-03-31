# Raccourcis Neovim - Guide Rapide

## Navigation LSP (équivalent Cmd+Click)

| Raccourci | Description |
|-----------|-------------|
| `gd` | **Go to Definition** (aller à la définition - le plus utilisé !) |
| `gD` | Go to Declaration |
| `gi` | Go to Implementation |
| `gt` | Go to Type definition |
| `gR` | Go to References (voir toutes les utilisations) |
| `K` | Hover (voir la documentation) |
| `Ctrl+o` | Revenir en arrière (historique de navigation) |
| `Ctrl+i` | Aller en avant (historique de navigation) |

## LSP - Autres commandes utiles

| Raccourci | Description |
|-----------|-------------|
| `<leader>rn` | Rename (renommer fonction/variable partout) |
| `<leader>vca` | Code Actions (suggestions de fix) |
| `<leader>d` | Voir les diagnostics sur la ligne |
| `<leader>D` | Voir tous les diagnostics du projet |
| `gl` | Ouvrir les diagnostics en float |
| `<leader>rs` | Redémarrer le LSP |

## Complétion (nvim-cmp)

| Raccourci | Description |
|-----------|-------------|
| `Tab` | Accepter la suggestion |
| `Ctrl+Space` | Ouvrir le menu de complétion |
| `Ctrl+n` | Item suivant |
| `Ctrl+p` | Item précédent |
| `Ctrl+b` | Scroll docs vers le haut |
| `Ctrl+f` | Scroll docs vers le bas |
| `Ctrl+y` | Confirmer la sélection |

## Tabs (onglets)

| Raccourci | Description |
|-----------|-------------|
| `<leader>to` | Ouvrir un nouveau tab vide |
| `<leader>tf` | Ouvrir le fichier actuel dans un nouveau tab |
| `<leader>tn` | Aller au tab suivant |
| `<leader>tp` | Aller au tab précédent |
| `<leader>tx` | Fermer le tab actuel |
| `gt` | Tab suivant (natif vim) |
| `gT` | Tab précédent (natif vim) |
| `1gt`, `2gt`... | Aller au tab numéro 1, 2, etc. |

## Splits (fenêtres divisées)

| Raccourci | Description |
|-----------|-------------|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Égaliser la taille des splits |
| `<leader>sx` | Fermer le split actuel |
| `Ctrl+w h/j/k/l` | Naviguer entre les splits |

## Nvim-tree (explorateur de fichiers)

| Raccourci | Description |
|-----------|-------------|
| `<leader>ee` | Toggle nvim-tree |
| `<leader>ef` | Toggle nvim-tree sur le fichier actuel |
| `<leader>ec` | Collapse tous les dossiers |
| **Dans nvim-tree :** | |
| `Entrée` ou `o` | Ouvrir fichier/dossier |
| `t` | Ouvrir dans un nouveau tab |
| `v` | Ouvrir en split vertical |
| `h` | Ouvrir en split horizontal |
| `j`/`k` | Naviguer haut/bas |
| `P` | Aller au répertoire parent |
| `g?` | Afficher l'aide |

## Telescope (recherche)

| Raccourci | Description |
|-----------|-------------|
| **Dans les résultats :** | |
| `Ctrl+t` | Ouvrir dans un nouveau tab |
| `Ctrl+v` | Ouvrir en split vertical |
| `Ctrl+x` | Ouvrir en split horizontal |

## Lazygit

| Raccourci | Description |
|-----------|-------------|
| `<leader>lg` | Ouvrir Lazygit |

## Yazi (dans terminal)

| Raccourci | Description |
|-----------|-------------|
| `e` | Éditer fichier/dossier avec nvim |

## Sélection visuelle

| Raccourci | Description |
|-----------|-------------|
| `v` | Mode visuel (sélection caractère par caractère) |
| `V` | Mode visuel ligne (sélection ligne par ligne) |
| `Ctrl+v` | Mode visuel bloc (sélection rectangulaire) |
| `J` | Déplacer la sélection vers le bas |
| `K` | Déplacer la sélection vers le haut |
| `<` | Dé-indenter la sélection |
| `>` | Indenter la sélection |

## Divers

| Raccourci | Description |
|-----------|-------------|
| `<leader>fp` | Copier le chemin du fichier dans le clipboard |
| `<leader>Y` | Copier vers le clipboard système |
| `<leader>d` | Supprimer sans copier dans le registre |
| `Ctrl+c` | Escape / Clear search highlight |
| `Ctrl+d` | Descendre (curseur centré) |
| `Ctrl+u` | Monter (curseur centré) |
| `jk` | Escape (en mode insertion) |
| `gcc` | Commenter/décommenter une ligne |

## Auto-complétion JSX/TSX

Les balises JSX/TSX se ferment automatiquement :
- Tapez `<Button>` → devient automatiquement `<Button></Button>`
- Renommez `<Button>` en `<Link>` → la balise fermante devient `</Link>`

---

**Note :** `<leader>` = touche Espace
