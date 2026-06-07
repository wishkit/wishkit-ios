# Platform-Specific Folder Game Plan

## Goal

Move from mixed-platform feature files to a platform-first folder structure:
- `Sources/WishKit/iOS/...`
- `Sources/WishKit/macOS/...`
- `Sources/WishKit/Shared/...`

This removes large inline compile-flag branches from view bodies and keeps platform UI code isolated.

## Target Structure

```text
Sources/WishKit/
  iOS/
    Wishlist/
      View/
        WishlistView+iOS.swift
        WishlistFloatingAddButtonView+iOS.swift
        WishlistNavigationBarActionsView+iOS.swift
        WishlistSegmentedControlSectionView+iOS.swift
      Model/
        LocalWishState.swift            (or keep in Shared if truly shared)
        WishFiltering.swift             (or keep in Shared if truly shared)
    WishDetail/
      View/
        DetailWishView+iOS.swift
        CommentFieldView+iOS.swift      (if UI differs)
        CommentListView+iOS.swift       (if UI differs)
    CreateWish/
      View/
        CreateWishView+iOS.swift
      Model/
        CreateWishSubmitOutcome.swift   (or keep in Shared)

  macOS/
    Wishlist/
      View/
        WishlistView+macOS.swift
        WishlistContainer+macOS.swift
      Model/
        (only if macOS-specific model logic exists)
    WishDetail/
      View/
        DetailWishView+macOS.swift
    CreateWish/
      View/
        CreateWishView+macOS.swift

  Shared/
    Wishlist/
      Model/
        WishModel.swift
        WishModelAccumulator.swift
        WishModelFilteredLists.swift
        WishModelFilterBucket.swift
        WishlistViewModel.swift
    WishDetail/
      ViewModel/
        DetailWishViewModel.swift
    CreateWish/
      ViewModel/
        CreateWishViewModel.swift
      Model/
        WishValidation.swift
        WishValidationNormalizedInput.swift
        WishValidationEmailValidationResult.swift
    UI/
      WishView.swift
      AddButton.swift
      CloseButton.swift
      SeparatorView.swift
    Theme/
    Configuration/
    Service/
    Networking/
    Extensions/
```

## Decision Rule: iOS/macOS/Shared

Put a file in:
1. `iOS/` if implementation or API usage is iOS-only.
2. `macOS/` if implementation or API usage is macOS-only.
3. `Shared/` only when the file compiles unchanged for both platforms and carries no UI branching.

Rule of thumb:
- View files are usually platform folders.
- ViewModel/Model files are usually `Shared/` unless a real platform dependency exists.

## Compile-Flag Policy

Preferred:
- File-level wrapper around each platform struct.

Example:

```swift
#if os(iOS)
import SwiftUI
import WishKitShared

struct CreateWishView: View {
    // iOS implementation
}
#endif
```

Allowed:
- Router-level `#if` at one entry point.

Avoid:
- Deep inline `#if` branches inside a single `body`.
- Shared model/viewmodel files containing platform branching.

## Naming and File Rules

1. One top-level `struct` per file.
2. File name reflects platform with suffix (`+iOS`, `+macOS`).
3. Keep type names stable at usage sites (`CreateWishView`, `DetailWishView`, `WishlistView`) and rely on compile-time platform selection.
4. Keep feature boundaries mirrored across platforms (`Wishlist`, `WishDetail`, `CreateWish`).

## Migration Plan

## Phase 0: Prepare Structure

1. Create new root folders:
   - `Sources/WishKit/iOS`
   - `Sources/WishKit/macOS`
   - `Sources/WishKit/Shared`
2. Inside each platform root, create:
   - `Wishlist/View`
   - `CreateWish/View`
   - `WishDetail/View`
3. Create shared feature folders for ViewModel/Model where needed.

Exit criteria:
- Folder skeleton exists and is committed with no behavior change.

## Phase 1: Migrate CreateWish Views

Current file:
- `Sources/WishKit/Feature/CreateWish/View/CreateWishView.swift`

Steps:
1. Create:
   - `Sources/WishKit/iOS/CreateWish/View/CreateWishView+iOS.swift`
   - `Sources/WishKit/macOS/CreateWish/View/CreateWishView+macOS.swift`
2. Split logic by platform and remove inline platform checks from the implementations.
3. Keep `CreateWishViewModel` and validation files in `Shared/CreateWish/...`.
4. Remove old mixed file after both builds pass.

Exit criteria:
- `CreateWishView` compiles per platform with file-level wrappers only.

## Phase 2: Migrate WishDetail Views

Current file:
- `Sources/WishKit/Feature/WishDetail/View/DetailWishView.swift`

Steps:
1. Create:
   - `Sources/WishKit/iOS/WishDetail/View/DetailWishView+iOS.swift`
   - `Sources/WishKit/macOS/WishDetail/View/DetailWishView+macOS.swift`
2. iOS file: exclude close-button behavior.
3. macOS file: include close-button behavior directly.
4. Keep `DetailWishViewModel` in `Shared/WishDetail/ViewModel/`.
5. Remove old mixed file.

Exit criteria:
- No inline platform checks remain in `DetailWishView` body.

## Phase 3: Migrate Wishlist Views

Current files:
- `Sources/WishKit/Feature/Wishlist/View/WishlistViewIOS.swift`
- `Sources/WishKit/Feature/Wishlist/View/WishlistView.swift`
- `Sources/WishKit/Feature/Wishlist/View/WishlistContainer.swift`
- iOS-specific helper views in same feature folder.

Steps:
1. Move iOS files to:
   - `Sources/WishKit/iOS/Wishlist/View/...`
2. Move macOS files to:
   - `Sources/WishKit/macOS/Wishlist/View/...`
3. Keep shared list/filter model/viewmodel files under `Shared/Wishlist/Model/`.
4. Remove old `Feature/Wishlist/View` platform-mixed placement.

Exit criteria:
- Platform views are isolated by root folder.
- Shared model/viewmodel logic is platform-neutral.

## Phase 4: Update Public Entry Router

Current file:
- `Sources/WishKit/WishKit+FeedbackListView.swift`

Steps:
1. Keep single public entry API unchanged.
2. Update imports/type resolution only if paths changed.
3. Keep one router `#if` split at this entry boundary.

Exit criteria:
- `WishKit.FeedbackListView` API remains source-compatible.

## Phase 5: Cleanup and Delete Legacy Layout

1. Remove `Sources/WishKit/Feature/...` folders only after all moved files compile.
2. Ensure no stale references remain.
3. Optional: add a short README in `Sources/WishKit/` documenting placement rules.

Exit criteria:
- Only platform-first + shared layout remains.

## Build and Test Checklist

Per phase:
1. Build iOS.
2. Build macOS.
3. Smoke test user flows:
   - Wishlist load and refresh.
   - Open detail.
   - Create wish.
   - Vote/comment refresh behavior.

## Risks and Mitigations

Risk:
- Duplicate view code across platforms grows.
Mitigation:
- Keep duplication acceptable at view layer.
- Extract only clearly stable shared pieces into `Shared/`.

Risk:
- Type collisions from same type name in both platform trees.
Mitigation:
- Enforce file-level `#if os(iOS)` / `#if os(macOS)` wrappers in each platform view file.

Risk:
- Moving too many files at once increases regression risk.
Mitigation:
- Migrate feature-by-feature in small PRs.

## PR Sequence

1. Folder skeleton + no behavior change.
2. `CreateWish` platform split.
3. `WishDetail` platform split.
4. `Wishlist` platform split.
5. Router cleanup + legacy folder removal.

## Open Clarifications

1. Do you want to include `WishDetail` inside your platform-first structure now, or only `Wishlist` and `CreateWish` first?
2. Should we move all `Shared/UI` now, or only touch files needed by the first feature migration?
3. Do you want the old `Feature/` path deleted immediately after each phase, or in one final cleanup PR?
