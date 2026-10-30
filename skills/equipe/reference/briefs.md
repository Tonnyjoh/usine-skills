# Briefs de délégation

Un sous-agent ne sait que ce que dit son brief. Donne des **chemins absolus** pour la spec et le contrat : un worktree part du dernier commit et ne contient pas ces fichiers s'ils ne sont pas encore committés.

## Développeur

```
1. Objectif : <une phrase>
2. Spec : <chemin absolu>, critères CA-x à CA-y
3. Contrat : <chemin absolu>, endpoints : <liste>
4. Périmètre : écriture dans <chemins>. Interdit : tout le reste, dont la spec et le contrat.
5. Contraintes : <architecture, conventions, bibliothèques propres à cette tâche>
6. Avant de rendre la main : <commande de vérification>
7. Rapport : le format de ta définition d'agent, avec la sortie réelle des commandes.
<Ligne de mode>
```

Ligne de mode, selon `equipe preflight` :

- **sequentiel** : « Tu travailles dans l'arbre courant. Pas de commit. »
- **par-depot** : « Tu travailles dans `<chemin absolu du dépôt>`. Pas de commit. »
- **worktree** : « Tu travailles dans un worktree isolé. Lance d'abord `<installation>`. Pas de commit : laisse tes modifications telles quelles. Donne le chemin du worktree dans ton rapport. »

## Agent de qualité

Seulement :

```
Spec : <chemin absolu>
Contrat : <chemin absolu>
À examiner : <diff ou périmètre, avec la commande pour l'obtenir>
Commandes : <vérifications>
Écriture : <dossiers de tests | aucune>
```

**Rien d'autre.** Ni rapports, ni explications des développeurs, ni résumé de ce qui a posé problème, ni tentatives précédentes. Une phrase du type « le backend gère déjà ce cas » suffit à fausser le contrôle, car l'agent cherche alors à confirmer. Au tour de correction, ne transmets pas non plus ce qui a été corrigé : il revérifie la spec.
