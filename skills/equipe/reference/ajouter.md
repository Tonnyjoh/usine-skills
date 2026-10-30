# Ajouter des agents

La voie courte : l'utilisateur nomme les agents voulus, tu déduis le reste du projet. Pas d'interrogatoire. Le même chemin sert à la première installation et à l'ajout d'un agent plus tard (`ajouter backend` sur une équipe existante).

## 1. Proposer

```
equipe proposer front test
```

Noms reconnus : `front`, `back`, `mobile`, `donnees`, `devops`, `test`, `relecteur`, `securite`, `ux`, `doc`.

Rien n'est écrit à ce stade.

## 2. Confirmer

Montre `tableau` en une seule fois et demande un simple accord. Pose une question seulement pour ce qui figure dans `a_confirmer` ou `problemes` : ce sont les cas où le dépôt ne permet pas de conclure, et une équipe sans commande de vérification ne pourrait rien prouver.

Si ces questions changent la proposition, modifie ensuite `.equipe/team.json` (voir son format dans [composer.md](composer.md)).

Dès le deuxième développeur, un contrat devient obligatoire et `proposer` en ajoute le chemin : dis-le en une phrase, car c'est ce qui permet à front et back de travailler sans se marcher dessus.

## 3. Générer

```
equipe proposer front test --ecrire
equipe scaffold
```

Les fichiers existants ne sont pas remplacés : `a_confirmer` renvoie leur diff, y compris pour un `CLAUDE.md` existant. Montre-le et relance avec `--ecraser <fichier>` après accord.

## 4. Conclure

En deux lignes : les agents disponibles, et comment s'en servir.

- Pour une fonctionnalité complète : `/equipe livrer <fonctionnalité>`.
- Pour une tâche ciblée, les agents s'appellent aussi directement (« demande au frontend de… »), sans le déroulé complet.

Si les nouveaux agents ne sont pas reconnus dans cette session, indique qu'un redémarrage ou `/agents` les chargera.
