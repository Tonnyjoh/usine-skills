## Équipe d'agents

Géré par la skill `/equipe` (`.equipe/team.json`). Le chef de projet est la session principale.

{{TABLEAU}}

### Règles

1. Le contrat, écrit avant le code, est la source de vérité entre producteurs et consommateurs. Les développeurs ne le modifient jamais : s'il est insuffisant, ils s'arrêtent et le signalent.
2. Chaque agent n'écrit que dans son périmètre. Toute sortie est un incident à signaler.
3. Chaque sous-agent démarre sans mémoire : les briefs sont complets.
4. Les agents de qualité restent indépendants : spec et contrat, jamais le raisonnement des développeurs.
5. Une tâche n'est terminée que lorsque les vérifications passent réellement.
6. Aucune action irréversible sans accord explicite : suppression de données, `git push --force`, migration destructive, déploiement, envoi de messages.
7. Pas de secrets dans le code : variables d'environnement uniquement.
8. Pas de suppositions silencieuses : une ambiguïté devient une question.
9. Maximum 3 tours de correction par fonctionnalité.
10. Pas d'équipe pour une petite tâche : un bug isolé ou une modification étroite se traite directement.
11. Aucun commit sans le demander à l'utilisateur, à chaque fois. Lui demander aussi si le commit doit porter une ligne d'attribution (`Co-Authored-By: … <noreply@…>`) : plusieurs outils d'IA ou personnes peuvent intervenir sur ce projet, donc rien n'est ajouté d'office.

### Rapport des développeurs

```
STATUT : terminé | bloqué | partiel
FICHIERS MODIFIÉS : <liste>
CRITÈRES TRAITÉS : CA-x ...
VÉRIFICATIONS : <commande> -> <résultat réel>
PROBLÈMES / QUESTIONS : <liste ou "aucun">
ÉCARTS PAR RAPPORT AU CONTRAT : <liste ou "aucun">
```
