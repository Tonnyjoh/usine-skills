# Intégrer (phase 4)

```
equipe avancer <nom> integration
```

## 1. Traiter les rapports

Si un agent est `bloqué` sur le contrat, **ne le contourne pas**. Explique le problème et la correction proposée, et attends l'accord. Après modification du contrat, enregistre un nouvel accord (`equipe approuver`) et informe tous les agents concernés : le contrat est le seul point commun.

## 2. Rassembler

- **sequentiel, par-depot :** les modifications sont déjà en place, rien à fusionner.
- **worktree :** dans la branche `equipe/<nom>`, pour chaque agent :

  ```
  git merge --no-ff <branche-du-worktree>
  ```

  Ces fusions locales sur `equipe/*` sont le mécanisme annoncé au feu vert. Elles ne touchent ni la branche d'origine ni le dépôt distant : la fusion finale reste à l'utilisateur.

Conflit : arbitre en respectant le contrat. Si le choix est métier, demande. Des périmètres disjoints n'ont normalement pas de conflit ; s'il y en a un, cherche pourquoi (fichier généré, lockfile).

Une fois tout fusionné, supprime les worktrees (`git worktree remove`) et leurs branches (`git branch -d`, qui refuse une branche non fusionnée).

## 3. Vérifier le résultat intégré

```
equipe verify <nom> --tout
```

Les vérifications de chaque agent ne prouvent rien sur l'ensemble : c'est ici qu'on découvre ce qui ne s'assemble pas. En cas d'échec, c'est un tour de correction ([corriger.md](corriger.md)). Quand tout passe :

```
equipe avancer <nom> controles
```

Ce passage est refusé si une vérification manque, échoue ou date d'avant la dernière modification du code.
