# Testing Guideline Reference

## Scope

Use for testability design and deciding what to test.

## Rules

1. Prefer pure functions for business rules so they can be tested in isolation.
2. Add tests around transformation and filtering rules.
3. Test behavior, not implementation details.
4. Keep test data builders/helpers simple and local.
5. Cover edge states and unknown/default fallback paths.

## Suggested Coverage

1. Mapping rules (state -> output bucket/view model state).
2. Inclusion/exclusion behavior for filters and visibility.
3. Backward compatibility behavior that must remain stable.
4. Error/fallback behavior.
