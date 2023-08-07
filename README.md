<h1 align="center"> <a href="https://www.wishkit.io/?ref=github">wishkit.io</a></h1>
<h4 align="center"> In-App Feature Requests. Made Easy. </h2>
<p align="center">
	<a href="LICENSE">
        	<img src="https://img.shields.io/badge/License-MIT-00c573.svg" alt="MIT License">
	</a>
	<a href="https://swift.org">
        	<img src="https://img.shields.io/badge/Swift-5.6-00c573.svg" alt="Swift 5.6">
	</a>
	<a href="https://twitter.com/mywishkit" target="_blank">
        	<img src="https://img.shields.io/badge/Twitter-@mywishkit-00c573.svg" alt="Twitter">
	</a>
</p>
<p align="center">
WishKit allows your users to request and vote on features in your app that <b>just works ✨</b> <br/>
</p>

<img src="Resources/banner-min.png" />

## Index
- [Setup (UIKit)](#uikit)
- [Setup (SwiftUI)](#swiftui)
- [Theming](#theming)
- [User Segmentation](#user-segmentation)
- [Control UI Elements](#ui-elements)
- [Localization](#localization)

# UIKit

## 1. Add WishKit as a dependency in Xcode.
```
https://github.com/wishkit/wishkit-ios.git
```

## 2. Configure WishKit with your API Key.
###### You can find your API key in your admin dashboard on <a href="https://wishkit.io" target="_blank">wishkit.io</a>.
```swift
import UIKit
import WishKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	WishKit.configure(with: "your_api_key")
        return true
    }
    
    ...
}
```

## 3. Now you can present the WishKit viewController.
```swift
import UIKit
import WishKit

class HomeViewController: UIViewController {
  ...
  
  @objc func buttonTapped() {
    present(WishKit.viewController, animated: true)  
  }
}
```
###### NOTE: You can configure WishKit anywhere you want as long as you configure it **before** you present the viewController.
---

# SwiftUI

## 1. Add WishKit as a dependency in Xcode.
```
https://github.com/wishkit/wishkit-ios.git
```

## 2. Configure WishKit with your API Key in the first view.
###### You can find your API key in your admin dashboard on <a href="https://wishkit.io" target="_blank">wishkit.io</a>.
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
    WishKit.view
  }
}
```
###### NOTE: You can configure WishKit anywhere you want as long as you configure it **before** you use the view.

---

# Theming
#### You can theme WishKit to fit your apps color. 🎨

```swift
// This is for the Add-Button, Segmented Control, and Vote-Button.
WishKit.theme.primaryColor = .yellow

// Set the secondary color (this is for the cells and text fields).
WishKit.theme.secondaryColor = .set(light: .orange, dark: .red)

// Set the tertiary color (this is for the background).
WishKit.theme.tertiaryColor = .set(light: .gray, dark: .black)

// Segmented Control (Text color)
WishKit.config.buttons.segmentedControl.defaultTextColor = .setBoth(to: .white)

WishKit.config.buttons.segmentedControl.activeTextColor = .setBoth(to: .white)

// Save Button (Text color)
WishKit.config.buttons.saveButton.textColor = .set(light: .white, dark: .white)

```


---

# User Segmentation
#### Share user information so you can access it on the dashboard.
```swift
// How much he's paying per week or month or year.
WishKit.updateUser(payment: .monthly(7.99))

// What his email is.
WishKit.updateUser(email: "stevejobs@apple.com")

// What his name is.
WishKit.updateUser(name: "Steve")

// If you manage user IDs yourself you can let WishKit prioritize it.
WishKit.updateUser(customID: "8AHD1IL03ACIP")
```

---

# UI Elements
#### You can control some WishKit UI elements.

```swift
// Show the status badge of a wish (e.g. pending, approved, etc.).
WishKit.config.statusBadge = .show

// Hide the segmented control.
WishKit.config.buttons.segmentedControl.display = .hide

// Position the Add-Button.
WishKit.config.buttons.addButton.bottomPadding = .large

```

---

# Localization
#### Localize any text used by WishKit by overriding default values.

```swift
// Override the segmented control text to the german word for "Requested".
WishKit.config.localization.requested = "Angefragt"

// You can also assign NSLocalizedString.
WishKit.config.localization.cancel = NSLocalizedString("general.cancel", comment: "")
```

### **Platforms**

- iOS 14+
- macOS 12+

---

### **Example Project**
Checkout the [example project](https://github.com/wishkit/wishkit-ios-example) to see how easy it is to set up a wishlist!
