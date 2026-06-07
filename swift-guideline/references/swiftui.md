# SwiftUI Guideline Reference

## Scope

Use for SwiftUI view code, view model boundaries, and UI-specific structure.

## Rules

1. Each SwiftUI view type must be declared in its own file.
2. Keep views declarative and UI-focused.
3. Move non-trivial transformation logic out of views into pure helpers or model/view-model methods.
4. Avoid side effects in view body/computed UI properties.
5. Prefer direct bindings over pass-through `Binding(get:set:)`.
6. Use `Binding(get:set:)` only when setter includes meaningful behavior.
7. Keep view state transitions explicit and easy to trace.

## Suggested Folders

- `Feature/View`
- `Feature/ViewModel`
- `Feature/Model`
- `Shared/View` (only when truly cross-feature)

## Notes

- View-level helper methods are acceptable for small derived values.
- Extract large reusable UI into standalone view files.
