# Sealhouse Development

Sealhouse is a public GitHub repository. Treat `main` as the protected release branch, `develop` as the integration branch, and short-lived feature branches as the normal place for new work.

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

Signing-flow smoke test:

```bat
cd /d D:\Codex\esignature\src\open-signature\apps\OpenSignServer
set TESTING=true&& npx.cmd jasmine --random=false
```

The smoke test generates a synthetic admin, signer, PDF, signature image, and PFX certificate at runtime. It must not use real customer documents, real signatures, production certificates, or external mail/storage services.

GitHub Actions runs the same generated-data smoke on a Windows runner. The CI job starts MongoDB with `mongodb-runner` and keeps runner metadata, downloads, logs, and temp files under the Actions temp directory.

## Privacy And Publication

The GitHub repository is public. Before pushing, re-check the repository for credentials, private certificates, generated documents, hosted-service defaults, and inherited upstream publishing workflows.

## UI Identity Lane

The current Sealhouse rebrand is mostly metadata, copy, docs, and repository posture. A deeper UI identity pass should separately revisit navigation, empty states, signer-facing screens, icons, palette, and product voice so the app feels natively Sealhouse rather than a renamed fork.
