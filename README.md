# equipe

Une équipe d'agents pour Claude Code, à la carte. Dans n'importe quel projet :

```
/equipe ajouter front test
```

La skill lit le projet, déduit la stack et les commandes de test, te montre un tableau à valider, puis crée les agents dans `.claude/agents/`. Plus tard, si tu as besoin d'un backend :

```
/equipe ajouter back
```

## Installation

En plugin :

```
/plugin marketplace add Tonnyjoh/usine-skills
/plugin install equipe@usine-skills
```

Les commandes s'écrivent alors `/equipe:equipe ajouter front test`.

Ou en skill personnelle, pour écrire simplement `/equipe` :

```bash
git clone https://github.com/Tonnyjoh/usine-skills ~/usine-skills
ln -s ~/usine-skills/skills/equipe ~/.claude/skills/equipe
```

Il faut Python 3 et git ; aucune autre dépendance.

## Avec d'autres outils que Claude

La skill est faite pour Claude Code. Sur un projet partagé, ajoute `codex` à `projet.outils` dans `.equipe/team.json`, relance le scaffold, et installe la skill aussi dans `~/.agents/skills/equipe`, où Codex l'appelle avec `$equipe`. Ce support suit la documentation de Codex, mais n'a pas été essayé dans une vraie session Codex.

| | Claude Code | Codex | Autres outils |
|---|---|---|---|
| Script et garde-fous | Oui | Oui | Oui |
| Règles du projet | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md`, si l'outil le lit |
| Agents spécialisés | `.claude/agents/` | `.codex/agents/` | Non : l'outil joue les rôles lui-même |
| Parallèle isolé | Oui | Seulement si le bac à sable autorise `git worktree`, sinon séquentiel | Selon l'outil |
| Agents vraiment en lecture seule | Oui | Non : le script contrôle le diff après coup | Selon l'outil |

Les différences sont détaillées dans `skills/equipe/reference/outils.md`.

## Utilisation

Deux façons de s'en servir, selon la taille de la tâche.

**Une tâche ciblée :** appelle directement un agent, par exemple « demande au frontend de refaire le formulaire ».

**Une fonctionnalité complète :** `/equipe livrer export-factures` enchaîne tout, en s'arrêtant quand la décision te revient :

1. Spec et contrat d'API, puis **ton feu vert**
2. Développement, en parallèle si les périmètres le permettent
3. Intégration et vérifications
4. Contrôles indépendants : testeur, relecteur, sécurité
5. Trois tours de correction au maximum
6. Compte rendu, puis **ta décision** de committer ou non

| Commande | Rôle |
|---|---|
| `ajouter <agents>` | Ajouter des agents : `front`, `back`, `mobile`, `donnees`, `devops`, `test`, `relecteur`, `securite`, `ux`, `doc` |
| `composer` | Composer une équipe sur mesure, avec questions |
| `cadrer`, `developper`, `integrer`, `controler`, `corriger`, `bilan` | Lancer une phase seule |
| `livrer <fonctionnalité>` | Tout enchaîner |
| `etat` | Voir où en est une fonctionnalité |
| `docteur` | Repérer les écarts entre l'équipe déclarée et le projet |

Sans argument, `/equipe` regarde le projet et recommande la suite.

## Des règles appliquées, pas seulement écrites

Le script `skills/equipe/scripts/equipe` refuse ce qui ne doit pas passer :

- **Pas de développement sans feu vert.** Si la spec ou le contrat changent ensuite, l'accord doit être redonné.
- **« Terminé » veut dire vérifié.** Il exécute lui-même les commandes et enregistre leur résultat ; dès que le code change, le résultat est périmé.
- **Périmètres contrôlés sur le diff.** Un agent sorti de son périmètre ou ayant touché au contrat déclenche un incident.
- **Trois tours de correction au maximum,** puis arrêt et compte rendu.

Il ne remplace jamais un fichier existant sans te montrer le diff.

**Aucun commit sans te demander, à chaque fois.** Les agents laissent leur travail en modifications non committées, y compris en parallèle. Si tu acceptes un commit, on te demande aussi si tu veux la ligne `Co-Authored-By: … <noreply@…>` : plusieurs outils ou personnes pouvant intervenir, elle n'est jamais ajoutée d'office.

## Dans ton projet

| Fichier | Rôle |
|---|---|
| `.equipe/team.json` | L'équipe : la seule chose à modifier pour la changer |
| `.equipe/fonctionnalites/` | L'état de chaque fonctionnalité |
| `.claude/agents/*.md` | Les agents générés, que tu peux retoucher |
| `docs/specs/`, `docs/api/openapi.yaml` | Specs et contrat |
| `CLAUDE.md` | Section « Équipe d'agents » |

## Tests

```bash
bash tests/smoke.sh
```

## Licence

MIT
