# Développer (phase 3)

## 1. Préparer

```
equipe preflight <nom>
```

Il vérifie le feu vert et donne le mode. S'il bloque, rapporte le code : `ARBRE_NON_PROPRE` par exemple est une décision pour l'utilisateur (committer, mettre de côté ou passer en séquentiel), car un worktree ne verrait pas ces fichiers.

Puis :

```
equipe avancer <nom> developpement
```

Cette commande mémorise l'état de départ, qui sert de référence aux contrôles de périmètre.

## 2. Lancer

| Mode | Comment | Pourquoi |
|---|---|---|
| `sequentiel` | Un agent à la fois, dans l'arbre courant | Un seul développeur, ou pas d'isolation possible |
| `par-depot` | En parallèle, sans worktree | Chaque dépôt isole déjà son développeur |
| `worktree` | En parallèle, chacun dans son worktree ([outils.md](outils.md)) | Une copie git par agent |

Si les tâches dépendent l'une de l'autre, passe en séquentiel quel que soit le mode, et dis pourquoi. Par exemple, un frontend qui a besoin de migrations déjà écrites.

Lance les agents parallèles en même temps, chacun avec un brief complet ([briefs.md](briefs.md)). La façon de lancer un agent dépend de ton outil : voir [outils.md](outils.md).

## 3. Après chaque rapport

Vérifie le périmètre sur ce qui a été réellement modifié, pas sur ce que l'agent déclare :

```
equipe scope-check <agent> --fonctionnalite <nom>     # sequentiel, par-depot
equipe scope-check <agent> --worktree <chemin>        # worktree
```

- `hors_perimetre` ou `spec_ou_contrat_touches` : incident. Signale-le, puis fais annuler ou reprendre ce travail.
- `base_divergente` : le worktree ne part pas de la branche courante. Résous ce point avant d'intégrer.

En séquentiel, lance-le **après chaque agent** : le script accepte alors ses fichiers comme référence pour contrôler le suivant.

Si un agent est `bloqué` sur le contrat, passe à [integrer.md](integrer.md), étape 1.
