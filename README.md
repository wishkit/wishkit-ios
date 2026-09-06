<h1 align="center"> <a href="https://www.wishkit.io/?ref=github">wishkit.io</a></h1>
<h4 align="center"> The best In-App Feature Request and Feedback Board </h2>
<p align="center">
	<a href="LICENSE">
        	<img src="https://img.shields.io/badge/License-MIT-00c573.svg" alt="MIT License">
	</a>
	<a href="https://swift.org">
        	<img src="https://img.shields.io/badge/Swift-5.9-00c573.svg" alt="Swift 5.9">
	</a>
	<a href="https://twitter.com/mywishkit" target="_blank">
        	<img src="https://img.shields.io/badge/Twitter-@mywishkit-00c573.svg" alt="Twitter">
	</a>
</p>
<p align="center">
WishKit allows your users to request and vote on features in your app! <br/>
</p>

<img src="Resources/banner-min.png" />

## Index
- [Setup (SwiftUI)](#swiftui)
- [Chat](#chat)
- [Theming](#theming)
- [User Segmentation](#user-segmentation)
- [Control UI Elements](#ui-elements)
- [Localization](#localization)
- [Privacy](#privacy)
- [Migrating from v4 (UIKit)](#migrating-from-v4-uikit)

# SwiftUI

## 1. Add WishKit (v5.0.0) as a dependency in Xcode.
```
https://github.com/wishkit/wishkit-ios.git
```

## 2. Configure WishKit with your API Key in the first view.
###### You can find your API key in your admin dashboard on <a href="https://www.wishkit.io" target="_blank">wishkit.io</a>.
```swift
import SwiftUI
import WishKit

struct ContentView: View {

    init() {
        WishKit.configure(with: "your-api-key")
    }
  
    ...
}
```

## 3. Now use the view wherever you want!
```swift
import SwiftUI
import WishKit

struct ContentView: View {

    init() {
        WishKit.configure(with: "your-api-key")
    }

    var body: some View {
        WishKit.FeedbackListView()
    }
}
```

###### NOTE: On iOS and tvOS, `FeedbackListView` expects to live inside a `NavigationStack`. If it's not already inside one, add `.withNavigation()` to wrap it: `WishKit.FeedbackListView().withNavigation()`. On macOS, visionOS, and watchOS, `FeedbackListView` provides its own navigation container — no wrapping needed.

---

# Chat
#### Talk to your users directly, right inside your app. 💬

Your users get a private channel to reach you before they vent in an App Store review. You read and reply from your dashboard on <a href="https://www.wishkit.io" target="_blank">wishkit.io</a>.

The feedback board shows a floating chat button out of the box, so there is nothing to integrate. If you want more control:

```swift
// Place the chat anywhere in your app with one line.
WishKit.ChatView()

// Hide the floating chat button in the feedback board.
WishKit.config.showChatButtonInFeedbackView = false

// Check for unread replies to badge your own chat entry point.
let status = await WishKit.chatStatus()
if status.hasUnread {
    // show a dot on your chat button
}
```

---

# Configuration
#### You can configure a lot of WishKit's UI elements.

```swift
// Allow user to undo their vote
WishKit.config.allowUndoVote = true

// Shows full description of a feature request in the list.
WishKit.config.expandDescriptionInList = true

// Hide comment section
WishKit.config.commentSection = .hide

// Show the status badge of a feature request (e.g. pending, approved, etc.).
WishKit.config.statusBadge = .show

// Hide the segmented control.
WishKit.config.buttons.segmentedControl.display = .hide

// Show internal debug logs in the console (network requests, errors, etc.).
// Off by default so production builds stay quiet.
WishKit.config.showDebugLogs = true

```

---

# Theming
#### You can theme WishKit to fit your apps color. 🎨

```swift
// Accent color for primary actions (Save button, active Vote-Button, comment send).
// Defaults to your app's accent color so WishKit blends in natively.
WishKit.theme.primaryColor = .yellow

// Set the secondary color (this is for the cells and text fields).
WishKit.theme.secondaryColor = .set(light: .orange, dark: .red)

// Set the tertiary color (this is for the background).
WishKit.theme.tertiaryColor = .set(light: .gray, dark: .black)

```


---

# User Segmentation
#### 💰 Revenue Indication: Share how much a user is paying in your app.
```swift
// How much a user is paying per week or month or year.
// WishKit supports weekly, monthly and yearly payments.
WishKit.updateUser(payment: .monthly(7.99))
```
By sharing the revenue of a user you will be able to see "how much money" is behind a feature request.
This allows you to prioritize a feature with only 2 votes but $13 over a feature with 7 votes and $0.

#### 📧 Additional: Share optional user information with WishKit.
```swift
// Email
WishKit.updateUser(email: "jobs@apple.com")

// Name
WishKit.updateUser(name: "Steve")

// If you manage user IDs yourself you can let WishKit prioritize it.
WishKit.updateUser(customID: "8AHD1IL03ACIP")
```

---

# Localization
#### WishKit ships with built-in translations and follows your app's language.

### **Supported languages**

| Language | Code |
|---|---|
| English | `en` |
| Chinese (Simplified) | `zh-Hans` |
| Chinese (Traditional) | `zh-Hant` |
| Danish | `da` |
| Dutch | `nl` |
| Finnish | `fi` |
| French | `fr` |
| German | `de` |
| Italian | `it` |
| Japanese | `ja` |
| Korean | `ko` |
| Norwegian (Bokmål) | `nb` |
| Polish | `pl` |
| Portuguese (Brazil) | `pt-BR` |
| Spanish | `es` |
| Swedish | `sv` |
| Turkish | `tr` |

WishKit uses the language your app runs in — the app's language, not the device language, so your app needs to support a language for WishKit to display it. If the app's language isn't one of the supported ones, WishKit falls back to English. Translations use informal address where the language distinguishes (German "Du", Spanish "tú").

#### You can override any text by assigning your own values.

```swift
// Override the segmented control text for "Open".
WishKit.config.localization.open = "Offen"

// You can also assign NSLocalizedString.
WishKit.config.localization.cancel = NSLocalizedString("general.cancel", comment: "")
```

#### 🌐 On-device translation of feedback (iOS 18+)

When a feature request is written in a different language than your app runs in, WishKit shows a small "See translation" button below its description — both in the list and in the detail view. Tapping it translates the title and description on-device using Apple's Translation framework — nothing leaves the device — and toggles to "See original".

```swift
// Default is .automatic — the button only appears when the
// detected language of a request differs from the app's language.
WishKit.config.translateButton = .automatic

// Always show the button (covers texts too short to detect reliably).
WishKit.config.translateButton = .always

// Turn the feature off.
WishKit.config.translateButton = .hide
```

# Privacy

WishKit ships a privacy manifest (`PrivacyInfo.xcprivacy`) that Xcode automatically includes in your app's aggregated privacy report. It declares what WishKit collects out of the box:

- **User ID** — an anonymous, randomly generated per-install identifier used to associate votes and feedback. Not linked to the user's identity, not used for tracking.
- **Product interaction** — votes and feedback activity. App functionality only.
- **User content** — the feature requests and comments users write. App functionality only.

WishKit does not track users and declares no tracking domains.

If you share additional user information via `updateUser` — email, name, or your own custom ID — that data is sent to WishKit too, but it is *not* part of WishKit's manifest since collecting it is your app's choice. In that case, cover it in your own app's privacy details in App Store Connect (e.g. "Email Address" / "Name" under app functionality).

### **Platforms**

- iOS 16+
- macOS 13+
- visionOS 1+
- watchOS 10+
- tvOS 17+

### **Platform feature matrix**

| Feature | iOS | macOS | visionOS | watchOS | tvOS |
|---|:-:|:-:|:-:|:-:|:-:|
| Browse wishes | Yes | Yes | Yes | Yes | Yes |
| Vote / undo vote | Yes | Yes | Yes | Yes | Yes |
| Create wish | Yes | Yes | Yes | — | — |
| Read comments | Yes | Yes | Yes | — | Yes |
| Post comments | Yes | Yes | Yes | — | — |
| State filter (`buttons.segmentedControl`) | Yes | Yes | Yes | Yes | Yes |
| Done button (`buttons.doneButton`) | Yes | Yes | Yes | — | — |
| Add button (`buttons.addButton`) | Yes | Yes | Yes | — | — |
| Translate feedback (`translateButton`) | iOS 18+ | — | — | — | — |

watchOS and tvOS are intentionally scoped to browse + vote. Config keys for unsupported features are silently ignored on those platforms. On tvOS, users dismiss the feedback view via the Siri Remote's Menu button (the standard system pattern), so `buttons.doneButton` is not exposed.

On watchOS and tvOS, the state filter is rendered as a single cycle button that loops through the available states on tap — a more remote- and crown-friendly affordance than a segmented control.

---

### **Example Project**
Checkout the [example project](https://github.com/wishkit/wishkit-ios-example) to see how easy it is to set up WishKit!

---

# Migrating from v4 (UIKit)

WishKit 5 is SwiftUI-only. The `WishKit.viewController` entry point that existed in v4 has been removed. If you were presenting `WishKit.viewController.withNavigation()` from a `UIViewController`, switch to wrapping the SwiftUI view yourself:

```swift
import UIKit
import SwiftUI
import WishKit

class HomeViewController: UIViewController {

    @objc func buttonTapped() {
        let feedback = UIHostingController(rootView: WishKit.FeedbackListView().withNavigation())
        present(feedback, animated: true)
    }
}
```

Everything else — `WishKit.configure(_:)`, `WishKit.config`, `WishKit.theme`, `WishKit.updateUser(...)` — works the same as before.
