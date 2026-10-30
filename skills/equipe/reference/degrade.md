# Mode dégradé

## Agents du projet non reconnus

Des fichiers d'agents tout juste créés peuvent n'être chargés qu'au redémarrage. Propose de relancer la session (ou de lancer `/agents` dans Claude Code), puis de continuer avec « Continue à la phase 1 ». Si l'utilisateur préfère continuer tout de suite, ou si ton outil n'a pas de format d'agent généré :

1. Lis le fichier de l'agent, ou, s'il n'y en a aucun pour ton outil, `.claude/agents/<nom>.md` ou `.codex/agents/<nom>.toml`.
2. Lance l'agent générique de ton outil avec, en tête du prompt, les instructions de ce fichier sans son en-tête, puis le brief.
3. Signale la substitution une fois. La garantie change sur un point : les restrictions d'outils ne s'appliquent plus, donc le contrôle `scope-check` devient la seule barrière pour les agents en lecture seule.

## Pas de sous-agents dans cet environnement

Exécute les rôles toi-même, l'un après l'autre, en mode séquentiel. Pour chaque rôle, adopte seulement les instructions de son fichier d'agent.

Un contrôle mené par celui qui vient d'écrire le code n'est pas indépendant, même exécuté avec soin. Dis-le clairement dans le bilan. Rien d'autre ne change : les arrêts, `verify` et les trois tours restent valables.

## Pas de git

Ni worktree, ni `scope-check`, ni empreinte : une vérification ne devient donc jamais « périmée ». Propose `git init`, avec accord. Sinon, travaille en séquentiel, relance `verify --tout` en toute fin, et signale ces limites au bilan.
