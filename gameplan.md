# v5.0 — Remaining work

iOS QA issues found walking the build. Address one at a time, each its own commit.

### Phase 10 — Comment field jumps height on focus

`Shared/View/CommentFieldView.swift`. The field is a `.plain` `TextField` in a `ZStack` with the send button overlaid; its height shifts when focused. Likely the ZStack height flip-flops between the text field's intrinsic height and the `.title2` send icon's height.

**Fix:** pin the row to a fixed height so focus can't reflow it. Set an explicit `.frame(height:)` (≈44) on the field/ZStack. Restructuring the overlay `ZStack` into a clean `HStack [TextField, sendButton]` is the more robust option if the fixed height alone doesn't settle it — fallback.

### Phase 11 — Segmented control centers vertically while loading

`iOS/Wishlist/View/WishlistView+iOS.swift`. The inner `VStack(spacing: 0)` (segmented control + list) doesn't fill the ZStack's height, so with an empty list it gets vertically centered. It should stay pinned to the top.

**Fix:** `.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)` on the `VStack`. Keep the centered `ProgressView`/empty-state `Text` as-is.

### Phase 12 — Native skeleton loading in the list

Replace the centered `ProgressView` (shown while `isLoading && !hasFetched`) with a native skeleton: a few placeholder rows using `.redacted(reason: .placeholder)`.

**Approach:** a dedicated lightweight `WishlistSkeletonView` (a handful of redacted rows built from plain `Text`/shapes) rather than reusing `WishView` — avoids constructing fake `WishResponse` values. `.redacted(reason: .placeholder)` is the native skeleton; no third-party shimmer needed (a shimmer overlay could be added later as a custom modifier if desired).

---

## Not in this file's scope (owner: you)

- Manual simulator walk-through on iOS: list → segmented filter → toolbar `+` → Form create → submit → vote → comment, in light + dark mode.
