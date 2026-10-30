# Menu sans argument

L'utilisateur demande en fait « que dois-je faire ? ». Réponds à partir du résultat de `equipe context`, sans rien lancer.

Mène avec **une à trois recommandations**, chacune avec la commande exacte et une raison tirée des faits, puis montre le tableau des commandes.

- `PAS_UN_PROJET` : demande quel projet, en proposant `depots_recents`. Ne crée rien dans le dossier personnel.
- `EQUIPE_ABSENTE` : `/equipe composer`.
- `AGENT_NON_GENERE` ou `problemes_composition` non vide : `/equipe docteur`.
- Une fonctionnalité en cours : la commande de sa phase, selon le tableau ci-dessous.
- Équipe prête et rien en cours : `/equipe cadrer <fonctionnalité>` ou `/equipe livrer <fonctionnalité>`.

| Phase enregistrée | Prochaine commande |
|---|---|
| `cadrage` | `cadrer` : obtenir le feu vert |
| `valide` | `developper` |
| `developpement` | `integrer` |
| `integration` | `controler` |
| `controles` | `corriger` s'il y a des problèmes, sinon `bilan` |
| `correction` | `integrer` |
| `termine`, `arrete` | `bilan` s'il n'a pas été présenté ; sinon rien |

## Questions sur la démarche

Réponds sans exécuter. Pour conseiller une composition :

- **Commencer petit :** un développeur et un testeur, puis ajouter un rôle seulement devant un manque constaté (bugs qui passent, failles, documentation absente).
- **Chaque agent ajoute du coût et un risque de divergence.** Le parallélisme n'a de sens que si les périmètres sont vraiment indépendants.
- **Si le résultat est médiocre, regarde d'abord la spec :** la plupart des échecs viennent de critères d'acceptation vagues.
