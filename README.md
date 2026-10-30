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

To choose the stack yourself, or on an empty project:

```
/team add front:next design test
```

## Design agent

`design` keeps the interface from looking like generic AI output. Before any code, it studies real references on Awwwards and Dribbble, then writes a visual direction that you approve. After the build, it reviews the result against that direction.

- **With impeccable:** it uses the [impeccable](https://impeccable.style) skill if installed, and works without it.
- **With Claude in Chrome:** it sees the references for real when the extension is connected and the site is permitted, read-only on public pages. Otherwise it has only text and titles, and says so.
- **`team design-check`:** blocks the delivery on em dashes in interface text, emoji anywhere in the code, sparkle and magic-wand icons, and generic fonts (Inter, Roboto, Open Sans, Poppins, Arial, Geist, Fraunces, Plus Jakarta Sans, Space Grotesk). A font your project chose goes in `project.design.allowed_fonts`.

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
2. With a design agent: visual direction, then **your go-ahead**
3. Development, in parallel if the scopes allow it
4. Integration and verifications
5. Independent checks: tester, reviewer, security, design
6. Three fix rounds at most
7. Report, then **your decision** to commit or not

| Command | Role |
|---|---|
| `add <agents>` | Add agents: `front`, `back`, `mobile`, `data`, `devops`, `design`, `test`, `review`, `security`, `ux`, `doc`. Stack after a colon: `front:next`, `back:nest` |
| `compose` | Compose a custom team, with questions |
| `plan`, `design`, `build`, `integrate`, `review`, `fix`, `report` | Run a single phase |
| `ship <feature>` | Chain everything |
| `ship --auto <feature>` | Chain everything without asking, up to the commit |
| `status` | See where a feature stands |
| `doctor` | Spot gaps between the declared team and the project |

With no argument, `/team` looks at the project and recommends what to do next.

## Auto mode

`/team ship --auto invoice-export` takes the team, spec and design decisions on its own and records them. You get a verified project and a list of what was decided for you.

It still stops before any commit, push or deployment, on an irreversible action, after three fix rounds, and when something only you have is missing, such as a secret. All the checks stay. Passing them only proves what the spec says, and in this mode the skill wrote the spec, so look at the result. It can also build a whole project on a direction you would have rejected: it costs more tokens than stopping early. Allow your usual commands in Claude Code's settings first, because background agents cannot answer permission prompts.

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
| `docs/specs/`, `docs/api/openapi.yaml`, `docs/design/` | Specs, contract and design directions |
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

Pour choisir toi-même la stack, ou sur un projet vide :

```
/team add front:next design test
```

Les commandes sont en anglais, mais tu peux parler à Claude en français : il te répond dans ta langue.

## L'agent design

`design` évite que l'interface ressemble à une sortie d'IA générique. Avant tout code, il étudie de vraies références sur Awwwards et Dribbble, puis rédige une direction visuelle que tu valides. Après la construction, il contrôle le résultat par rapport à cette direction.

- **Avec impeccable :** il utilise le skill [impeccable](https://impeccable.style) s'il est installé, et fonctionne sans.
- **Avec Claude in Chrome :** il voit réellement les références quand l'extension est connectée et le site autorisé, en lecture seule sur des pages publiques. Sinon, il n'a que du texte et des titres, et il le dit.
- **`team design-check` :** bloque la livraison en cas de cadratins dans les textes d'interface, d'emoji dans le code, d'icônes d'étincelles ou de baguette magique, et de polices génériques (Inter, Roboto, Open Sans, Poppins, Arial, Geist, Fraunces, Plus Jakarta Sans, Space Grotesk). Une police choisie par ton projet se déclare dans `project.design.allowed_fonts`.

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
2. Avec un agent design : direction visuelle, puis **ton feu vert**
3. Développement, en parallèle si les périmètres le permettent
4. Intégration et vérifications
5. Contrôles indépendants : testeur, relecteur, sécurité, design
6. Trois tours de correction au maximum
7. Compte rendu, puis **ta décision** de committer ou non

| Commande | Rôle |
|---|---|
| `add <agents>` | Ajouter des agents : `front`, `back`, `mobile`, `data`, `devops`, `design`, `test`, `review`, `security`, `ux`, `doc`. Stack après deux-points : `front:next`, `back:nest` |
| `compose` | Composer une équipe sur mesure, avec questions |
| `plan`, `design`, `build`, `integrate`, `review`, `fix`, `report` | Lancer une phase seule |
| `ship <feature>` | Tout enchaîner |
| `ship --auto <feature>` | Tout enchaîner sans demander, jusqu'au commit |
| `status` | Voir où en est une fonctionnalité |
| `doctor` | Repérer les écarts entre l'équipe déclarée et le projet |

Sans argument, `/team` regarde le projet et recommande la suite.

## Le mode automatique

`/team ship --auto invoice-export` prend seul les décisions d'équipe, de spec et de design, et les enregistre. Tu récupères un projet vérifié et la liste de ce qui a été décidé à ta place.

Il s'arrête quand même avant tout commit, push ou déploiement, sur une action irréversible, après trois tours de correction, et quand il manque une chose que toi seul as, comme un secret. Tous les contrôles restent. Ils ne prouvent que ce que dit la spec, et dans ce mode c'est le skill qui l'a écrite : regarde donc le résultat. Il peut aussi construire tout un projet sur une direction que tu aurais refusée, ce qui coûte plus de tokens qu'un arrêt précoce. Autorise d'abord tes commandes habituelles dans les réglages de Claude Code, car les agents en arrière-plan ne peuvent pas répondre aux demandes d'autorisation.

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
| `docs/specs/`, `docs/api/openapi.yaml`, `docs/design/` | Specs, contrat et directions visuelles |
| `CLAUDE.md` | Section « Agent team » |

## Tests

```bash
bash tests/smoke.sh
```

## Licence

MIT
