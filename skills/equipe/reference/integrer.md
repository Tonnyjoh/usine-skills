# Intégrer (phase 4)

```
equipe avancer <nom> integration
```

## 1. Traiter les rapports

Si un agent est `bloqué` sur le contrat, **ne le contourne pas**. Explique le problème et la correction proposée, et attends l'accord. Après modification du contrat, enregistre un nouvel accord (`equipe approuver`) et informe tous les agents concernés : le contrat est le seul point commun.

## 2. Rassembler

- **sequentiel, par-depot :** les modifications sont déjà en place, rien à reporter.
- **worktree :** pour chaque agent :

  ```
  equipe appliquer <agent> --worktree <chemin>
  ```

  La commande refuse un travail hors périmètre, puis reporte les modifications dans l'arbre principal **sans aucun commit**. L'utilisateur garde ainsi la décision à la fin.

Conflit (`APPLICATION_IMPOSSIBLE`) : arbitre en respectant le contrat. Si le choix est métier, demande. Des périmètres disjoints n'ont normalement pas de conflit ; s'il y en a un, cherche pourquoi (fichier généré, lockfile).

Une fois tout reporté et vérifié à l'étape 3, supprime les worktrees. Comme leurs modifications ne sont pas committées, `git worktree remove` exige `--force` : ne le fais qu'après avoir confirmé que chaque `appliquer` a réussi. Supprime ensuite leurs branches si tu les as créées.

## 3. Vérifier le résultat intégré

```
equipe verify <nom> --tout
```

Les vérifications de chaque agent ne prouvent rien sur l'ensemble : c'est ici qu'on découvre ce qui ne s'assemble pas. En cas d'échec, c'est un tour de correction ([corriger.md](corriger.md)). Quand tout passe :

```
equipe avancer <nom> controles
```

Ce passage est refusé si une vérification manque, échoue ou date d'avant la dernière modification du code.
