# D-Drive Development Notes

This fork is being worked under `D:\Codex\esignature\src\open-signature`.

Do not run installs, database services, browser downloads, uploads, generated PDFs, or temporary-file workflows from C.

## Environment

From a terminal, activate the project-level D-drive environment:

```bat
D:\Codex\esignature\tools\use-d-drive-env.cmd
```

PowerShell script execution is restricted on this machine, so prefer the `.cmd` launcher.

## Local Config

Use `.env.d-drive.example` as the local template. Because the frontend and backend load `.env` from their own working directories, run:

```bat
D:\Codex\esignature\src\open-signature\tools\setup-d-drive-local-env.cmd
```

This writes ignored local env files to:

```text
D:\Codex\esignature\src\open-signature\apps\OpenSign\.env
D:\Codex\esignature\src\open-signature\apps\OpenSignServer\.env
```

## Storage

Sealhouse's local Parse file adapter writes to a `files` folder relative to the server process. For local development, run the server from:

```text
D:\Codex\esignature\src\open-signature\apps\OpenSignServer
```

That keeps uploaded and generated document files under the D-drive repository.

## Database

Avoid Docker until Docker Desktop is confirmed to store images and volumes on D.

For first local boot, prefer a local MongoDB service configured with a D-drive dbpath, for example:

```bat
D:\Codex\esignature\src\open-signature\tools\run-mongo-d-drive.cmd
```

The corresponding local URI is:

```text
mongodb://127.0.0.1:27017/SealhouseDB
```

## First Fork Tasks

1. Remove hosted-service defaults from local developer configs.
2. Replace Sealhouse product naming in fork-visible UI with neutral project naming.
3. Remove subscription, premium credit, quota, and upgrade paths from self-hosted UI.
4. Replace or relicense-audit `apps\OpenSignServer\cloud\customRoute`.
5. Add a repeatable no-Docker local boot path for Windows with all state on D.

## No-Docker Boot Path

Install dependencies first when needed:

```bat
D:\Codex\esignature\src\open-signature\tools\install-deps-d-drive.cmd
```

Run these in separate terminals:

```bat
D:\Codex\esignature\src\open-signature\tools\run-mongo-d-drive.cmd
D:\Codex\esignature\src\open-signature\tools\run-server-d-drive.cmd
D:\Codex\esignature\src\open-signature\tools\run-client-d-drive.cmd
```

## Production Frontend Build

The frontend `npm run build` script is local-only in this fork. It writes
`apps\OpenSign\public\version.txt` from the local package version and builds
with D-drive temp/cache settings. The wrapper currently disables Vite
minification because the default Vite/Rolldown minifier can hang on this
workspace; the generated static app is still production-build output, but
larger than a minified bundle.

```bat
D:\Codex\esignature\src\open-signature\tools\build-client-d-drive.cmd
```
