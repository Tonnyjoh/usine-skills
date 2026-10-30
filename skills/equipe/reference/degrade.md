# Mode dégradé

## Agents du projet non reconnus

Des fichiers créés dans `.claude/agents/` peuvent n'être chargés qu'au redémarrage. Propose de relancer la session ou de lancer `/agents`, puis de continuer avec « Continue à la phase 1 ». Si l'utilisateur préfère continuer tout de suite :

1. Lis `.claude/agents/<nom>.md`.
2. Lance l'agent généraliste (`general-purpose`) avec, en tête du prompt, le corps de ce fichier sans son en-tête, puis le brief.
3. Signale la substitution une fois. La garantie change sur un point : les outils de l'en-tête ne s'appliquent plus, donc le contrôle `scope-check` devient la seule barrière pour les agents en lecture seule.

## Pas de sous-agents dans cet environnement

Exécute les rôles toi-même, l'un après l'autre, en mode séquentiel. Pour chaque rôle, adopte seulement les instructions de son fichier.

Un contrôle mené par celui qui vient d'écrire le code n'est pas indépendant, même exécuté avec soin. Dis-le clairement dans le bilan. Rien d'autre ne change : les arrêts, `verify` et les trois tours restent valables.

## Pas de git

Ni worktree, ni `scope-check`, ni empreinte : une vérification ne devient donc jamais « périmée ». Propose `git init`, avec accord. Sinon, travaille en séquentiel, relance `verify --tout` en toute fin, et signale ces limites au bilan.
