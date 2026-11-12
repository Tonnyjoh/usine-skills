#!/usr/bin/env bash
# Full run of the script on throwaway projects. Exits with an error on any mismatch.
set -u
E="$(cd "$(dirname "$0")/.." && pwd)/skills/team/scripts/team"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
failures=0
expect() { # expected code, then command
  local wanted=$1; shift
  local output; output=$(python3 "$E" "$@" 2>&1); local c=$?
  if [ "$c" != "$wanted" ]; then echo "FAIL: team $* -> $c (expected $wanted)"; echo "$output" | head -8; failures=$((failures+1)); else echo "ok  : team $*"; fi
}
contains() { # text, file
  grep -q -- "$1" "$2" || { echo "FAIL: '$1' missing from $2"; failures=$((failures+1)); }
}

# --- one developer, one tester, in the current tree
mkdir -p "$T/app/src" "$T/app/tests"; cd "$T/app"; git init -q -b main
echo '{"name":"demo","scripts":{"test":"node tests/ok.js"},"dependencies":{"next":"15","react":"19"}}' > package.json
echo 'console.log("ok")' > tests/ok.js; echo 'export const a=1' > src/a.js
git add -A; git commit -qm init
expect 2 propose            # at least one agent
expect 2 propose unicorn
expect 0 propose front test
[ ! -e .team/team.json ] || { echo "FAIL: propose wrote without --write"; failures=$((failures+1)); }
expect 0 propose front test --write
expect 0 scaffold
contains 'name: frontend' .claude/agents/frontend.md
if grep -l '{{' .claude/agents/*.md CLAUDE.md; then echo "FAIL: unresolved template"; failures=$((failures+1)); fi
contains 'noreply' CLAUDE.md
contains 'written in English' CLAUDE.md
[ ! -e AGENTS.md ] && [ ! -e .codex ] || { echo "FAIL: other tools' files created by default"; failures=$((failures+1)); }
echo 'edited' >> .claude/agents/frontend.md
expect 0 scaffold
contains 'edited' .claude/agents/frontend.md     # never overwritten
sed -i '$d' .claude/agents/frontend.md
expect 0 start f
expect 2 advance f development                   # no go-ahead
mkdir -p docs/specs; printf -- '- Status: draft\n' > docs/specs/f.md
expect 2 approve f --quote go                    # no AC-1
printf -- '- Status: draft\n- AC-1: a\n' > docs/specs/f.md
expect 0 approve f --quote go
contains 'Status: approved' docs/specs/f.md
expect 0 advance f development
echo 'export const b=2' > src/b.js
expect 0 scope-check frontend --feature f
echo x > src/c.js
expect 2 scope-check tester --feature f          # application code touched by the tester
expect 0 advance f integration
expect 2 advance f review                        # verifications not run
expect 0 verify f --all
expect 0 advance f review
echo 'export const d=3' > src/d.js
expect 2 advance f done                          # stale verification
expect 0 verify f --all
echo '- AC-2: b' >> docs/specs/f.md
expect 2 advance f done                          # spec changed after approval
sed -i '$d' docs/specs/f.md
expect 0 advance f done

# --- failing verification command
sed -i 's/console.log("ok")/process.exit(1)/' tests/ok.js
expect 0 start g
printf -- '- Status: d\n- AC-1: a\n' > docs/specs/g.md
expect 0 approve g --quote go
expect 0 advance g development
expect 0 advance g integration
expect 2 verify g --all
expect 2 advance g review

# --- adding a backend: mandatory contract, extended tester, Codex, worktrees
mkdir -p "$T/mono/front" "$T/mono/back"; cd "$T/mono"; git init -q -b main
echo '{"name":"f","scripts":{"test":"node -e 0"},"dependencies":{"react":"19"}}' > front/package.json
echo '{"name":"b","scripts":{"test":"node -e 0"},"dependencies":{"express":"4"}}' > back/package.json
git add -A; git commit -qm init
expect 0 propose front test --write
expect 0 scaffold
expect 0 propose back --write
contains '"contract": "docs/api/openapi.yaml"' .team/team.json
contains 'cd back' .team/team.json
python3 - <<'P'
import json
d = json.load(open(".team/team.json")); d["project"]["tools"] = ["claude", "codex"]
json.dump(d, open(".team/team.json", "w"), ensure_ascii=False, indent=2)
P
expect 0 scaffold --overwrite CLAUDE.md --overwrite .claude/agents/tester.md
contains 'backend' CLAUDE.md
contains 'noreply' AGENTS.md                     # the commit rule reaches other tools
contains 'name = "backend"' .codex/agents/backend.toml
python3 - <<'P' || { echo "FAIL: invalid Codex TOML"; failures=$((failures+1)); }
import glob, tomllib
for f in glob.glob(".codex/agents/*.toml"):
    d = tomllib.load(open(f, "rb"))
    assert d["name"] and d["description"] and d["developer_instructions"], f
    assert "<!--" not in d["developer_instructions"] and "model" not in d, f
P
expect 0 doctor
git add -A; git commit -qm team
expect 0 start h
printf -- '- Status: d\n- AC-1: a\n' > docs/specs/h.md
expect 0 approve h --quote go
python3 "$E" preflight h | grep -q '"mode": "worktree"' || { echo "FAIL: worktree mode expected"; failures=$((failures+1)); }
git worktree add -q -b before ../wt-before HEAD  # starts before the next commit
git add -A; git commit -qm spec
expect 0 advance h development
head=$(git rev-parse HEAD)
git worktree add -q -b wt-front ../wt-front HEAD
echo 1 > ../wt-front/front/x.js                  # the work stays uncommitted
expect 0 scope-check frontend --worktree ../wt-front
python3 "$E" scope-check frontend --worktree ../wt-before | grep -q diverged_base || { echo "FAIL: diverged base not seen"; failures=$((failures+1)); }
expect 2 apply frontend --worktree ../wt-before
git worktree add -q -b wt-bad ../wt-bad HEAD
echo 1 > ../wt-bad/back/y.js
expect 2 scope-check frontend --worktree ../wt-bad
expect 2 apply frontend --worktree ../wt-bad
[ ! -e back/y.js ] || { echo "FAIL: out-of-scope work applied"; failures=$((failures+1)); }
expect 0 apply frontend --worktree ../wt-front
[ -e front/x.js ] || { echo "FAIL: work not carried over"; failures=$((failures+1)); }
[ "$(git rev-parse HEAD)" = "$head" ] || { echo "FAIL: a commit was created"; failures=$((failures+1)); }
expect 0 advance h integration
for i in 1 2 3; do expect 0 round h; expect 0 advance h integration; done
expect 3 round h                                 # fourth round refused
expect 0 stop h --reason test

# --- stack choice on an empty project
mkdir -p "$T/empty"; cd "$T/empty"; git init -q -b main; git commit -q --allow-empty -m init
expect 2 propose front:cobol
python3 "$E" propose front | grep -q 'front:next' || { echo "FAIL: stack choices not offered"; failures=$((failures+1)); }
expect 0 propose front:next test --write
contains '"specialty": "Next.js"' .team/team.json

# --- PHP: detection wins over the assets' package.json, and all stacks can be chosen
mkdir -p "$T/lara"; cd "$T/lara"; git init -q -b main
echo '{"require":{"laravel/framework":"^11"}}' > composer.json; touch artisan
echo '{"name":"a","devDependencies":{"vue":"3","vite":"5"}}' > package.json
expect 0 propose back --write
contains '"specialty": "PHP / Laravel"' .team/team.json
contains 'php artisan test' .team/team.json
python3 "$E" propose front | grep -q 'OVERLAPPING_SCOPES' || { echo "FAIL: Laravel + Vue overlap not reported"; failures=$((failures+1)); }
mkdir -p "$T/sym"; cd "$T/sym"; git init -q -b main
echo '{"require":{"symfony/framework-bundle":"^7"}}' > composer.json
expect 0 propose back --write
contains '"specialty": "PHP / Symfony"' .team/team.json
mkdir -p "$T/plain"; cd "$T/plain"; git init -q -b main
echo '{"require":{"php":"^8.3"}}' > composer.json
expect 0 propose back --write
contains '"specialty": "PHP"' .team/team.json
contains 'vendor/bin/phpunit' .team/team.json
mkdir -p "$T/newphp"; cd "$T/newphp"; git init -q -b main
expect 0 propose back:symfony --write
contains '"specialty": "PHP / Symfony"' .team/team.json
expect 0 scaffold
contains 'Doctrine migrations' .claude/agents/backend.md

# --- design agent: gates, brief lock, anti-generic check
mkdir -p "$T/ui/src" "$T/ui/tests"; cd "$T/ui"; git init -q -b main
echo '{"name":"ui","scripts":{"test":"node -e 0"},"dependencies":{"next":"15"}}' > package.json
echo 'export const a = 1' > src/a.js
git add -A; git commit -qm init
expect 0 propose front design test --write
expect 0 scaffold
contains 'name: design' .claude/agents/design.md
if grep -q '^tools:' .claude/agents/design.md; then echo "FAIL: design must inherit browser tools"; failures=$((failures+1)); fi
if grep -rl $'—' .claude/agents CLAUDE.md; then echo "FAIL: em dash in generated files"; failures=$((failures+1)); fi
expect 0 start p
mkdir -p docs/specs docs/design; printf -- '- Status: d\n- AC-1: a\n' > docs/specs/p.md
expect 0 approve p --quote go
expect 2 advance p development                   # design pending
expect 0 advance p design
expect 2 approve-design p --quote go             # no brief
printf '# Brief\n## References\nnone\n' > docs/design/p.md
expect 2 approve-design p --quote go             # no consulted reference
printf '# Brief\n## References\n- https://www.awwwards.com/x: rhythm\n' > docs/design/p.md
expect 0 approve-design p --quote go
expect 0 advance p development
echo 'export const t = "Fast — simple"' > src/dash.js
printf 'body { font-family: "Inter", sans-serif; }\n' > src/a.css
printf 'import { Inter } from "next/font/google"\n' > src/font.js
printf 'body { font-family: "Canela", Arial, sans-serif; }\n' > src/ok.css
printf 'import { Sparkles } from "lucide-react"\n' > src/icon.js
printf 'console.log("done \xe2\x9c\xa8")\n' > src/emoji.js
printf '# ok \xf0\x9f\x9a\x80\n' > src/worker.py
printf 'export const stars = "Stars are bright"\nimport { Star } from "lucide-react"\n' > src/fine.js
expect 0 scope-check frontend --feature p
expect 0 advance p integration
expect 0 verify p --all
expect 0 advance p review
python3 "$E" design-check --feature p > "$T/check.json"; c=$?
[ "$c" = 2 ] || { echo "FAIL: design-check should block ($c)"; failures=$((failures+1)); }
python3 - "$T/check.json" <<'P' || { echo "FAIL: wrong design-check findings"; failures=$((failures+1)); }
import json, sys
f = json.load(open(sys.argv[1]))["findings"]
assert sorted({(x["rule"], x["file"]) for x in f}) == [("ai-icon", "src/icon.js"), ("em-dash", "src/dash.js"), ("emoji", "src/emoji.js"), ("emoji", "src/worker.py"), ("generic-font", "src/a.css"), ("generic-font", "src/font.js")], f
P
expect 2 advance p done                          # design check failed
rm src/dash.js src/a.css src/font.js src/icon.js src/emoji.js src/worker.py
expect 0 verify p --all
expect 0 design-check --feature p
expect 0 advance p done
python3 - <<'P'
import json
d = json.load(open(".team/team.json")); d["project"]["design"] = {"allowed_fonts": ["Inter"]}
json.dump(d, open(".team/team.json", "w"), ensure_ascii=False, indent=2)
P
printf 'body { font-family: Inter; }\n' > src/pinned.css
expect 0 design-check                            # a pinned font is allowed

# --- auto mode: only with the user's words, and every check stays
expect 2 approve q0 --auto                       # unknown feature
expect 0 start r
printf -- '- Status: d\n- AC-1: a\n' > docs/specs/r.md
expect 2 approve r --auto                        # not started in auto mode
expect 2 approve r                               # no quote
expect 2 start a1 --auto                         # auto needs the user's words
expect 0 start a1 --auto --quote "ship --auto, don't ask me"
expect 2 approve a1 --auto                       # the spec is still required
printf -- '- Status: d\n- AC-1: a\n' > docs/specs/a1.md
expect 0 approve a1 --auto
contains "ship --auto, don't ask me" .team/features/a1.json
expect 2 advance a1 development                  # design still pending
expect 0 advance a1 design
printf '# Brief\n## References\nnone\n' > docs/design/a1.md
expect 2 approve-design a1 --auto                # references still required
printf '# Brief\n## References\n- https://www.awwwards.com/y: space\n' > docs/design/a1.md
expect 0 approve-design a1 --auto
expect 0 advance a1 development
expect 0 note a1 "Chose light over dark"
contains 'Chose light over dark' .team/features/a1.json
expect 0 advance a1 integration
expect 2 advance a1 review                       # verifications still required
expect 0 leftovers

# --- scope: design documents are protected, and blame does not carry over
python3 - <<'P' || { echo "FAIL: generated scope text"; failures=$((failures+1)); }
assert "only in the project, except" in open(".claude/agents/frontend.md").read()
P
echo tampered >> docs/design/a1.md
expect 2 scope-check frontend --feature a1       # a developer touched the brief
expect 0 scope-check tester --feature a1         # and the tester is not blamed for it
echo 'test' > tests/x.test.js
expect 0 scope-check tester --feature a1
echo tampered2 >> docs/design/a1.md
expect 2 scope-check design --feature a1         # the brief is locked even for its author
echo 'review' > docs/design/review.md
expect 0 scope-check design --feature a1         # other design notes are fine
echo 'export const lead = 1' > src/lead.js
expect 0 lead-change a1 --reason "restored a file"
expect 0 scope-check tester --feature a1         # the lead's own change is not an incident

# --- no interface: the design phase can be skipped, with a reason
expect 0 start q
printf -- '- Status: d\n- AC-1: a\n' > docs/specs/q.md
expect 0 approve q --quote go
expect 0 advance q development --no-interface "background job"

# --- no team, home folder
cd "$T"; expect 2 scaffold
HOME="$T/app" bash -c "cd '$T/app' && rm -rf .team && python3 '$E' context" | grep -q NOT_A_PROJECT || { echo "FAIL: home folder not detected"; failures=$((failures+1)); }

# --- the README promises no network and no environment variable: keep it true
if ! python3 -I - "$E" <<'PY'
import ast, sys
tree = ast.parse(open(sys.argv[1], encoding="utf-8").read())
NETWORK = {"socket", "ssl", "urllib", "urllib3", "http", "requests", "httpx", "aiohttp",
           "ftplib", "smtplib", "poplib", "imaplib", "telnetlib", "xmlrpc", "asyncio", "webbrowser"}
ENV = {"environ", "environb", "getenv", "getenvb", "putenv", "unsetenv"}
bad = []
for n in ast.walk(tree):
    if isinstance(n, ast.Import):
        bad += [f"line {n.lineno}: import {a.name}" for a in n.names if a.name.split(".")[0] in NETWORK | {"importlib"}]
    elif isinstance(n, ast.ImportFrom):
        if (n.module or "").split(".")[0] in NETWORK | {"importlib"}:
            bad.append(f"line {n.lineno}: from {n.module} import")
        bad += [f"line {n.lineno}: from {n.module} import {a.name}" for a in n.names if a.name in ENV]
    elif isinstance(n, ast.Attribute) and n.attr in ENV:
        bad.append(f"line {n.lineno}: .{n.attr}")
    elif isinstance(n, ast.Name) and n.id == "__import__":
        bad.append(f"line {n.lineno}: __import__")
for b in bad:
    print("FAIL: script", b)
sys.exit(1 if bad else 0)
PY
then failures=$((failures+1)); else echo "ok  : no network module, no environment variable"; fi

echo; [ "$failures" = 0 ] && echo "All pass." || { echo "$failures failure(s)."; exit 1; }
