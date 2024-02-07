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

    // Declare a @State variable to store the wallet address
    @State private var walletAddress: String = ""

    // Button is created to call the showFlutter function when pressed.
    var body: some View {
        VStack {
            Button("Send method to Flutter!") {
                sendToFlutter()
            }
            .padding(.bottom, 24) // Add 24px of padding to the bottom of the first button

            Button("Clear Wallet") {
                clearWallet()
            }.padding(.bottom, 24) // Add 24px of padding to the bottom of the second button

            if !walletAddress.isEmpty {
                Button("Claim RLY") {
                    claimRLY()
                }.padding(.bottom, 24) // Add 24px of padding to the bottom of the third button
            }
        }
    }

    func sendToFlutter() {
        let channel = FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                                           binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)

        channel.invokeMethod("getWalletAddress", arguments: nil) { response in
            // Handle the Flutter method response if necessary
            print("existing wallet = ", response!)

            if let address = response as? String {
                walletAddress = address
            }

            if walletAddress == "no address" {
                channel.invokeMethod("createWallet", arguments: nil) { response in
                    print("successfully created wallet")
                    print("New wallet address = ", response!)
                    if let newAddress = response as? String {
                        walletAddress = newAddress
                    }
                }
            }
        }
    }

    func clearWallet() {
        let channel = FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                                           binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)

        channel.invokeMethod("deleteWallet", arguments: nil) { _ in
            print("cleared wallet")
            walletAddress = "" // Clear the wallet address when the wallet is cleared
        }
    }

    func claimRLY() {
        let channel = FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                                           binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)

        channel.invokeMethod("claimRLY", arguments: nil) { response in
            print("claimed RLY")
        }
    }
}
