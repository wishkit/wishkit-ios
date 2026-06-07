# Formatting Guideline Reference

## Scope

Use for whitespace, wrapping, and readability formatting decisions.

## Rules

1. Prefer multi-line argument formatting for long calls.
2. Use `guard` to reduce nesting when it improves clarity.
3. Keep functions short and intention-revealing.
4. Keep comments concise and purpose-driven.
5. Avoid alignment games that are hard to maintain in diffs.
6. Keep line breaks stable and predictable.

## Enums

Insert a blank line between enum cases.

Example:

```swift
enum Example {

    case first

    case second
}
```
