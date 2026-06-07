---
name: swift-guideline
description: Unified Swift guideline router for Swift and SwiftUI work. Use when implementing or refactoring app features to select the correct references for architecture, SwiftUI structure, naming, formatting, concurrency, and testing.
---

# Swift Guideline

Use this skill as the single entry point for Swift development rules.

## Routing

- If the task is about SwiftUI views, view models, or UI folder structure: read `references/swiftui.md`.
- If the task is about project/module/layer structure: read `references/architecture.md`.
- If the task is about code style formatting: read `references/formatting.md`.
- If the task is about naming or file placement rules: read `references/naming.md`.
- If the task is about async/await, actors, isolation, Sendable, or task orchestration: read `references/concurrency.md`.
- If the task is about unit/integration test strategy or testability seams: read `references/testing.md`.

## Trigger Examples

- "Build a new SwiftUI screen with view model and clean folder structure" -> `swiftui.md` + `architecture.md`.
- "Refactor model logic into pure functions and add tests" -> `architecture.md` + `testing.md`.
- "Fix naming and formatting issues in these files" -> `naming.md` + `formatting.md`.
- "Migrate callback flow to async/await and ensure MainActor correctness" -> `concurrency.md` (+ `testing.md` if behavior changes).

## Multi-Reference Rules

1. Most feature tasks require more than one reference.
2. For any SwiftUI feature implementation, always load:
   - `references/swiftui.md`
   - `references/architecture.md`
   - `references/naming.md`
   - `references/formatting.md`
3. Add `references/concurrency.md` when async code, actors, isolation, or Sendable are involved.
4. Add `references/testing.md` when behavior changes, filtering/mapping logic changes, or bug fixes are implemented.
5. Keep loaded references minimal; do not load unrelated references.

## Global Mandatory Rules

1. Keep edits minimal and scoped to the request.
2. Prefer pure functions for transformations.
3. Avoid hidden mutations in property accessors/observers.
4. One enum per file.
5. One struct per file.
6. SwiftUI view types must be in their own files.
7. Preserve backwards compatibility unless explicitly asked to break it.
8. Add concise comments only when intent is not obvious.
9. When unsure about rule ownership, default to the most specific reference file for the task.

## Applying Rules

1. Load only the relevant reference file(s) from `references/`.
2. If rules conflict, apply this order:
   - Safety/correctness
   - Explicit user requirement
   - Global mandatory rules
   - Reference-specific conventions
3. If the task requires a deliberate exception, call it out explicitly in the response.
4. If task intent is ambiguous, default routing:
   - SwiftUI file touched: `swiftui.md` + `architecture.md` + `naming.md` + `formatting.md`
   - Non-UI Swift file touched: `architecture.md` + `naming.md` + `formatting.md`
5. Before finalizing edits, verify:
   - file placement rules were applied (`enum`/`struct`/`class` ownership),
   - naming and formatting rules were applied,
   - tests were considered when behavior changed.
