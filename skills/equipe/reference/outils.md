# Selon ton outil

Le déroulé, le script et les fichiers sont les mêmes partout. Seuls changent les gestes ci-dessous.

| Geste | Claude Code | Codex | Autre outil |
|---|---|---|---|
| Invoquer la skill | `/equipe …` | `$equipe …` | Selon l'outil, ou lui faire lire `SKILL.md` |
| Fichiers d'agents | `.claude/agents/<nom>.md` | `.codex/agents/<nom>.toml` | Aucun : voir [degrade.md](degrade.md) |
| Lancer un agent | Outil `Agent`, `subagent_type` = le nom | Demander explicitement de lancer l'agent par son nom | Voir [degrade.md](degrade.md) |
| Isoler un agent | `isolation: "worktree"` | Crée le worktree toi-même (ci-dessous) | Crée le worktree toi-même, si l'outil le permet |
| Poser des questions | Outil de questions interactif | Message avec des choix numérotés | Message avec des choix numérotés |
| Règles lues | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md`, si l'outil le lit |

La skill vise d'abord Claude Code : par défaut, `projet.outils` dans `.equipe/team.json` vaut `["claude"]`. Sur un projet partagé avec Codex, mets `["claude", "codex"]`, puis relance `equipe scaffold` : il ajoute `.codex/agents/` et `AGENTS.md`. Le support de Codex suit sa documentation, mais n'a pas été essayé dans une vraie session Codex.

## Créer un worktree soi-même

```
git worktree add .equipe/worktrees/<agent> -b equipe-wt/<agent>
```

Ajoute `.equipe/worktrees/` au `.gitignore` local (`.git/info/exclude`) et donne à l'agent ce chemin absolu comme dossier de travail. Il part du dernier commit, comme tout worktree : les briefs gardent donc des chemins absolus vers la spec et le contrat.

Le bac à sable d'un outil peut refuser cette commande, car elle écrit dans `.git` (c'est le cas par défaut de Codex). Dans ce cas, ne l'élargis pas de toi-même : passe en **séquentiel** dans l'arbre courant, et dis pourquoi.

## Ce que chaque outil garantit vraiment

- **Lecture seule :** Claude Code retire les outils d'écriture de l'agent ; pas Codex, où un fichier d'agent ne peut limiter ni le bac à sable ni l'écriture. Là, la consigne seule l'en empêche : lance donc `equipe scope-check` après chaque relecteur, sans exception.
- **Modèle :** `modele` ne concerne que Claude Code. Un agent Codex hérite du modèle de la session, sauf si `modele_codex` est renseigné.
- **Indépendance des contrôles :** elle exige un agent au contexte vierge. Sans vrais sous-agents, dis-le au bilan.

Le script `equipe` demande seulement Python 3 et git, et ne dépend d'aucun outil.
