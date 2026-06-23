# Sealhouse

Sealhouse is a self-hosted document signing app for people who want private
signature workflows without another subscription gate.

The project is public and AGPL-3.0 licensed. It is being shaped as a practical
open source alternative for uploading PDFs, placing signing fields, sending or
sharing signature requests, completing signatures, and keeping audit evidence
under the control of the instance owner.

## Current Status

- `main` is the protected release branch.
- `develop` is the integration branch for product work.
- Feature branches should target `develop`.
- CI currently checks the frontend build, server dependency/syntax loading, and
  a synthetic Mongo-backed signing-flow smoke test.
- Local development for this workstation is documented for D-drive storage so
  generated files, uploads, caches, and temporary data do not land on C.

## Features

- PDF upload and preparation for signing.
- Signature, initials, text, date, checkbox, and other field placement.
- Self-signing and multi-signer request flows.
- Signing links for manual sharing.
- Guest signer verification support.
- Document templates for repeated workflows.
- Sealhouse Drive for organizing documents.
- Audit trails and completion certificates.
- Email template customization.
- API, webhook, public-link, kiosk, and embedded-signing surfaces inherited from
  the current application stack.

## First Local Setup

For local development on this machine, start here:

- [D_DRIVE_DEV.md](D_DRIVE_DEV.md) for D-drive storage rules and helper scripts.
- [DEVELOPMENT.md](DEVELOPMENT.md) for branch workflow, checks, and the signing
  smoke test.
- [INSTALLATION.md](INSTALLATION.md) for source and Docker setup notes.

The preferred local path is source-based development using the helper scripts in
`tools/`, because those scripts keep project state under D-drive paths.

## Docker Note

`docker-compose.yml` still references upstream OpenSign image and volume names
for compatibility. Treat those names as runtime compatibility identifiers until
Sealhouse publishes dedicated container images and a migration path for existing
volumes.

Before using Docker for real data, configure persistent MongoDB storage, review
`.env.example`, copy it to a private `.env.prod`, and do not commit generated
environment files.

## Public Safety

Do not commit:

- real customer documents or signatures
- generated signing certificates or private keys
- `.env` files or credentials
- local MongoDB data
- generated PDFs, uploads, exports, screenshots, logs, or build output

Use synthetic documents and generated test identities for demos, tests, and CI.

## Validation

Useful local checks:

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

The smoke test uses generated data and disposable local state. Keep MongoDB data
and any temporary output under D-drive paths.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request. Keep work
small, public-safe, and aimed at `develop`.

## License And Attribution

Sealhouse is licensed under the AGPL-3.0 license. See [LICENSE](LICENSE).

Sealhouse began from the OpenSign codebase. Some internal names, theme IDs,
routes, Docker image references, and compatibility identifiers still retain
OpenSign wording until they can be renamed safely with tests and migration
notes.
