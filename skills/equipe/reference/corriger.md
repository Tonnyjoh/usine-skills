# Corriger (phase 6)

Trois tours au maximum : au-delà, relancer ne fait que consommer des tokens, et le problème vient d'ailleurs (spec, contrat, architecture).

```
equipe tour <nom>
```

Si le code de sortie est 3 (`TOURS_EPUISES`), ne relance rien : passe à l'arrêt ci-dessous.

## Un tour

1. Regroupe les problèmes par agent développeur.
2. Renvoie-les-lui dans un brief complet ([briefs.md](briefs.md)), avec pour chacun le critère concerné et la **preuve** : commande, sortie, attendu et obtenu.
3. Contrôle le périmètre (`equipe scope-check`), puis repasse par [integrer.md](integrer.md) : `equipe avancer <nom> integration`, fusion si nécessaire, `verify --tout`, `avancer controles`.
4. Relance les contrôles avec un contexte vierge, sans leur dire ce qui a été corrigé.

Un test en échec se corrige dans le code. S'il semble faux, c'est une question de spec, pas une raison de l'assouplir.

Si l'ambiguïté vient de la spec, **ne tranche pas** : pose la question. Une réponse qui change la spec demande un nouvel accord (`equipe approuver`).

## Après trois tours sans succès

```
equipe arreter <nom> --raison "<ce qui résiste>"
```

Puis [bilan.md](bilan.md) : ce qui résiste, ce qui a été essayé et ce qu'il faudrait décider.
