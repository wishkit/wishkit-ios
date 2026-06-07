# macOS Implementation - Optimization Analysis

A comprehensive code review of the macOS-specific implementation and its shared dependencies, focused on identifying bugs, incorrect SwiftUI patterns, architectural issues, and unnecessary complexity.

---

## Table of Contents

1. [Bugs](#1-bugs)
2. [Incorrect SwiftUI Patterns](#2-incorrect-swiftui-patterns)
3. [Architectural Issues](#3-architectural-issues)
4. [Unnecessary Complexity & Dead Code](#4-unnecessary-complexity--dead-code)
5. [Concurrency Issues](#5-concurrency-issues)
6. [Platform-Specific Concerns (macOS)](#6-platform-specific-concerns-macos)

---

## 1. Bugs

### 1.1 `WishModel` is recreated on every `body` evaluation — state is lost

**File:** `WishKit+FeedbackListView.swift:9-16`

```swift
public var body: some View {
    #if os(macOS)
        WishlistContainer(wishModel: WishModel())  // New instance every render
    #endif
}
```

`WishModel()` is created inline inside `body`. Since `FeedbackListView` has no `@State` or `@StateObject` holding onto this instance, **every time SwiftUI re-evaluates the body, a brand-new `WishModel` is allocated**. This means:

- The fetched wish list is silently discarded on any parent rerender.
- The `hasFetched` flag resets, showing the loading spinner again.
- Any in-flight network request from the old instance is orphaned.

**Fix:** Store the model as `@StateObject` so SwiftUI preserves it across renders:

```swift
public struct FeedbackListView: View {
    @StateObject private var wishModel = WishModel()

    public init() {}

    public var body: some View {
        #if os(macOS)
            WishlistContainer(wishModel: wishModel)
        #endif
    }
}
```

---

### 1.2 `@ObservedObject` used where `@StateObject` is required — `AlertModel` in `CreateWishView`

**File:** `CreateWishView+macOS.swift:13-14`

```swift
@ObservedObject
private var alertModel = AlertModel()
```

`@ObservedObject` does **not** own the lifecycle of the object. When used with an inline initializer (`= AlertModel()`), SwiftUI may recreate the object on every view evaluation, losing any state that was set (e.g., `showAlert = true` might be immediately reset to `false`).

This is the same bug in the shared `WishView.swift:17-18`:

```swift
@ObservedObject
private var alertModel = AlertModel()
```

**Impact:** Alerts may fail to display. After `submitAction()` sets `alertModel.showAlert = true`, a view re-evaluation could replace `alertModel` with a fresh instance where `showAlert` is `false`.

**Fix:** Change to `@StateObject` in both locations:

```swift
@StateObject
private var alertModel = AlertModel()
```

---

### 1.3 Double-fetch on appearance — `fetchList()` called in init AND `onAppear`

**File:** `WishlistContainer+macOS.swift:22-25` and `WishlistView+macOS.swift:77`

```swift
// WishlistContainer init
init(wishModel: WishModel) {
    self.wishModel = wishModel
    self.wishModel.fetchList()          // First fetch
}

// WishlistView body
.onAppear(perform: { wishModel.fetchList() })  // Second fetch
```

Two network requests fire every time the view appears. The `onAppear` one is the correct pattern; the `init` one is wrong because **SwiftUI struct initializers may run more often than you expect** (e.g., during identity evaluation).

**Fix:** Remove `self.wishModel.fetchList()` from the `WishlistContainer` init. The `onAppear` in `WishlistView` already handles it.

---

### 1.4 `getList()` in `WishlistView` duplicates filtering logic

**File:** `WishlistView+macOS.swift:22-42`

```swift
func getList() -> [WishResponse] {
    if WishKit.config.buttons.segmentedControl.display == .hide {
        return wishModel.all
    }
    switch selectedWishState {
    case .all:
        return wishModel.all
    case .library(let state):
        switch state {
        case .pending: return wishModel.pendingList
        case .approved, .inReview, .planned, .inProgress: return wishModel.approvedList
        case .completed, .implemented: return wishModel.completedList
        case .rejected: return []
        }
    }
}
```

This is a manual copy of the logic already in `WishFiltering.list(from:selectedState:segmentedControlDisplay:)` and `WishlistViewModel.list(for:)`. The `WishlistViewModel` already exposes this via its `list(for:)` method — but `WishlistView` doesn't have access to the view model (it's held by `WishlistContainer` only).

**Issue:** Two separate code paths doing the same filtering. If one is updated, the other falls out of sync silently.

**Fix:** Pass the view model down to `WishlistView`, or pass the already-filtered list from `WishlistContainer` instead of the raw `WishModel`.

---

### 1.5 `WKButton` has conflicting corner radius values

**File:** `Shared/UI/WKButton.swift:41-58`

```swift
var body: some View {
    Button(action: action) {
        if isLoading {
            ProgressView().scaleEffect(0.5)
        } else {
            Text(text)
                .frame(width: size.width, height: size.height)
                .background(color(for: style))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))  // 5pt radius
        }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: size.width, height: size.height)
    .background(color(for: style))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))  // 12pt radius
    .disabled(isLoading)
}
```

The inner label uses a 5pt corner radius, while the outer button uses 12pt. The inner clip is completely redundant (the outer clip wins visually), but the double `.background(color(for: style))` call means the background is rendered twice — once behind the text, once behind the button frame. The inner one peeks through the outer clip shape with the wrong radius.

**Fix:** Remove the inner `.background()` and `.clipShape()` from the `Text` label. Let the outer button handle styling:

```swift
var body: some View {
    Button(action: action) {
        if isLoading {
            ProgressView().scaleEffect(0.5)
        } else {
            Text(text)
                .foregroundColor(textColor)
        }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: size.width, height: size.height)
    .background(color(for: style))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .disabled(isLoading)
}
```

---

### 1.6 `AddButton` applies `.buttonStyle` twice — second one is ignored

**File:** `AddButton+macOS.swift:29-30`

```swift
.buttonStyle(.plain)
.buttonStyle(.roundButtonStyle)
```

In SwiftUI, only the **first** `buttonStyle` modifier applied takes effect. The `.roundButtonStyle` on line 30 is silently ignored. The button style that gives the pressed-state opacity effect (`RoundButtonStyle`) never actually runs.

Additionally, the inner `Image` already sets `.foregroundColor(addButtonTextColor)`, but `RoundButtonStyle` forces `.foregroundColor(.white)`, so even if it did apply, there'd be a conflict.

**Fix:** Pick one button style. Since the button has custom foreground/background handling, `.plain` is the right choice. Remove `.buttonStyle(.roundButtonStyle)`.

Also, the inner `Image` has its own `.background()` and `.clipShape(.circle)` that are duplicated by the outer button's `.background()` and `.clipShape(.circle)`. Remove the redundant inner styling:

```swift
var body: some View {
    Button(action: buttonAction) {
        Image(systemName: "plus")
            .frame(width: size.width, height: size.height)
            .foregroundColor(addButtonTextColor)
    }
    .buttonStyle(.plain)
    .frame(width: size.width, height: size.height)
    .background(WishKit.theme.primaryColor)
    .clipShape(.circle)
    .shadow(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
}
```

---

## 2. Incorrect SwiftUI Patterns

### 2.1 Deprecated `@Environment(\.presentationMode)` — use `@Environment(\.dismiss)`

**File:** `CreateWishView+macOS.swift:7-8`

```swift
@Environment(\.presentationMode)
var presentationMode
```

`presentationMode` was deprecated in favor of `dismiss` starting with macOS 12 / iOS 15. The replacement is simpler:

```swift
@Environment(\.dismiss)
private var dismiss
```

And the call site changes from `presentationMode.wrappedValue.dismiss()` to just `dismiss()`.

---

### 2.2 Side effects in `init` — `WishlistContainer` calls `fetchList()` during initialization

**File:** `WishlistContainer+macOS.swift:22-25`

```swift
init(wishModel: WishModel) {
    self.wishModel = wishModel
    self.wishModel.fetchList()
}
```

SwiftUI view struct initializers are **not** lifecycle events. They can be called multiple times during view identity evaluation without the view ever appearing on screen. Network calls should happen in `.onAppear` or `.task`, never in `init`.

**Fix:** Remove the `fetchList()` call from `init`. Rely on the existing `.onAppear` in `WishlistView`.

---

### 2.3 `ZStack` used for mutually exclusive content — use `if/else if/else` instead

**File:** `WishlistView+macOS.swift:48-107`

```swift
var body: some View {
    ZStack {
        if wishModel.isLoading && !wishModel.hasFetched {
            ProgressView()
        }
        if wishModel.hasFetched && !wishModel.isLoading && getList().isEmpty {
            Text(WishKit.config.localization.noFeatureRequests)
        }
        if getList().count > 0 {
            List(getList(), id: \.id) { ... }
        }
        if wishModel.shouldShowWatermark { ... }
        VStack { ... AddButton ... }
    }
}
```

The first three conditions are mutually exclusive (loading, empty, has data), but using `ZStack` with independent `if` blocks means:

1. SwiftUI evaluates all conditions every time (calling `getList()` three times per render).
2. Multiple child views exist in the `ZStack` simultaneously (even if visually empty).
3. The watermark and floating button are layered correctly, but they should be in an overlay, not a ZStack with the content.

**Fix:** Use `if/else` for the mutually exclusive states and `overlay` for the always-present layers:

```swift
var body: some View {
    Group {
        if wishModel.isLoading && !wishModel.hasFetched {
            ProgressView().imageScale(.small)
        } else if getList().isEmpty {
            Text(WishKit.config.localization.noFeatureRequests)
        } else {
            List(getList(), id: \.id) { wish in
                // ...
            }
        }
    }
    .overlay(alignment: .bottom) {
        if wishModel.shouldShowWatermark {
            Text("\(WishKit.config.localization.poweredBy) WishKit.io")
                .opacity(0.33)
                .padding(.bottom, 30)
        }
    }
    .overlay(alignment: .bottomTrailing) {
        if WishKit.config.buttons.addButton.location == .floating {
            AddButton(buttonAction: createWishAction)
                .padding([.bottom, .trailing], 20)
        }
    }
}
```

---

### 2.4 `NSTextView.frame` override is a global side-effect

**File:** `NSTextView+Background+macOS.swift:5-11`

```swift
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
```

This overrides `frame` on **every** `NSTextView` in the entire process — not just the ones in WishKit. Any app embedding this SDK will have all their `NSTextView` instances lose their background color.

Additionally, `didSet` on `frame` fires on every layout pass, which is far more often than needed.

**Fix:** Use a dedicated `ViewModifier` with `NSViewRepresentable` if you need to clear the TextEditor background, or use the `.scrollContentBackground(.hidden)` modifier which is already applied in `CreateWishView` via `.scrollContentBackgroundCompat(.hidden)`. If that compat modifier works on your minimum deployment target, this extension is unnecessary and should be removed.

---

### 2.5 Redundant `Spacer` logic in `DetailWishView`

**File:** `DetailWishView+macOS.swift:56-66`

```swift
if WishKit.config.commentSection == .show {
    // ... comment field, comment list ...
} else {
    Spacer()   // Line 59
}

// And then right after the VStack:
if WishKit.config.commentSection == .hide {
    Spacer()   // Line 65
}
```

Two separate `Spacer` blocks for the same condition (`.hide` is the inverse of `.show`). The second one (line 64-66) is redundant — if `.commentSection == .hide`, the `else` block on line 59 already adds a `Spacer`.

**Fix:** Remove the outer `if` block (lines 64-66):

```swift
if WishKit.config.commentSection == .show {
    SeparatorView()
    CommentFieldView(...)
    CommentListView(...)
} else {
    Spacer()
}
```

---

## 3. Architectural Issues

### 3.1 `segmentedControlView` and `noSegmentedControlView` are nearly identical

**File:** `WishlistContainer+macOS.swift:52-116`

These two computed properties differ only in:
- Whether the `Picker` is shown (but `segmentedControlView` already re-checks the `.show` condition internally on line 55).
- Different padding values (line 88: `leading: 15` vs line 115: `leading: 5`).

The body already switches on the config:
```swift
switch WishKit.config.buttons.segmentedControl.display {
case .show: segmentedControlView
case .hide: noSegmentedControlView
}
```

But inside `segmentedControlView`, the Picker is wrapped in another `if WishKit.config.buttons.segmentedControl.display == .show` check — checking the same condition twice.

**Fix:** Merge into a single computed property:

```swift
var toolbarView: some View {
    HStack {
        if WishKit.config.buttons.segmentedControl.display == .show {
            Picker("", selection: $viewModel.selectedWishState) {
                ForEach(viewModel.feedbackStateSelection, id: \.self) { state in
                    Text("\(state.description) (\(viewModel.count(for: state, wishModel: wishModel)))")
                        .tag(state)
                }
            }.frame(maxWidth: 150)
        }

        Spacer()

        Button(action: refreshList) {
            Text(isRefreshing
                 ? WishKit.config.localization.refreshing
                 : WishKit.config.localization.refresh)
        }

        if WishKit.config.buttons.addButton.location == .navigationBar {
            Button(action: { showingCreateSheet.toggle() }) {
                Text(WishKit.config.localization.addButtonInNavigationBar)
            }
            .padding(.leading, 15)
            .sheet(isPresented: $showingCreateSheet) {
                CreateWishView(
                    createActionCompletion: { wishModel.fetchList() },
                    closeAction: { showingCreateSheet = false }
                )
                .frame(minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
                .background(systemBackgroundColor)
            }
        }
    }
    .padding(15)
}
```

---

### 3.2 Color scheme resolution duplicated across every view

The exact same `switch colorScheme` pattern appears in:

- `CreateWishView+macOS.swift` (3 computed properties: `textColor`, `backgroundColor`, `fieldBackgroundColor`)
- `WishlistContainer+macOS.swift` (`systemBackgroundColor`)
- `WishlistView+macOS.swift` (`backgroundColor`)
- `DetailWishView+macOS.swift` (`backgroundColor`)
- `AddButton+macOS.swift` (`addButtonTextColor`)
- `CommentFieldView.swift` (`textColor`, `backgroundColor`)
- `WishView.swift` (`textColor`, `backgroundColor`, `arrowColor`, `voteButtonBackgroundColor`)
- `WKButton.swift` (`textColor`, `backgroundColor`)

That's **15+** separate `switch colorScheme { case .light: ... case .dark: ... }` blocks all following the same pattern.

**Fix:** Create a single utility function on the `Theme` type:

```swift
extension PrivateThemeColorScheme {
    func resolve(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: light
        case .dark: dark
        @unknown default: light
        }
    }
}
```

Then usage everywhere becomes:
```swift
var backgroundColor: Color {
    (WishKit.theme.tertiaryColor ?? PrivateTheme.systemBackgroundColor)
        .resolve(for: colorScheme)
}
```

---

### 3.3 `WishModel` is not `@MainActor` but all its mutating methods require it

**File:** `Shared/Model/WishModel.swift:14`

```swift
final class WishModel: ObservableObject {
    @Published var all: [WishResponse] = []
    // ... more @Published properties

    @MainActor
    func fetchList(completion: (() -> ())? = nil) { ... }

    @MainActor
    func fetchListAsync() async { ... }
```

The class itself isn't `@MainActor`, but its `@Published` properties are read by SwiftUI views (which run on the main actor). The `updateAllLists(with:)` method is `private` and not annotated, yet it mutates `@Published` properties.

**Fix:** Annotate the entire class with `@MainActor`:

```swift
@MainActor
final class WishModel: ObservableObject { ... }
```

---

## 4. Unnecessary Complexity & Dead Code

### 4.1 Unused `@State` in `AddButton`

**File:** `AddButton+macOS.swift:9-10`

```swift
@State
private var showingSheet = false
```

This property is never read or written anywhere in `AddButton`. The sheet presentation is handled by the parent view.

**Fix:** Remove it.

---

### 4.2 Unused `dismissAction()` method in `CreateWishView`

**File:** `CreateWishView+macOS.swift:165-167`

```swift
private func dismissAction() {
    presentationMode.wrappedValue.dismiss()
}
```

This method is only called from `makeAlert()` on successful creation (line 176). But `closeAction` is also available and is the pattern used everywhere else. Given `CreateWishView` is always presented as a sheet with a `closeAction` callback, `presentationMode.dismiss()` and `closeAction()` could conflict or the behavior could be inconsistent depending on how the view was presented.

**Issue:** `dismissAction()` uses `presentationMode` while `dismissViewAction()` uses `closeAction`. Only one dismiss mechanism should be used.

**Fix:** Use `closeAction` consistently. After successful creation, call `closeAction?()` instead of `presentationMode.wrappedValue.dismiss()`.

---

### 4.3 `RoundButtonStyle` extension redeclared in every platform file

**File:** `AddButton+macOS.swift:49-53`

```swift
extension ButtonStyle where Self == RoundButtonStyle {
    static var roundButtonStyle: RoundButtonStyle {
        RoundButtonStyle()
    }
}
```

This extension exists in the macOS, iOS, and visionOS `AddButton` files — three identical copies. Since `RoundButtonStyle` itself is already in the shared `Shared/UI/` folder, this convenience extension should live there too.

**Fix:** Move the extension into `Shared/UI/RoundButtonStyle.swift` (without `#if os()` guards).

---

### 4.4 `WishKit.subscribers` is declared but never used

**File:** `WishKit.swift:17`

```swift
private static var subscribers: Set<AnyCancellable> = []
```

This set is never populated or read anywhere in the codebase. It's dead code that allocates an empty Set on startup.

**Fix:** Remove it.

---

### 4.5 Sheet `.frame()` dimensions are inconsistent across call sites

| Location | `minWidth` | `minHeight` | `maxHeight` |
|---|---|---|---|
| `WishlistContainer` (navigation bar sheet) | 500 | 400 | 600 |
| `WishlistView` (detail sheet) | 500 | 450 | 600 |
| `WishlistView` (floating button sheet) | 500 | 400 | 600 |

The detail sheet uses `minHeight: 450` while the create-wish sheets use `minHeight: 400`. If intentional, there's no documentation. If not, it's inconsistent.

**Fix:** Define constants for sheet dimensions so they're maintained in one place:

```swift
enum SheetDimensions {
    static let createWish = (minWidth: 500, idealWidth: 500, minHeight: 400, maxHeight: 600)
    static let detailWish = (minWidth: 500, idealWidth: 500, minHeight: 450, maxHeight: 600)
}
```

---

## 5. Concurrency Issues

### 5.1 `WishKit.user` is mutated outside the lock

**File:** `WishKit.swift:53-56`

```swift
public static func updateUser(customID: String) {
    user.customID = customID    // No lock
    sendUserToBackend()          // Lock starts inside here
}
```

`user` is a reference type (`User` is a `final class`), and its properties are mutated without any thread safety. The lock in `sendUserToBackend()` protects `sendUserTask`, but `user.createRequest()` is called inside the lock after the mutation happened outside it — a classic TOCTOU race.

**Fix:** Either:
- Make `User` a struct (value type) and guard all access behind the lock, or
- Wrap the entire `updateUser` + `sendUserToBackend` flow in the lock.

---

### 5.2 `fetchList(completion:)` wraps async in Task — fire-and-forget with no cancellation

**File:** `WishModel.swift:52-57`

```swift
@MainActor
func fetchList(completion: (() -> ())? = nil) {
    Task { @MainActor in
        await fetchListAsync()
        completion?()
    }
}
```

This creates a new unstructured `Task` each time it's called. If `fetchList()` is called rapidly (e.g., double-tap, or the init + onAppear double-call from bug 1.3), multiple concurrent fetches run simultaneously with no deduplication or cancellation of prior requests.

**Fix:** Store the `Task` and cancel any previous one before starting a new fetch:

```swift
private var fetchTask: Task<Void, Never>?

@MainActor
func fetchList(completion: (() -> ())? = nil) {
    fetchTask?.cancel()
    fetchTask = Task { @MainActor in
        await fetchListAsync()
        completion?()
    }
}
```

---

## 6. Platform-Specific Concerns (macOS)

### 6.1 No native macOS navigation patterns used

The macOS implementation uses a flat `VStack` + `Sheet` pattern that mirrors visionOS. macOS apps typically use `NavigationSplitView` for master-detail layouts. While the current approach works, it doesn't feel native — the wish list and detail view can't be shown side by side, which is the expected macOS UX for list-detail interfaces.

**Recommendation:** Consider adopting `NavigationSplitView` on macOS 13+:

```swift
NavigationSplitView {
    // Wish list in sidebar
    List(selection: $selectedWish) { ... }
} detail: {
    // Detail view
    if let wish = selectedWish {
        DetailWishView(wishResponse: wish, ...)
    }
}
```

This gives users the expected macOS split-view navigation with resizable sidebar, without needing modal sheets for detail.

---

### 6.2 Deprecated `Alert` API used everywhere

**File:** `CreateWishView+macOS.swift:35-43, 169-213`

The code uses the old `Alert` struct API:

```swift
Alert(title: ..., message: ..., primaryButton: ..., secondaryButton: ...)
```

This was deprecated in macOS 12. The modern replacement is the `.alert(_:isPresented:actions:message:)` modifier with `@ViewBuilder` content.

---

### 6.3 `onChange(of:)` using deprecated single-parameter closure

**File:** `CreateWishView+macOS.swift:64, 87` and `WishView.swift:102, 114, 121`

```swift
.onChange(of: viewModel.titleText) { _ in
    viewModel.handleTitleAndDescriptionChange()
}
```

The single-parameter `onChange(of:perform:)` is deprecated in macOS 14 / iOS 17. The new signature passes both old and new values:

```swift
.onChange(of: viewModel.titleText) { oldValue, newValue in
    viewModel.handleTitleAndDescriptionChange()
}
```

If targeting macOS 13+, wrap with an availability check or update the minimum deployment target.

---

### 6.4 Sheet presentation on the `AddButton` itself — should be on the parent

**File:** `WishlistView+macOS.swift:96-103`

```swift
AddButton(buttonAction: createWishAction)
    .padding([.bottom, .trailing], 20)
    .sheet(isPresented: $showingCreateSheet) {
        CreateWishView(...)
    }
```

Attaching `.sheet` to the `AddButton` means the sheet is presented relative to the button's position in the view hierarchy. While this works, it's fragile — if the button is removed or conditionally hidden, the sheet binding breaks. It's more robust to attach sheets to a stable parent view.

---

## Summary of Priority Fixes

| Priority | Issue | Impact |
|---|---|---|
| **Critical** | 1.1 — `WishModel` recreated every render | Data loss, wasted network calls |
| **Critical** | 1.2 — `@ObservedObject` instead of `@StateObject` for `AlertModel` | Alerts may never show |
| **High** | 1.3 — Double `fetchList()` call | Redundant API calls on every appear |
| **High** | 2.2 — Side effects in `init` | API calls during view identity evaluation |
| **High** | 2.4 — `NSTextView.frame` override affects entire process | Breaks `NSTextView` in host apps |
| **High** | 5.1 — Race condition in `updateUser` | Potential data corruption |
| **Medium** | 1.5 — `WKButton` double background/clip | Visual glitch with mismatched corner radii |
| **Medium** | 1.6 — Double `.buttonStyle` on `AddButton` | `RoundButtonStyle` silently ignored |
| **Medium** | 2.3 — `ZStack` for mutually exclusive content | Unnecessary view evaluations |
| **Medium** | 3.1 — Duplicated toolbar views | Maintenance burden |
| **Medium** | 3.3 — `WishModel` missing `@MainActor` | Potential thread safety issues |
| **Low** | 2.1 — Deprecated `presentationMode` | Will warn on newer SDKs |
| **Low** | 3.2 — Color scheme boilerplate | Code duplication |
| **Low** | 4.1-4.4 — Dead code | Clutter |
| **Low** | 6.1 — No `NavigationSplitView` | Not native macOS feel |
| **Low** | 6.2-6.3 — Deprecated `Alert` and `onChange` APIs | Future SDK warnings |
