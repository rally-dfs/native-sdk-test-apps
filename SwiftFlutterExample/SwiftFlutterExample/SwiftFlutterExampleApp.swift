//
//  SwiftFlutterExampleApp.swift
//  SwiftFlutterExample
//
//  Created by Nicholas Bui LeTourneau on 2/6/24.
//

import SwiftUI
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
  let flutterEngine = FlutterEngine(name: "my flutter engine")
  init(){
    // Runs the default Dart entrypoint with a default Flutter route.
    flutterEngine.run()
    // Connects plugins with iOS platform code to this app.
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
  }
}

@main
struct SwiftFlutterExampleApp: App {
    @StateObject var flutterDependencies = FlutterDependencies()
      var body: some Scene {
        WindowGroup {
          ContentView().environmentObject(flutterDependencies)
        }
      }
}
