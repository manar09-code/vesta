# Contributing to Vesta

## Branches
- `main`: stable, only receives merges from `develop` at the end of a sprint.
- `develop`: integration branch. All feature PRs target `develop`.
- `feature/VST-<n>-<short-name>`: one branch per Jira ticket, e.g. `feature/VST-21-flutter-login`.
- `fix/VST-<n>-<short-name>`: bug fixes.

Always put the Jira key in the branch name, commit messages and PR title so Jira links them.

## Commits
`type(scope): message [VST-n]` — types: `feat`, `fix`, `docs`, `chore`, `test`, `refactor`.
Example: `feat(auth): add email login screen [VST-21]`

## Pull requests
1. Branch from `develop`, push, open a PR into `develop`.
2. Fill in the PR template. Assign the **reviewer** named in the Jira ticket.
3. No merge without 1 approval. No direct pushes to `main` or `develop`.
4. Keep PRs small (one ticket). Squash-merge.

## Definition of Done
- PR reviewed and merged
- Tested on a **real phone**
- Jira ticket updated and moved to Done

## Secrets
Never commit `google-services.json`, `GoogleService-Info.plist`, `.env`, keystores or API keys. If one leaks, tell Manar immediately so the key can be rotated.

## Team rhythm
Monday: 15-minute sync. Friday: demo of what is merged. Pair call when a feature is finished: explain the logic to the person who ports or reviews it.
