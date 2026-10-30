# Composer l'équipe (phase 0)

Objectif : un `.equipe/team.json` validé par l'utilisateur, d'où tout le reste est généré. Une composition se fait une fois ; pour la modifier, relis ce fichier et passe directement à l'étape 3.

## 1. Partir des faits

Utilise `equipe context`. Si `PAS_UN_PROJET` apparaît, demande le projet avant tout. `equipe catalogue` donne les spécialités connues et leurs consignes.

Si l'utilisateur a fourni une composition, reprends-la telle quelle. Une valeur vide ou restée entre `<...>` ne se devine pas.

## 2. Poser les questions manquantes

Avec des questions à choix ([outils.md](outils.md)), **en une seule fois et 4 questions au maximum** : rôles à activer, spécialité du backend, spécialité du frontend, commandes de vérification. Propose en premier la valeur déduite du dépôt. Ne demande pas ce que `context` établit avec certitude, mais une valeur « à préciser » ou une vérification `null` reste une vraie question : une équipe sans commande de vérification ne peut rien prouver.

Compositions types :

| Nom | Agents | Quand |
|---|---|---|
| Léger | un développeur full-stack + relecteur | Le plus fiable pour débuter, pas de parallélisme |
| Classique | backend + frontend + testeur | API et interface bien séparées |
| Mobile | backend + mobile + testeur + sécurité | Application mobile et API |
| Renforcé | backend + frontend + données + testeur + relecteur + sécurité | Projet sensible, coût nettement plus élevé |

Spécialités qualité et conception, à proposer si le rôle est actif :

- testeur : unitaires, intégration, contrat API, end-to-end, performance
- relecteur : généraliste, performance, lisibilité et architecture
- sécurité : OWASP Top 10, secrets et dépendances, authentification et droits
- ux : parcours, états d'interface, accessibilité
- documentation : documentation technique et README

## 3. Écrire `.equipe/team.json`

```json
{
  "version": 1,
  "projet": {
    "nom": "Mon projet",
    "objectif": "Une phrase.",
    "dossier_specs": "docs/specs",
    "contrat": "docs/api/openapi.yaml",
    "outils": ["claude"]
  },
  "agents": [
    {
      "nom": "backend",
      "role": "developpeur",
      "actif": true,
      "specialite": "Java / Spring Boot",
      "depot": ".",
      "perimetre": ["backend"],
      "installation": "./mvnw -q dependency:resolve",
      "verification": "cd backend && ./mvnw -q test",
      "modele": "sonnet"
    },
    {
      "nom": "testeur",
      "role": "testeur",
      "actif": true,
      "specialite": "tests d'acceptation et de contrat",
      "depot": ".",
      "perimetre": ["backend/src/test", "frontend/src/**/*.spec.ts"],
      "verification": "cd backend && ./mvnw -q test",
      "modele": "sonnet"
    }
  ]
}
```

Points qui comptent :

- `role` vaut `developpeur`, `testeur`, `relecteur`, `securite`, `ux` ou `documentation`. Plusieurs agents peuvent partager un rôle (`backend-api`, `backend-worker`) si leurs périmètres sont disjoints.
- `perimetre` et les chemins de `projet` sont **relatifs à la racine du projet**. La `verification` s'exécute dans `depot`.
- Hors catalogue, `specialite` vaut `autre: ...` : explore le dépôt, rédige `consignes` à partir des conventions réelles et demande confirmation. Ajoute `fonction` si le nom de l'agent ne dit pas ce qu'il implémente (« le service d'envoi », par exemple).
- `contrat` peut être `null` seulement avec un développeur unique et sans API touchée.
- `perimetre` du documentaliste : jamais les specs ni le contrat ; le script le signale comme incident de toute façon.

**Plusieurs dépôts sous une racine sans git** (`MULTI_DEPOTS`) : `depot` vaut le dossier du dépôt, `perimetre` commence par lui (`["api-monprojet"]`) et la session doit être lancée à la racine commune. Place specs et contrat dans le dépôt producteur (`api-monprojet/docs/specs`), sinon ils ne seraient versionnés nulle part.

## 4. Présenter et attendre

Applique ces règles et signale tout problème (`equipe preflight` les vérifie aussi) :

1. Au moins un développeur actif, sinon demande quoi faire.
2. Un seul développeur : mode séquentiel simple, le montage le plus fiable.
3. Plusieurs développeurs : périmètres disjoints et contrat écrit avant le code.
4. Plus de 4 agents actifs : préviens du coût et propose une version réduite.
5. Agents de qualité : toujours après l'intégration et avec un contexte vierge.

Affiche le tableau : agent, spécialité, périmètre, vérification, outils, modèle, en indiquant le mode prévu. **Attends l'accord avant de créer des fichiers.** Écrire `team.json` et générer viennent après.

## 5. Générer

```
equipe scaffold --essai    # ce qui serait créé, sans rien écrire
equipe scaffold
```

Le script ne remplace jamais un fichier existant différent : il le renvoie dans `a_confirmer` avec son diff. Montre ce diff, demande, et relance avec `--ecraser <fichier>` seulement après accord. C'est aussi le cas de la section ajoutée à un `CLAUDE.md` existant.

Il crée, pour chaque agent actif, un fichier par outil de `projet.outils` (`.claude/agents/<nom>.md`, `.codex/agents/<nom>.toml`), puis `<dossier_specs>/_modele-spec.md`, le squelette du contrat s'il manque, et la section « Équipe d'agents » de `CLAUDE.md`, ainsi que d'`AGENTS.md` si un autre outil est déclaré.

## 6. Rendre compte

Dis exactement ce qui a été créé et ce qui est resté intact. Les nouveaux agents ne sont parfois visibles qu'au redémarrage : demande de relancer la session ou de lancer `/agents`, ou applique [degrade.md](degrade.md) si l'utilisateur préfère continuer tout de suite.
