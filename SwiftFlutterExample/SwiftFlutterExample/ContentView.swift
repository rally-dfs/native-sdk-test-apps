//
//  ContentView.swift
//  SwiftFlutterExample
//
//  Created by Nicholas Bui LeTourneau on 2/6/24.
//

import Flutter
import SwiftUI

struct ContentView: View {
    // Flutter dependencies are passed in an EnvironmentObject.
    @EnvironmentObject var flutterDependencies: FlutterDependencies

    // Button is created to call the showFlutter function when pressed.
    var body: some View {
        VStack {
            Button("Send method to Flutter!") {
                sendToFlutter()
            }
            .padding(.bottom, 24) // Add 24px of padding to the bottom of the first button

            Button("Clear Wallet") {
                clearWallet()
            }
        }
    }

    func sendToFlutter() {
        let channel = FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                                           binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)

        channel.invokeMethod("getWalletAddress", arguments: nil) { response in
            // Handle the Flutter method response if necessary
            print("existing wallet = ", response!)

            if response as! String == "no address" {
                channel.invokeMethod("createWallet", arguments: nil) { response in
                    print("successfully created wallet")
                    print("New wallet address = ", response!)
                }
            }
        }
    }

    func clearWallet() {
        let channel = FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                                           binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)

        channel.invokeMethod("deleteWallet", arguments: nil) { _ in
            print("cleared wallet")
        }
    }
}
