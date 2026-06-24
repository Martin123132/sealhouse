# Sealhouse Installation

This repository is currently optimized for source-based local development and
public-safe CI. On this workstation, all generated state should stay on D-drive.

## Windows Local Development

Use the D-drive helper scripts:

```powershell
D:\Codex\esignature\src\open-signature\tools\setup-d-drive-local-env.cmd
```

```powershell
D:\Codex\esignature\src\open-signature\tools\install-deps-d-drive.cmd
```

Then start the local services from the same D-drive checkout:

```powershell
D:\Codex\esignature\src\open-signature\tools\run-mongo-d-drive.cmd
```

```powershell
D:\Codex\esignature\src\open-signature\tools\run-server-d-drive.cmd
```

```powershell
D:\Codex\esignature\src\open-signature\tools\run-client-d-drive.cmd
```

Or start and verify the full local stack with one D-drive smoke command:

```powershell
D:\Codex\esignature\src\open-signature\tools\smoke-fullstack-d-drive.cmd
```

See [D_DRIVE_DEV.md](D_DRIVE_DEV.md) for the storage rules and expected paths.

## Environment Files

Copy one of the examples and keep the generated file private:

- `.env.example` for generic defaults.
- `.env.d-drive.example` for this D-drive development layout.

Do not commit real `.env` files, credentials, keys, certificates, uploaded
documents, or generated signing output.

## Docker

Docker support is still compatibility-first. The compose file currently uses
upstream OpenSign image names because Sealhouse has not published dedicated
container images yet.

Before using Docker with real data:

- review `docker-compose.yml`
- configure a private `.env.prod`
- use persistent MongoDB storage
- understand that the `opensign-files` volume name is a compatibility surface

For local product work on this machine, prefer the D-drive source setup until
Docker Desktop storage is confirmed to use D-drive-backed data.

## Validation

After setup, run the focused checks that match your change:

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
