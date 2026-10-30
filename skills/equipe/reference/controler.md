# Contrôles indépendants (phase 5)

Lance les agents de qualité actifs (`testeur`, `relecteur`, `securite`) avec le brief minimal de [briefs.md](briefs.md), et rien de plus. Le testeur d'abord s'il écrit des fichiers : les deux relectures portent alors aussi sur ses tests. Relecteur et sécurité peuvent tourner en parallèle.

Sans agent de qualité actif, dis-le : la livraison n'aura que les tests des développeurs, écrits par ceux qui ont écrit le code.

Après chaque agent :

```
equipe scope-check <agent> --fonctionnalite <nom>
```

Un relecteur qui a modifié un fichier est un incident, tout comme un testeur qui a modifié du code applicatif.

Trie ensuite les résultats sans les adoucir :

| Résultat | Suite |
|---|---|
| Tests en échec, points bloquants ou importants | [corriger.md](corriger.md) |
| Ambiguïté de spec | Question à l'utilisateur, ne tranche pas |
| Point mineur | À lister dans le bilan, sans tour de correction, sauf demande contraire |
| Rien à signaler | Vérification finale, puis bilan |

Vérification finale, indispensable car le testeur a ajouté des fichiers :

```
equipe verify <nom> --tout
equipe avancer <nom> termine
```
