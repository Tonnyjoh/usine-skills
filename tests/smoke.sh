#!/usr/bin/env bash
# Parcours complet du script sur des projets jetables. Sort en erreur au premier écart.
set -u
E="$(cd "$(dirname "$0")/.." && pwd)/skills/equipe/scripts/equipe"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
echecs=0
attend() { # code attendu, puis commande
  local voulu=$1; shift
  local sortie; sortie=$(python3 "$E" "$@" 2>&1); local c=$?
  if [ "$c" != "$voulu" ]; then echo "ÉCHEC : equipe $* -> $c (attendu $voulu)"; echo "$sortie" | head -8; echecs=$((echecs+1)); else echo "ok    : equipe $*"; fi
}
contient() { # texte, fichier
  grep -q -- "$1" "$2" || { echo "ÉCHEC : « $1 » absent de $2"; echecs=$((echecs+1)); }
}

# --- un développeur, un testeur, dans l'arbre courant
mkdir -p "$T/app/src" "$T/app/tests"; cd "$T/app"; git init -q -b main
echo '{"name":"demo","scripts":{"test":"node tests/ok.js"},"dependencies":{"next":"15","react":"19"}}' > package.json
echo 'console.log("ok")' > tests/ok.js; echo 'export const a=1' > src/a.js
git add -A; git commit -qm init
attend 2 proposer            # au moins un agent
attend 2 proposer licorne
attend 0 proposer front test
[ ! -e .equipe/team.json ] || { echo "ÉCHEC : proposer a écrit sans --ecrire"; echecs=$((echecs+1)); }
attend 0 proposer front test --ecrire
attend 0 scaffold
contient 'name: frontend' .claude/agents/frontend.md
if grep -l '{{' .claude/agents/*.md CLAUDE.md; then echo "ÉCHEC : gabarit non résolu"; echecs=$((echecs+1)); fi
echo 'retouche' >> .claude/agents/frontend.md
attend 0 scaffold
contient 'retouche' .claude/agents/frontend.md   # jamais écrasé
sed -i '$d' .claude/agents/frontend.md
attend 0 demarrer f
attend 2 avancer f developpement                 # pas de feu vert
mkdir -p docs/specs; printf -- '- Statut : brouillon\n' > docs/specs/f.md
attend 2 approuver f --citation go               # pas de CA-1
printf -- '- Statut : brouillon\n- CA-1 : a\n' > docs/specs/f.md
attend 0 approuver f --citation go
contient 'validée' docs/specs/f.md
attend 0 avancer f developpement
echo 'export const b=2' > src/b.js
attend 0 scope-check frontend --fonctionnalite f
echo x > src/c.js
attend 2 scope-check testeur --fonctionnalite f  # code applicatif touché par le testeur
attend 0 avancer f integration
attend 2 avancer f controles                     # vérifications non lancées
attend 0 verify f --tout
attend 0 avancer f controles
echo 'export const d=3' > src/d.js
attend 2 avancer f termine                       # vérification périmée
attend 0 verify f --tout
echo '- CA-2 : b' >> docs/specs/f.md
attend 2 avancer f termine                       # spec changée après accord
sed -i '$d' docs/specs/f.md
attend 0 avancer f termine

# --- commande de vérification en échec
sed -i 's/console.log("ok")/process.exit(1)/' tests/ok.js
attend 0 demarrer g
printf -- '- Statut : b\n- CA-1 : a\n' > docs/specs/g.md
attend 0 approuver g --citation go
attend 0 avancer g developpement
attend 0 avancer g integration
attend 2 verify g --tout
attend 2 avancer g controles

# --- ajout d'un backend : contrat obligatoire, testeur étendu, worktrees
mkdir -p "$T/mono/front" "$T/mono/back"; cd "$T/mono"; git init -q -b main
echo '{"name":"f","scripts":{"test":"node -e 0"},"dependencies":{"react":"19"}}' > front/package.json
echo '{"name":"b","scripts":{"test":"node -e 0"},"dependencies":{"express":"4"}}' > back/package.json
git add -A; git commit -qm init
attend 0 proposer front test --ecrire
attend 0 scaffold
attend 0 proposer back --ecrire
contient '"contrat": "docs/api/openapi.yaml"' .equipe/team.json
contient 'cd back' .equipe/team.json
attend 0 scaffold --ecraser CLAUDE.md --ecraser .claude/agents/testeur.md
contient 'backend' CLAUDE.md
attend 0 doctor
git add -A; git commit -qm equipe
attend 0 demarrer h
printf -- '- Statut : b\n- CA-1 : a\n' > docs/specs/h.md
attend 0 approuver h --citation go
python3 "$E" preflight h | grep -q '"mode": "worktree"' || { echo "ÉCHEC : mode worktree attendu"; echecs=$((echecs+1)); }
git worktree add -q -b avant ../wt-avant HEAD   # part d'avant la branche de travail
git switch -qc equipe/h; git add -A; git commit -qm spec
attend 0 avancer h developpement
git worktree add -q -b wt-front ../wt-front HEAD
echo 1 > ../wt-front/front/x.js; git -C ../wt-front add -A; git -C ../wt-front commit -qm front
attend 0 scope-check frontend --worktree ../wt-front
python3 "$E" scope-check frontend --worktree ../wt-avant | grep -q base_divergente || { echo "ÉCHEC : base divergente non vue"; echecs=$((echecs+1)); }
git worktree add -q -b wt-mal ../wt-mal HEAD
echo 1 > ../wt-mal/back/y.js; git -C ../wt-mal add -A; git -C ../wt-mal commit -qm mal
attend 2 scope-check frontend --worktree ../wt-mal
git merge -q --no-ff -m m wt-front || { echo "ÉCHEC : fusion"; echecs=$((echecs+1)); }
attend 0 avancer h integration
for i in 1 2 3; do attend 0 tour h; attend 0 avancer h integration; done
attend 3 tour h                                  # quatrième tour refusé
attend 0 arreter h --raison test

# --- sans équipe, dossier personnel
cd "$T"; attend 2 scaffold
HOME="$T/app" bash -c "cd '$T/app' && rm -rf .equipe && python3 '$E' context" | grep -q PAS_UN_PROJET || { echo "ÉCHEC : dossier personnel non détecté"; echecs=$((echecs+1)); }

echo; [ "$echecs" = 0 ] && echo "Tout passe." || { echo "$echecs échec(s)."; exit 1; }
