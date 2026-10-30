# team

**English** · [Français](#français)

An à la carte team of agents for Claude Code. In any project:

```
/team add front test
```

The skill reads the project, deduces the stack and test commands, shows you a table to approve, then creates the agents in `.claude/agents/`. Later, if you need a backend:

```
/team add back
```

## Installation

As a plugin:

```
/plugin marketplace add Tonnyjoh/usine-skills
/plugin install team@usine-skills
```

Commands are then written `/team:team add front test`.

Or as a personal skill, to simply type `/team`:

```bash
git clone https://github.com/Tonnyjoh/usine-skills ~/usine-skills
ln -s ~/usine-skills/skills/team ~/.claude/skills/team
```

Requires Python 3 and git; no other dependency.

## With tools other than Claude

The skill is built for Claude Code. On a shared project, add `codex` to `project.tools` in `.team/team.json`, rerun the scaffold, and also install the skill in `~/.agents/skills/team`, where Codex calls it with `$team`. This support follows the Codex documentation but has not been tried in a real Codex session.

| | Claude Code | Codex | Other tools |
|---|---|---|---|
| Script and guardrails | Yes | Yes | Yes |
| Project rules | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md`, if the tool reads it |
| Specialized agents | `.claude/agents/` | `.codex/agents/` | No: the tool plays the roles itself |
| Isolated parallel work | Yes | Only if the sandbox allows `git worktree`, otherwise sequential | Depends on the tool |
| Truly read-only agents | Yes | No: the script checks the diff afterwards | Depends on the tool |

The differences are detailed in `skills/team/reference/tools.md`.

## Usage

Two ways to use it, depending on the size of the task.

**A targeted task:** call an agent directly, for example "ask the frontend to redo the form".

**A complete feature:** `/team ship invoice-export` chains everything, stopping when the decision is yours:

1. Spec and API contract, then **your go-ahead**
2. Development, in parallel if the scopes allow it
3. Integration and verifications
4. Independent checks: tester, reviewer, security
5. Three fix rounds at most
6. Report, then **your decision** to commit or not

| Command | Role |
|---|---|
| `add <agents>` | Add agents: `front`, `back`, `mobile`, `data`, `devops`, `test`, `review`, `security`, `ux`, `doc` |
| `compose` | Compose a custom team, with questions |
| `plan`, `build`, `integrate`, `review`, `fix`, `report` | Run a single phase |
| `ship <feature>` | Chain everything |
| `status` | See where a feature stands |
| `doctor` | Spot gaps between the declared team and the project |

With no argument, `/team` looks at the project and recommends what to do next.

## Rules that are enforced, not just written

The `skills/team/scripts/team` script refuses what must not pass:

- **No development without a go-ahead.** If the spec or contract changes afterwards, approval must be given again.
- **"Done" means verified.** It runs the commands itself and records their result; as soon as the code changes, the result is stale.
- **Scopes checked on the diff.** An agent that leaves its scope or touches the contract triggers an incident.
- **Three fix rounds at most,** then a stop and a report.

It never replaces an existing file without showing you the diff.

**No commit without asking you, every time.** Agents leave their work as uncommitted changes, even in parallel. If you accept a commit, you are also asked whether you want the `Co-Authored-By: … <noreply@…>` line: since several tools or people may be involved, it is never added by default. Commit messages are written in English.

## In your project

| File | Role |
|---|---|
| `.team/team.json` | The team: the only thing to edit to change it |
| `.team/features/` | The state of each feature |
| `.claude/agents/*.md` | The generated agents, which you can edit |
| `docs/specs/`, `docs/api/openapi.yaml` | Specs and contract |
| `CLAUDE.md` | "Agent team" section |

## Tests

```bash
bash tests/smoke.sh
```

## License

MIT

---

# Français

[English](#team) · **Français**

Une équipe d'agents à la carte pour Claude Code. Dans n'importe quel projet :

```
/team add front test
```

Le skill lit le projet, déduit la stack et les commandes de test, te montre un tableau à valider, puis crée les agents dans `.claude/agents/`. Plus tard, si tu as besoin d'un backend :

```
/team add back
```

Les commandes sont en anglais, mais tu peux parler à Claude en français : il te répond dans ta langue.

## Installation

En plugin :

```
/plugin marketplace add Tonnyjoh/usine-skills
/plugin install team@usine-skills
```

Les commandes s'écrivent alors `/team:team add front test`.

Ou en skill personnel, pour écrire simplement `/team` :

```bash
git clone https://github.com/Tonnyjoh/usine-skills ~/usine-skills
ln -s ~/usine-skills/skills/team ~/.claude/skills/team
```

Il faut Python 3 et git ; aucune autre dépendance.

## Avec d'autres outils que Claude

Le skill est fait pour Claude Code. Sur un projet partagé, ajoute `codex` à `project.tools` dans `.team/team.json`, relance `team scaffold`, et installe aussi le skill dans `~/.agents/skills/team`, où Codex l'appelle avec `$team`. Ce support suit la documentation de Codex, mais n'a pas été essayé dans une vraie session Codex.

| | Claude Code | Codex | Autres outils |
|---|---|---|---|
| Script et garde-fous | Oui | Oui | Oui |
| Règles du projet | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md`, si l'outil le lit |
| Agents spécialisés | `.claude/agents/` | `.codex/agents/` | Non : l'outil joue les rôles lui-même |
| Parallèle isolé | Oui | Seulement si le bac à sable autorise `git worktree`, sinon séquentiel | Selon l'outil |
| Agents vraiment en lecture seule | Oui | Non : le script contrôle le diff après coup | Selon l'outil |

Les différences sont détaillées dans `skills/team/reference/tools.md`.

## Utilisation

Deux façons de s'en servir, selon la taille de la tâche.

**Une tâche ciblée :** appelle directement un agent, par exemple « demande au frontend de refaire le formulaire ».

**Une fonctionnalité complète :** `/team ship invoice-export` enchaîne tout, en s'arrêtant quand la décision te revient :

1. Spec et contrat d'API, puis **ton feu vert**
2. Développement, en parallèle si les périmètres le permettent
3. Intégration et vérifications
4. Contrôles indépendants : testeur, relecteur, sécurité
5. Trois tours de correction au maximum
6. Compte rendu, puis **ta décision** de committer ou non

| Commande | Rôle |
|---|---|
| `add <agents>` | Ajouter des agents : `front`, `back`, `mobile`, `data`, `devops`, `test`, `review`, `security`, `ux`, `doc` |
| `compose` | Composer une équipe sur mesure, avec questions |
| `plan`, `build`, `integrate`, `review`, `fix`, `report` | Lancer une phase seule |
| `ship <feature>` | Tout enchaîner |
| `status` | Voir où en est une fonctionnalité |
| `doctor` | Repérer les écarts entre l'équipe déclarée et le projet |

Sans argument, `/team` regarde le projet et recommande la suite.

## Des règles appliquées, pas seulement écrites

Le script `skills/team/scripts/team` refuse ce qui ne doit pas passer :

- **Pas de développement sans feu vert.** Si la spec ou le contrat changent ensuite, l'accord doit être redonné.
- **« Terminé » veut dire vérifié.** Il exécute lui-même les commandes et enregistre leur résultat ; dès que le code change, le résultat est périmé.
- **Périmètres contrôlés sur le diff.** Un agent sorti de son périmètre ou ayant touché au contrat déclenche un incident.
- **Trois tours de correction au maximum,** puis arrêt et compte rendu.

Il ne remplace jamais un fichier existant sans te montrer le diff.

**Aucun commit sans te demander, à chaque fois.** Les agents laissent leur travail en modifications non committées, y compris en parallèle. Si tu acceptes un commit, on te demande aussi si tu veux la ligne `Co-Authored-By: … <noreply@…>` : plusieurs outils ou personnes pouvant intervenir, elle n'est jamais ajoutée d'office. Les messages de commit s'écrivent en anglais.

## Dans ton projet

| Fichier | Rôle |
|---|---|
| `.team/team.json` | L'équipe : la seule chose à modifier pour la changer |
| `.team/features/` | L'état de chaque fonctionnalité |
| `.claude/agents/*.md` | Les agents générés, que tu peux retoucher |
| `docs/specs/`, `docs/api/openapi.yaml` | Specs et contrat |
| `CLAUDE.md` | Section « Agent team » |

## Tests

```bash
bash tests/smoke.sh
```

## Licence

MIT
