# Sealhouse UI Identity Plan

This plan captures the next safe rebrand work for the Sealhouse interface. The
goal is to make the product feel like Sealhouse in the browser while preserving
the working signing flow, CI smoke tests, and public-safe development posture.

## Current State

- Browser metadata is Sealhouse-facing: `apps/OpenSign/index.html`,
  `apps/OpenSign/public/manifest.json`, and the public API docs use the product
  name and self-hosted description.
- The shipped locales have a first-pass Sealhouse cleanup for visible plan
  labels, and the English locale also has cleanup for paid-plan, billing,
  credit, and subscription copy. The locale keys remain stable to avoid
  breaking component wiring.
- Default visible assets now include Sealhouse favicon, manifest icons, and a
  dark-mode logo fallback while preserving existing asset filenames and import
  paths.
- Many runtime defaults now resolve to `Sealhouse`, including headers, reports,
  login/setup pages, menus, and mail template samples.
- Internal implementation names still carry OpenSign wording. Examples include
  theme IDs such as `opensigncss` and `opensigndark`, the default app id
  `opensign`, `Opensigndrive` component and style names, locale keys such as
  `opensign-setup`, and comments like `isOpenSignPad`.
- The visible UI still has secondary inherited images to audit, especially
  login and document illustrations. The default logo, dark logo, favicon,
  manifest icons, and certificate logo are now Sealhouse-owned placeholders.
- Locales are partly reworded to Sealhouse, but some keys still describe old
  commercial concepts such as credits, plans, billing, and subscriptions.

## Guardrails

- Keep project files, generated output, test databases, logs, caches, uploads,
  and temporary artifacts under D-drive project paths.
- Do not include real customer documents, signatures, credentials, internal
  URLs, or private business logic in examples, tests, screenshots, commits, or
  CI artifacts.
- Do not rename internal routes, folders, CSS theme IDs, Parse classes, or
  persisted values until the affected tests and migration path are clear.
- Keep this work scoped to identity and presentation unless a functional change
  is required to keep the signing flow working.
- Preserve the existing direct Vite production build and signing-flow smoke as
  the primary verification gates.

## Product Direction

Sealhouse should feel like a practical self-hosted signing tool: calm, private,
and work-focused. The UI should avoid SaaS upsell language, remove references to
subscription credits where they do not apply, and prioritize clear document
actions: upload, prepare, send, sign, verify, and archive.

Recommended visual direction:

- Logo: simple seal/house mark that works at favicon, sidebar, and email sizes.
- Palette: restrained neutral surfaces with one confident action color; avoid
  one-note purple, beige, or dark-blue themes.
- Typography: tighter application-scale headings, not marketing hero scale.
- Navigation: document-first labels, predictable admin/settings grouping, and
  signer-facing screens with minimal distraction.
- States: clear empty, loading, failed-send, declined, signed, and completed
  states using fake-data examples only.

## Bounded Implementation Slices

1. Public string cleanup

   Extend the English pass into any remaining login/setup, dashboard navigation,
   signer flow, API docs, and email-template surfaces. Then audit non-English
   locales for visible OpenSign remnants and subscription-platform copy. Keep
   locale keys unchanged where changing keys would create churn.

2. Sealhouse asset pass

   Replace the remaining email logo fallback and audit any secondary images that
   still feel inherited. The default logo, dark logo, favicon, and manifest
   icons now have Sealhouse-owned placeholder assets. Keep file names stable
   when that avoids import churn.

3. Theme token pass

   Introduce Sealhouse color tokens behind the current `opensigncss` and
   `opensigndark` theme IDs. Rename the theme IDs only after a separate
   compatibility pass proves no persisted user setting or CSS selector breaks.

4. First-run and signer experience

   Polish the admin setup route, login, guest signing, placeholder placement,
   document completion, and verification surfaces. These are the highest-value
   places where the fork currently still feels inherited rather than owned.

5. Commercial-copy removal

   Continue removing or softening credit, billing, plan, subscription, and quota
   language from public self-hosted flows. Where a limit is still technically
   enforced, explain it as an instance policy controlled by the administrator.

6. Internal rename pass

   Only after the UI is stable, rename internal `OpenSign`/`opensign` folders,
   components, CSS files, theme IDs, and comments in small PRs with focused
   tests. Treat persisted identifiers and API compatibility as migration work,
   not cosmetic cleanup.

## Verification

For any code-bearing UI identity slice, run:

- Frontend production build through the D-drive build path.
- Server syntax/dependency checks if backend templates or public docs changed.
- Signing-flow smoke when signing, template, storage, or route behavior changes.
- GitHub Actions only after the change is public-safe and intentionally pushed.

For documentation-only changes, a clean `git status` review is enough.
