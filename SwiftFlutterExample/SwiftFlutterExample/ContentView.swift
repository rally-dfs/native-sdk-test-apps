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

    @State private var envSetup: Bool = false

    private var channel: FlutterMethodChannel {
        FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                             binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)
    }

    // Button is created to call the showFlutter function when pressed.
    var body: some View {
        VStack {
            Button("Check For Existing Wallet") {
                getExistingWallet()
            }
            .padding(.bottom, 24) // Add 24px of padding to the bottom of the first button

            Button("Clear Wallet") {
                clearWallet()
            }.padding(.bottom, 24) // Add 24px of padding to the bottom of the second button

            if !walletAddress.isEmpty {
                Button("Setup Blockchain Env") {
                    setupEnv()
                }.padding(.bottom, 24) // Add 24px of padding to the bottom of the third button
            }

            if envSetup {
                Button("Claim RLY Tokens") {
                    claimRly()
                }.padding(.bottom, 24) // Add 24px of padding to the bottom of the third button
            }
        }
    }

    func getExistingWallet() {
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
        channel.invokeMethod("deleteWallet", arguments: nil) { _ in
            print("cleared wallet")
            walletAddress = "" // Clear the wallet address when the wallet is cleared
        }
    }

    func setupEnv() {
      channel.invokeMethod("configureEnvironment", arguments: [Secrets.apiKey, "mumbai"]) { response in
            print("Env Setup = ", response!)
            envSetup = true
        }
    }

    func claimRly() {
        channel.invokeMethod("claimRly", arguments: nil) { _ in
            print("claimed RLY")
        }
    }
}
