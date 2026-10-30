# Livrer une fonctionnalité de bout en bout

Enchaîne les phases en chargeant chaque référence au moment où tu y arrives. « Livrer » n'autorise pas à sauter un arrêt : il évite seulement à l'utilisateur de retaper une commande entre deux.

1. [composer.md](composer.md) si l'équipe n'existe pas. **Arrêt : accord sur l'équipe.** Si les agents exigent un redémarrage, voir [degrade.md](degrade.md).
2. [cadrer.md](cadrer.md). **Arrêt : feu vert sur la spec, le contrat et la répartition.**
3. [developper.md](developper.md)
4. [integrer.md](integrer.md)
5. [controler.md](controler.md), puis [corriger.md](corriger.md) tant qu'il le faut, trois tours au maximum.
6. [bilan.md](bilan.md). **Arrêt : l'utilisateur décide du commit et de la suite.**

Entre deux arrêts, continue sans demander de confirmation. Une reprise après interruption part de `equipe etat`, jamais du souvenir de la conversation.
