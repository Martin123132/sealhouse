# Contributing To Sealhouse

Thanks for helping make Sealhouse a practical self-hosted signing app.

Sealhouse is public, so contributions must be safe to publish. Use synthetic
data, keep changes small, and target `develop` unless a maintainer explicitly
asks for another branch.

## Branch Workflow

- `main` is the protected release branch.
- `develop` is the integration branch.
- Feature branches should use a short descriptive name such as
  `codex/docs-identity-cleanup`.
- Pull requests should target `develop`.

## Public-Safety Rules

Do not commit:

- real customer documents, signatures, names, emails, or contact data
- credentials, tokens, API keys, or private URLs
- `.env` files
- signing certificates or private keys
- generated PDFs, uploads, exports, screenshots, logs, cache folders, MongoDB
  data, or build output

Use generated test identities and synthetic PDFs for tests and examples.

## D-Drive Development Rule

On this workstation, keep generated state under:

```text
D:\Codex\esignature\src\open-signature
```

Use the helper scripts in `tools/` where possible. They are designed to keep
dependencies, caches, temp output, Mongo data, uploads, and build artifacts away
from the small C drive.

## Before Opening A Pull Request

Run the checks relevant to your change:

```powershell
tools\build-client-d-drive.cmd
```

```powershell
cd apps\OpenSignServer
node --check index.js
```

```powershell
npm run test:smoke
```

For docs-only changes, at minimum run:

```powershell
git diff --check
```

## Pull Request Notes

In the PR description, include:

- changed files
- user-facing impact
- validation commands and results
- any remaining compatibility surfaces or follow-up work

Keep internal compatibility names in place unless the PR includes tests and a
clear migration note. Examples include old Docker image names, CSS theme IDs,
routes, Parse class names, and persisted app identifiers.

## License

By contributing, you agree that your contribution will be licensed under the
AGPL-3.0 license used by this repository.
