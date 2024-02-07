
## Building the project

1. `pod install`
2. `open <project_name>.xcworkspace`
3. Create a file named `Secrets.swift` in the project and add the following code:

```swift
enum Secrets {
  public static let apiKey = "your api key"
}
```