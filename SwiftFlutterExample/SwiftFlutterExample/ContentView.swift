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
    @State private var didBootstrap: Bool = false
    @State private var performingAction: Bool = false

    private var channel: FlutterMethodChannel {
        FlutterMethodChannel(name: "channels.rly.network/wallet_manager",
                             binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)
    }

    // Button is created to call the showFlutter function when pressed.
    var body: some View {
        ZStack {
            VStack {
                if didBootstrap {
                    if walletAddress.isEmpty {
                        Button("Create Wallet") {
                            createWallet()
                        }.padding(.bottom, 24)
                    } else {
                        Text("Wallet Address: \(walletAddress)").padding(.horizontal, 14)
                        Button("Clear Wallet") {
                            clearWallet()
                        }.padding(.top, 24).padding(.bottom, 48)
                    }

                    if !walletAddress.isEmpty && !envSetup {
                        Button("Setup Blockchain Env") {
                            setupEnv()
                        }.padding(.bottom, 24)
                    }

                    if envSetup {
                        Button("Claim RLY Tokens") {
                            claimRly()
                        }.padding(.bottom, 24).padding(.top, 48)

                        Button("Check RLY Token Balance") {
                            getBalance()
                        }.padding(.bottom, 24)

                        Button("Transfer Some RLY Tokens") {
                            transferRly()
                        }.padding(.bottom, 24)
                    }

                } else {
                    Text("Attempting to Load Pre Existing Wallet")
                }
            }

            if performingAction {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }.onAppear {
            getExistingWallet()
        }
    }

    func getExistingWallet() {
        channel.invokeMethod("getWalletAddress", arguments: nil) { response in
            // Handle the Flutter method response if necessary
            print("existing wallet = ", response!)

            if let address = response as? String {
                walletAddress = address
            }
            didBootstrap = true
        }
    }

    func createWallet() {
        channel.invokeMethod("createWallet", arguments: ["saveToCloud": false]) { response in
            print("successfully created wallet")
            print("New wallet address = ", response!)
            if let newAddress = response as? String {
                walletAddress = newAddress
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
        channel.invokeMethod("configureEnvironment", arguments: [Secrets.apiKey, "amoy"]) { response in
            print("Env Setup = ", response!)
            envSetup = true
        }
    }

    func claimRly() {
        performingAction = true
        channel.invokeMethod("claimRly", arguments: nil) { response in
            performingAction = false
            print("claimed RLY txn = ", response!)
        }
    }

    func transferTaki() {
        let takiTokenAddress = "0x8f5858b95797558f6facca3a9f20a081c3af6880"
        let recipientAddress = "0xc073ade46aba2f72bf27e7befd37af9301cd8920"

        performingAction = true
        channel.invokeMethod("transferPermit", arguments: ["destinationAddress": recipientAddress, "amount": "2000000000000000000", "wrapperType": "Permit", "tokenAddress": takiTokenAddress]) { response in
            performingAction = false
            print("transfer txn = ", response!)
        }
    }

    func transferRly() {
        performingAction = true
        channel.invokeMethod("transferPermit", arguments: ["destinationAddress": "0xe75625f0c8659f18caf845eddae30f5c2a49cb00", "amount": "2000000000000000000"]) { response in
            performingAction = false
            print("transfer txn = ", response!)
        }
    }

    func getBalance() {
        performingAction = true
        channel.invokeMethod("getBalance", arguments: nil) { response in
            performingAction = false
            print("balance = ", response!)
        }
    }
}
