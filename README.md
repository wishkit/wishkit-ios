<h3 align="center">WishKit</h1>
<h4 align="center"> In-App Feature Requests. Made Easy. </h2>
<p align="center">
	<a href="LICENSE">
        	<img src="https://img.shields.io/badge/license-MIT-00c573.svg" alt="MIT License">
	</a>
	<a href="https://swift.org">
        	<img src="https://img.shields.io/badge/swift-5.6-00c573.svg" alt="Swift 5.6">
	</a>
	<a href="https://twitter.com/mywishkit" target="_blank">
        	<img src="https://img.shields.io/badge/twitter-@mywishkit-00c573.svg" alt="Twitter">
	</a>
</p>
<p align="center">
WishKit allows you to provide a native wishlist feature in your app that <b>just works ✨</b> <br/>
</p>

### How To Setup
1. To start using WishKit simply add it as a dependency in Xcode.
```
https://github.com/wishkit/wishkit-ios.git
```

2. Import it and configure it with your API Key that you will find in your admin dashboard on <a href="https://wishkit.io/dashboard" target="_blank">wishkit.io</a>
```swift
import WishKit

WishList.configure(with: "your_api_key")
```

3. Done! Now you can just present the ViewController.
```swift
present(WishList.viewController, animated: true)
```

<hr/>

### Example Project
Here is an [Example Project](https://github.com/wishkit/wishkit-ios-example) showcasing how to set it up!

<img src="https://user-images.githubusercontent.com/13883699/219566753-9edbc157-9c69-4f3c-a8a7-8ef80a9bbebd.gif" width="500" />
