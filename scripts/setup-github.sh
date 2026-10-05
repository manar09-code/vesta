#!/usr/bin/env bash
# Usage: ./scripts/setup-github.sh <your-github-username> [public|private] [collaborator1 collaborator2 ...]
# Needs: git + GitHub CLI (gh) logged in with `gh auth login`.
# Run from the repo root.
set -euo pipefail
OWNER="${1:?usage: $0 <github-username> [public|private] [collaborators...]}"
VIS="${2:-public}"
shift $(( $# >= 2 ? 2 : $# ))
REPO="$OWNER/vesta"

gh auth status >/dev/null

[ -d .git ] || git init -b main
git add -A
git commit -m "chore: initial Vesta monorepo scaffold" || true

gh repo create "$REPO" "--$VIS" --source=. --remote=origin --push
git checkout -b develop
git push -u origin develop

# Invite teammates (GitHub usernames)
for u in "$@"; do
  gh api -X PUT "repos/$REPO/collaborators/$u" -f permission=push >/dev/null && echo "Invited $u"
done

# Protect main and develop: PR required, 1 approval, no direct push
# NOTE: on a PRIVATE repo this needs GitHub Pro/Student plan; on a public repo it is free.
for b in main develop; do
  gh api -X PUT "repos/$REPO/branches/$b/protection" --input - <<JSON >/dev/null
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null
}
JSON
  echo "Protected $b"
done
echo "Done: https://github.com/$REPO"
