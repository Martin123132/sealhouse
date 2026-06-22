# Sealhouse Development

Sealhouse is currently staged as a private GitHub repository while the fork is cleaned up for public release. Treat `main` as the release branch, `develop` as the integration branch, and short-lived feature branches as the normal place for new work.

## Branch Flow

- `main` should only receive reviewed merges.
- `develop` is the default branch for integrating the next product slice.
- Use branches like `codex/signing-smoke-flow` or `feature/template-editor-polish` for focused work.
- Prefer merge commits when moving work into `main` so public history keeps the context of each branch.

## D-Drive First Run

Run local setup from the D-drive checkout:

```bat
D:\Codex\esignature\src\open-signature\tools\setup-d-drive-local-env.cmd
D:\Codex\esignature\src\open-signature\tools\install-deps-d-drive.cmd
```

Then start the local services in separate terminals:

```bat
D:\Codex\esignature\src\open-signature\tools\run-mongo-d-drive.cmd
D:\Codex\esignature\src\open-signature\tools\run-server-d-drive.cmd
D:\Codex\esignature\src\open-signature\tools\run-client-d-drive.cmd
```

The helper scripts keep caches, temp output, Mongo data, uploads, generated PDFs, and local env files under D-drive project paths. Do not commit generated `.env` files, signing certificates, uploaded documents, or local build output.

## Build Checks

Frontend production build:

```bat
D:\Codex\esignature\src\open-signature\tools\build-client-d-drive.cmd
```

Server check:

```bat
cd /d D:\Codex\esignature\src\open-signature\apps\OpenSignServer
npm.cmd ci
node --check index.js
```

GitHub Actions runs both checks on Windows so the CI path matches the local D-drive assumptions as closely as possible.

## Privacy And Publication

Keep the GitHub repository private until the public proof repo is ready. Before switching visibility, re-check the repository for credentials, private certificates, generated documents, hosted-service defaults, and inherited upstream publishing workflows.
