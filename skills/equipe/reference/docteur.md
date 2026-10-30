# Docteur

Compare l'équipe déclarée à ce qui existe dans le projet. C'est de la maintenance : ne lance aucun agent et ne modifie aucun code.

```
equipe doctor
```

Une liste `constats` vide est le bon résultat : dis-le en une ligne et arrête-toi.

La sévérité dit quoi faire, pas à quel point c'est grave :

- **`auto`** : aucune décision à prendre, applique le correctif (`equipe scaffold`), puis rapporte-le en une ligne.
- **`mention`** : énonce-le avec le correctif proposé. Un agent retouché à la main (`agent-derive`) peut être voulu : ne l'écrase jamais d'office.
- **`route`** : nomme la commande qui réglerait le problème, et ne la lance que si l'utilisateur le demande.

Présente tout en une passe. Ne répare jamais ces écarts en marge d'une livraison : tu changerais les règles pendant que l'équipe travaille.
