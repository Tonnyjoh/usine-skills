# Cadrer une fonctionnalité (phases 1 et 2)

Tu travailles seul : aucun agent n'est lancé avant le feu vert. C'est le moment le moins cher pour corriger une erreur, et celui qui décide le plus souvent de la qualité finale.

Si la demande est en réalité une petite tâche, dis-le et traite-la directement.

## 1. Comprendre

`equipe demarrer <nom-en-minuscules-avec-tirets>`, puis explore le code pour comprendre les conventions et ce qui existe déjà.

Si des informations essentielles manquent, pose **au maximum 5 questions courtes, en une fois**. Ne demande pas ce que le code ou un choix conventionnel établit.

## 2. Écrire la spec

`<dossier_specs>/<nom>.md` d'après `_modele-spec.md`. Le critère de qualité : un testeur qui n'a lu que ce fichier sait quoi vérifier.

- Critères numérotés CA-1, CA-2… sous la forme « Étant donné…, quand…, alors <résultat observable> ». « L'interface est agréable » ne se teste pas ; « le bouton est désactivé tant que l'e-mail est invalide » se teste.
- Règles métier RM-x, cas d'erreur CE-x, interface et ses états (chargement, vide, erreur, accès refusé), contraintes, hors périmètre.
- Toute décision que tu as prise à la place de l'utilisateur va dans « Questions ouvertes » ou dans les hypothèses que tu présenteras.

## 3. Compléter le contrat

Endpoints, schémas, codes d'erreur, emploi du schéma `Error`. Précis jusqu'au nom des champs : tout ce qui reste vague sera interprété différemment de chaque côté. Sans API, un contrat d'interface équivalent (types partagés, événements) joue le même rôle.

## 4. Valider : arrêt obligatoire

**Arrête-toi** et présente :

- un résumé de la spec et du contrat ;
- les hypothèses faites ;
- la répartition prévue : quel agent, quels critères ;
- le mode, donné par `equipe preflight` : séquentiel, par dépôt ou worktree.

Ne délègue rien avant un feu vert explicite. Un « ok » à une autre question n'en est pas un.

## 5. Enregistrer l'accord

```
equipe approuver <nom> --citation "<les mots exacts de l'utilisateur>"
```

Le script passe la spec en « validée » et mémorise son empreinte et celle du contrat. Si l'un des deux change ensuite, le développement est refusé (`SPEC_MODIFIEE_APRES_ACCORD`) : présente le changement, obtiens un nouvel accord, puis relance cette commande.
