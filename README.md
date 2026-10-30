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

Il faut Python 3 ; aucune autre dépendance.

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

Il ne remplace jamais un fichier existant sans te montrer le diff, et ne commit jamais sur tes branches. Le seul cas de commit : en mode parallèle, des commits locaux sur des branches `equipe/*`, annoncés au feu vert.

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
