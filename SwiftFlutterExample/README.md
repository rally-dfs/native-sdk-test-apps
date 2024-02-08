## Setup / Assumptions

* You need to have Flutter installed on your machine. If you don't have it installed, you can get it from [here](https://flutter.dev/docs/get-started/install).
* You need to have CocoaPods installed on your machine. If you don't have it installed, you can get it from [here](https://cocoapods.org/).
* The codebase uses swiftformat to format the code. You can install it using `brew install swiftformat`.

## Building the project

1. `pod install`
2. `open <project_name>.xcworkspace`
3. Create a file named `Secrets.swift` in the project and add the following code:

```swift
enum Secrets {
  public static let apiKey = "your api key"
}
```