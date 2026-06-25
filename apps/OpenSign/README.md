# Sealhouse Frontend

This app is the Sealhouse browser client for self-hosted document signing.

The folder name is still `apps/OpenSign` for compatibility with the inherited
workspace layout, Docker files, CI paths, and local helper scripts. Treat that
path as an internal compatibility name until it can be changed with a tested
migration.

## Useful Commands

Install dependencies from this folder:

```powershell
npm ci
```

Run the local development server:

```powershell
npm run dev
```

Build the production client using the D-drive safe wrapper from the repository
root:

```powershell
tools\build-client-d-drive.cmd
```

The build script writes generated output and temporary data under D-drive paths
for this workstation.
