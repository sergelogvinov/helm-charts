# AGENT.md

This file defines how an AI coding agent should work in this repository.

## Mission

Maintain and improve Helm charts in this monorepo with safe, minimal, and reviewable changes.

Primary goals:
- Keep charts valid and deployable.
- Preserve backward compatibility unless a breaking change is explicitly requested.

## Repository Layout

- `charts/<chart>/`: one Helm chart per directory.
- `charts/<chart>/templates/`: Kubernetes manifests.
- `charts/<chart>/values.yaml`: default values.
- `charts/<chart>/values.production.yaml`: production recommended values.
- `charts/<chart>/values.dev.yaml`: development recommended values.
- `charts/<chart>/README.md.gotmpl`: chart README template (source).
- `charts/<chart>/README.md`: generated docs from helm-docs.
- `charts/<chart>/ci/values.yaml`: CI test values for rendering checks.
- `Makefile`: canonical automation entrypoint.

## Golden Rules

1. Change only what is required for the task.
2. Do not rewrite unrelated files or reformat large sections.
3. Prefer additive, backward-compatible value changes.
4. Keep naming and style consistent with neighboring charts.

## Chart Editing Conventions

Follow existing repo conventions:
- Root-level defaults in `values.yaml`.
- Multi-component charts use per-component subtrees.
- Reuse root defaults unless component override is needed.
- Use `app.kubernetes.io/component` label for component-specific workloads.
- Keep security context, resources, and scheduling knobs configurable.

## Standard Workflow For Chart Changes

1. Identify target chart and requested behavior.
2. Edit templates and/or `values.yaml`.
3. Update docs for the chart:
   - `make docs-<chart>`
4. Validate rendering and schema compatibility:
   - `make test-<chart>`
5. If many charts changed, run full checks:
   - `make lint`
6. If behavior changed, bump chart version in `charts/<chart>/Chart.yaml`.

## Documentation Rules

- Treat `README.md` inside each chart as generated output.
- Make content changes in `README.md.gotmpl`, then regenerate via `make docs-<chart>`.
- Keep examples realistic and aligned with current values schema.

## Commit And PR Hygiene

- Keep commits focused per chart/feature when possible.
- Mention changed charts in the summary.
- Include what was validated (commands and scope).
- Call out breaking changes and migration notes explicitly.

## Non-Goals

- Do not introduce unrelated tooling changes.
- Do not modify release workflows unless requested.
- Do not silently change defaults that may impact production behavior.
