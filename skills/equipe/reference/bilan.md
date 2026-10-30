# Compte rendu final (phase 7)

Pars de `equipe etat <nom>` : les vérifications, les tours et les incidents y sont enregistrés, ce qui évite de reconstruire le bilan de mémoire. Annonce un échec aussi nettement qu'un succès.

```
## <Fonctionnalité> : livrée | livrée avec réserves | arrêtée

**Livré** : critères couverts (CA-x…), fichiers principaux
**Vérifications** : <commande> -> <résultat réel>, pour chacune
**Contrôles** : testeur, relecteur, sécurité : résultat, ou « non activé »
**Reste ou échoue** : quoi et pourquoi, ou « rien »
**Écarts** par rapport à la spec ou au contrat, et décisions prises
**Incidents** de périmètre, ou « aucun »
**Tours de correction** : n / 3
**À décider** : ce qui attend l'utilisateur (commit, fusion, branche equipe/<nom>, déploiement)
```

Mentionne aussi ce qui a affaibli les garanties : mode dégradé, script indisponible, rôle de qualité non activé.

Aucun commit, push, fusion finale ni déploiement sans accord explicite : le bilan les propose, il ne les exécute pas.
