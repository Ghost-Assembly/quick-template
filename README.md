# Quick extension tooling

[![CI](https://github.com/Ghost-Assembly/quick-template/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Ghost-Assembly/quick-template/actions/workflows/ci.yml)
[![Security](https://github.com/Ghost-Assembly/quick-template/actions/workflows/security.yml/badge.svg?branch=main)](https://github.com/Ghost-Assembly/quick-template/actions/workflows/security.yml)
[![License](https://img.shields.io/github/license/Ghost-Assembly/quick-template)](LICENSE)
[![Release](https://img.shields.io/github/v/release/Ghost-Assembly/quick-template)](https://github.com/Ghost-Assembly/quick-template/releases/latest)
[![Sonar](https://github.com/Ghost-Assembly/quick-template/actions/workflows/sonar.yml/badge.svg?branch=main)](https://github.com/Ghost-Assembly/quick-template/actions/workflows/sonar.yml)
[![Security issues](https://sonarcloud.io/api/project_badges/measure?project=Ghost-Assembly_quick-template&metric=software_quality_security_issues)](https://sonarcloud.io/summary/new_code?id=Ghost-Assembly_quick-template)
[![Reliability issues](https://sonarcloud.io/api/project_badges/measure?project=Ghost-Assembly_quick-template&metric=software_quality_reliability_issues)](https://sonarcloud.io/summary/new_code?id=Ghost-Assembly_quick-template)
[![Maintainability issues](https://sonarcloud.io/api/project_badges/measure?project=Ghost-Assembly_quick-template&metric=software_quality_maintainability_issues)](https://sonarcloud.io/summary/new_code?id=Ghost-Assembly_quick-template)
[![Duplicated lines](https://sonarcloud.io/api/project_badges/measure?project=Ghost-Assembly_quick-template&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=Ghost-Assembly_quick-template)

Canonical development tooling, GitHub workflows, packaging, security checks, and
shared documentation for QuickClip, QuickMusic, QuickRem, QuickSpot, QuickTiler,
and QuickTS. This repository has no public documentation site.

The `template/` directory is the managed payload. Every extension records a full
commit SHA in `quick-template.lock.json`. `just template-check` compares each
managed file with that immutable GitHub archive, including its npm lockfile.
Project identity is the only substitution in npm metadata. A local checksum
manifest cannot approve changes to canonical files.

Project differences belong in `quick-project.json`, `project.just`,
`docs/project.json`, the Vitest aliases, and documentation outside the marked
generated regions. The shared instructions cover installation, uninstallation,
testing, packaging, releasing, and development. README badges show live CI,
security, documentation, release, license, GNOME compatibility, and Sonar metrics.

## Development

Activate mise, then run:

```sh
mise install
mise exec -- just setup
mise exec -- just ci
```

Change shared files in `template/`. Tool versions originate in `mise.toml` and npm
dependencies in the root `package.json` and `package-lock.json`. After a dependency
change, run `just build` to synchronize that metadata into the payload. Dependabot
updates are centralized here; keep CodeQL initialization and analysis on the same
commit.

The workflow linter adapts GitHub's July 2026 `$/` self references to the equivalent
`./` syntax for actionlint 1.7.12's parser. It preserves all other content and every
diagnostic. Zizmor checks the original files without this adaptation.

Lint rejects inline ESLint configuration and scans through Ruff `noqa` comments.
Zizmor runs its auditor persona without honoring ignore comments or configuration.
Fix findings in the canonical source before approving a tooling revision.

The secret scanner recognizes QuickTiler's historical public Sonar project ID
only in its exact `sonar.projectKey` match and exact properties file. All default
credential rules remain active. Regression fixtures verify that credentials,
other values, other paths, and credentials appended on the same line still fail.

## Adopting an approved revision

Publish an approved template release targeting its full commit SHA. In each
extension checkout, run:

```sh
just template-sync FULL_COMMIT_SHA
npm ci --ignore-scripts
just docs-generate
just ci
```

Commit the synchronized files and lock. The weekly freshness workflow reports a
newer approved release; it never silently updates a consumer. For local template
development, `QUICK_TEMPLATE_SOURCE` may point to this checkout. CI rejects that
override and downloads canonical files from GitHub.

## Required checks

Every extension runs the same local verification and security scanners, CodeQL
JavaScript and Python analysis, and Sonar analysis using its GitHub `SONAR_TOKEN`.
The required `ci` check fails if any job fails or skips. Sonar results must match
the checked PR or main branch and commit, with zero security, reliability, maintainability,
and security-hotspot counts, zero duplicated lines, and no dismissed findings.
Coverage includes untested runtime JavaScript; it is not inflated by excluding
first-party source.

This repository also requires authenticated Sonar analysis through its own
`SONAR_TOKEN` and the same exact-revision, zero-issues policy. Its scanner treats
the payload's tooling tests as tests; extension coverage belongs to consumers.

The Sonar Free plan supports PR analysis targeting main and overall-code analysis
on main. Before merging, the policy checks the PR's changed code; after merging
and on scheduled runs, it checks the entire main branch. Both require the exact
analyzed revision, complete zero-issue and duplication metrics, and no dismissed
findings. A green PR check does not establish that all existing main-branch issues
are fixed. Main CI and deployment remain blocked until overall findings reach zero.
Manual overall-code scans must be dispatched on main.

Ubuntu CI installs `librsvg2-common` explicitly because the SVG decoder is optional
when installing GNOME tools without recommended packages. Icon checks must decode
the shipped SVGs rather than skip them when a runner lacks a loader.

Pages deploys the tested documentation artifact only after required checks pass
on main. Releases promote the ZIP from successful CI for the exact tagged commit;
they do not rebuild it. Artifacts are retained for 90 days, so release promptly or
rerun CI for an older commit before tagging. GNOME Extension Store submission and
testing on each supported GNOME version remain manual.
