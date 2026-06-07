# Architecture Guideline Reference

## Scope

Use for project layout, feature decomposition, and type placement.

## Rules

1. Prefer feature-based folders over type-based global folders.
2. Keep shared code in `Shared/` only if it is truly cross-feature.
3. Keep persistence adapters in `Store`.
4. Keep IO integrations in `Service`.
5. Keep pure transformation logic in dedicated helpers/controllers/dispatchers.
6. Keep model types as data-focused types with minimal behavior.

## File Placement

1. One enum per file.
2. One struct per file.
3. One class per file.
4. Do not declare unrelated top-level types in the same file.

## Layering

- View: rendering only
- ViewModel: UI state orchestration
- Service: side effects/IO
- Store: persistence
- Model: data representation
