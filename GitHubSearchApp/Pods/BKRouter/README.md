# BKRouter

BKRouter is a navigator for UIViewControllers on iOS. It navigates the UIViewControllers via a url string.   

<div align="center">
<img src="https://raw.githubusercontent.com/ReactComponentKit/BKRouter/master/art/BKRouter.png" />
</div> 


## Installation

You can install BKRouter via cocoapod.

```swift
pod 'BKRouter'
```

## How to Use it?

You should make a route map and register it to Router. Route map is a implementation of Routerable protocol. A Route map for ColorViewController is like below:

```swift
import UIKit
import BKRouter

class RouteColor: Routerable {
    static func route(scheme: String, host: String, params: [String : String], userData:[String: Any]?) -> UIViewController? {
        // storyboard
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorViewController")
        
        if let colorVC = vc as? ColorViewController {
            if let color = params["color"] {
                switch color {
                case "red":
                    colorVC.color = UIColor.red
                case "blue":
                    colorVC.color = UIColor.blue
                case "green":
                    colorVC.color = UIColor.green
                default:
                    colorVC.color = UIColor.white
                }
            }
        }
        return vc
    }
}
```

If you use a host as "myapp", you can map "myapp://color" to RouteColor like as below:

```swift
Router.shared.map(url: "myapp://color?color=$value", to: RouteColor.self)
```

In the abobe code, the $value is the value that is passed via url string. If you have more complex data, you can use userData when you route by using Router like below:

```swift
Router.shared.push(from: self, to: "myapp://color?color=red", userData: ["A": 1])
```

You can modulate your app into framework fragments. If DomainA framework has many scene as UIViewController, you can define a Route for routing DomainA.

```swift
import Foundation
import BKRouter

public class RouteDomainA: Routerable {
    public static func route(scheme: String, host: String, params: [String : String], userData:[String: Any]?) -> UIViewController? {
        // storyboard
        guard let items = userData?["items"] as? [String] else { return nil }
        let viewModel = DomainAViewModel(havyItemArray: items)
        let vc = DomainAViewController(viewModel: viewModel)
        return vc
    }
}
```

Of course, you should register above RouteDomainA to Router like below:

```swift
Router.shared.map(url: "myapp://domainA", to: RouteDomainA.self)
```

## Register Routes to Router

You should register route maps to Router. AppDelegate is a good place to do it. 

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
    Router.shared.map(url: "myapp://main?title=$value&a=$v1&b=v2", to: RouteMain.self)
    Router.shared.map(url: "myapp://color?color=$value", to: RouteColor.self)
    Router.shared.map(url: "myapp://domainA", to: RouteDomainA.self)
    Router.shared.map(url: "myapp://domainB?title=$value", to: RouteDomainB.self)
    return true
}
```

## Route it

You can route UIViewControllers by using Router. 

```swift
@IBAction func clickedRedButton(_ sender: Any) {
    Router.shared.push(from: self, to: "myapp://color?color=red", userData: ["A": 1])
}
    
@IBAction func clickedGreenButton(_ sender: Any) {
    Router.shared.push(from: self, to: "myapp://color?color=green")
}
    
@IBAction func clickedBlueButton(_ sender: Any) {
    Router.shared.push(from: self, to: "myapp://color?color=blue")
}

@IBAction func clickedNextButton(_ sender: Any) {
    Router.shared.push(from: self, to: "myapp://domainB?title=Hello")
}

@IBAction func clickedNextButton(_ sender: Any) {
    let items = [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
        "when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
        "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,",
        "and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    ]

    Router.shared.push(from: self, to: "myapp://domainA", userData: ["items": items])
}
```

## Handle Deeplinking

You can also handle deeplinks using Router. First of all, you should register an URLType scheme for your deeplink.

```xml
<key>CFBundleURLTypes</key>
<array>
   <dict>
      <key>CFBundleURLName</key>
      <string>com.github.skyfe79.bkrouter</string>
      <key>CFBundleURLSchemes</key>
      <array>
         <string>myapp</string>
      </array>
   </dict>
</array>
```

You can handle deeplinks like belows:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    Router.shared.replace(to: url.absoluteString, wrapNavigationController: true)
    return true
}
```

### Test Deeplinks with iOS Simulator

You can test deeplinks using iOS simulator from your terminal.

 1. Run the above example app.
 2. Open the terminal.
 3. type the below commands.

```
xcrun simctl openurl booted 'myapp://main'
xcrun simctl openurl booted 'myapp://domainB?title=HELLO'
xcrun simctl openurl booted 'myapp://color?color=red'
xcrun simctl openurl booted 'myapp://domainB?title=%EC%95%88%EB%85%95%ED%95%98%EC%84%B8%EC%9A%94'
...
```

## MIT License

MIT License

Copyright (c) 2018 Sungcheol Kim, https://github.com/ReactComponentKit/BKRouter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.