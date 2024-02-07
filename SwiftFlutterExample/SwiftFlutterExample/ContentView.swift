//
//  ContentView.swift
//  SwiftFlutterExample
//
//  Created by Nicholas Bui LeTourneau on 2/6/24.
//

import SwiftUI
import Flutter

struct ContentView: View {
    // Flutter dependencies are passed in an EnvironmentObject.
    @EnvironmentObject var flutterDependencies: FlutterDependencies
    
    // Button is created to call the showFlutter function when pressed.
    var body: some View {
        Button("Send method to Flutter!") {
            sendToFlutter()
        }
    }
    
    func sendToFlutter() {
        let channel = FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                                           binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)
        
        channel.invokeMethod("performSomeAction", arguments: nil) { (response) in
            // Handle the Flutter method response if necessary
            print("response", response!)
        }
    }
}
