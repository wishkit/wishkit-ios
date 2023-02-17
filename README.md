<h3 align="center">WishKit</h1>
<h4 align="center"> In-App Feature Requests. Made Easy. </h2>
<p align="center">
	<a href="https://wishkit.io/docs" target="_blank">
        	<img src="http://img.shields.io/badge/read_the-docs-00c573.svg" alt="docs" />
	</a>
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
