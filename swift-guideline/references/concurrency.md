# Concurrency Guideline Reference

## Scope

Use for async/await, Task usage, actors, Sendable, and isolation boundaries.

## Rules

1. Prefer structured concurrency over detached/unstructured tasks.
2. Keep actor isolation explicit.
3. Mark UI state changes with `@MainActor` where required.
4. Keep async workflows cancellation-aware.
5. Avoid data races by design, not by patching symptoms.
6. Use `Sendable` where crossing concurrency domains.

## Practical Guidance

1. Keep async side effects in service/model layers rather than SwiftUI views.
2. Keep pure mapping/transformation logic synchronous and testable where possible.
3. Prefer explicit task ownership and lifecycle control.
