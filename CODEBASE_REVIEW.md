# WishKit iOS Codebase Review (Bugs + Optimizations)

This guide is a step-by-step audit of the current codebase. Each step lists concrete findings with file references and suggested fixes. Items marked "Verify" are hypotheses that depend on how the SDK is embedded by the host app.

## Step 1: Avoid double-fetching the wishlist on macOS/visionOS

1. `Sources/WishKit/SwiftUI/macOS/WishlistContainer+macOS.swift` calls `wishModel.fetchList()` in `init`.
2. `Sources/WishKit/SwiftUI/WishlistView.swift` also fetches in `onAppear`.
   - Result: on macOS/visionOS, the first render can trigger two back-to-back network calls.
   - Suggested fix: remove one of the fetches (prefer `onAppear` in the view to avoid side effects in `init`).

## Step 2: Reconcile voting rules with state model

1. `Sources/WishKit/SwiftUI/WishView.swift` blocks voting only for `.implemented`, but the data model also uses `.completed`.
   - Risk: users might be allowed to vote on completed items if the backend uses `.completed` as the terminal state.
   - Suggested fix: treat `.completed` the same as `.implemented` when blocking votes.
2. `Sources/WishKit/SwiftUI/WishView.swift` uses `WishKit.config.allowUndoVote` but always sends the same `VoteWishRequest`.
   - Verify: if the backend expects a separate "remove vote" or "toggle vote" request, undo will not work as intended.
   - Suggested fix: confirm backend semantics and add a dedicated undo endpoint or flag if required.

## Step 3: Ensure navigation works when the SDK is presented standalone

1. `Sources/WishKit/WishKit.swift` exposes `public static var viewController` and `FeedbackListView`, both of which embed `WishlistViewIOS` directly.
2. `Sources/WishKit/SwiftUI/iOS+Catalyst/WishlistView+iOS.swift` relies on `NavigationLink` and `navigationTitle`.
   - Verify: if the host app presents `viewController` or `FeedbackListView` without wrapping it in a `NavigationView`, navigation to `DetailWishView` won’t push.
   - Suggested fix: wrap `WishlistViewIOS` in `.withNavigation()` inside `WishKit.viewController` and `FeedbackListView` (or document that the host must wrap it).

## Step 4: Tighten error handling in request building and responses

1. `Sources/WishKit/API/RequestCreatable.swift` silently ignores JSON encoding failures (`try? JSONEncoder().encode`).
   - Risk: requests can be sent with a nil body without surfacing the root cause.
   - Suggested fix: return a `Result`/optional or throw on encoding errors so callers can fail fast.
2. `Sources/WishKit/API/Api.swift` ignores HTTP status codes and tries to decode the response as success first.
   - Risk: non-2xx responses that still return JSON could be misinterpreted.
   - Suggested fix: check `HTTPURLResponse.statusCode` and decode accordingly.

## Step 5: Performance optimizations worth capturing

1. `Sources/WishKit/Extensions/Date+Formatted.swift` creates a new `DateFormatter` on every call.
   - Suggested fix: cache a static `DateFormatter` to avoid repeated allocations.
2. `Sources/WishKit/SwiftUI/WishModel.swift` repeatedly sorts and filters arrays, then sorts the merged array again.
   - Suggested fix: avoid the second sort by building `all` from the already-sorted list, or reuse the sorted list when composing `all`.
3. `Sources/WishKit/SwiftUI/iOS+Catalyst/WishlistView+iOS.swift` calls `getList()` multiple times in `body`.
   - Suggested fix: compute once per render with `let list = getList()` to reduce duplicate work.
