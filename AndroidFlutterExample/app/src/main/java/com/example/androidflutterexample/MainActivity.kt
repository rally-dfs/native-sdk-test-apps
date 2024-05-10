package com.example.androidflutterexample


import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.LinearLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

const val CHANNEL = "channels.rly.network/wallet_manager"

class MainActivity : FlutterActivity() {
    private lateinit var methodChannel: MethodChannel
    private lateinit var layout: LinearLayout;
    private var setupEnvButtonId: Int = 0;
    private var walletAddress: String = "";
    private var envSet: Boolean = false;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main_activity)
        layout  = findViewById(R.id.layout)

        val createWalletButton: Button = Button(this)
        createWalletButton.text = "Create Wallet";
        val clearWalletButton: Button = Button(this)
        clearWalletButton.text = "Clear Wallet";

        layout.addView(createWalletButton);
        layout.addView(clearWalletButton);

        createWalletButton.setOnClickListener {
            getExistingWallet();
        }

        clearWalletButton.setOnClickListener{
            clearWallet()
        }
    }

    fun updateLayout(){
        if(walletAddress.isNotBlank()){
            setupEnvButtonId = View.generateViewId();
            val setupEnvButton: Button = Button(this)
            setupEnvButton.id = setupEnvButtonId
            setupEnvButton.text = "Setup Blockchain Env";
            setupEnvButton.setOnClickListener {
                setupBlockchainEnv()
            }
            layout.addView(setupEnvButton);
        } else {
            layout.removeView(layout.findViewById(setupEnvButtonId))
        }
        if(envSet){
            layout.removeView(layout.findViewById(setupEnvButtonId))
            val claimRlyButton: Button = Button(this)
            claimRlyButton.text = "Claim RLY Tokens";
            val transferRlyButton: Button = Button(this)
            transferRlyButton.text = "Transfer RLY Tokens";
            val getRlyBalanceButton: Button = Button(this)
            getRlyBalanceButton.text = "Get Balance"

            claimRlyButton.setOnClickListener {
                claimRly()
            }

            transferRlyButton.setOnClickListener {
                transfer()
            }

            getRlyBalanceButton.setOnClickListener {
                getBalance()
            }

            layout.addView(claimRlyButton);
            layout.addView(transferRlyButton)
            layout.addView(getRlyBalanceButton)

        }

    }

    fun getExistingWallet() {
        methodChannel.invokeMethod("getWalletAddress", null, object: MethodChannel.Result  {
            override fun success(result: Any?) {

                walletAddress = result as String;
                println("current wallet address = $walletAddress")

                if(walletAddress == "no address") {
                    methodChannel.invokeMethod("createWallet", mapOf(
                        "saveToCloud" to false,
                        "rejectOnCloudSaveFail" to false
                    ), object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            println("new wallet address = $result")
                            walletAddress = result as String;
                            updateLayout()
                        }

                        override fun error(
                            errorCode: String,
                            errorMessage: String?,
                            errorDetails: Any?
                        ) {
                            println("error is $errorMessage")
                        }

                        override fun notImplemented() {
                            TODO("Not yet implemented")
                        }
                    })
                } else {
                    updateLayout()
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("error creating wallet: $errorMessage")
            }

            override fun notImplemented() {
                TODO("Not yet implemented")
            }
        })
    }

    fun clearWallet() {
        methodChannel.invokeMethod("deleteWallet", null, object: MethodChannel.Result{
            override fun success(result: Any?) {
                walletAddress = "";
                println("cleared wallet")
                updateLayout()
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("error clearing wallet: $errorMessage")
            }
            override fun notImplemented() {
                TODO("Not yet implemented")
            }
        })
    }

    fun setupBlockchainEnv(){
        methodChannel.invokeMethod("configureEnvironment", arrayListOf<String>("eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOjY3MH0.W8IAyOnO5ZqjL9-c-39JXfVnzkuL7KbxAP80S_cFhmTfDKtz9GBDBIjQ2P_CQLxD-SzcvCTRLjOj5VOcbxEq2g", "amoy")
            , object: MethodChannel.Result{
            override fun success(result: Any?) {
                println("env set")
                envSet = true;
                updateLayout()
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("error setting up env: $errorMessage")
            }
            override fun notImplemented() {
                TODO("Not yet implemented")
            }
        })
    }

    fun claimRly(){
        println("claiming rly")
        methodChannel.invokeMethod("claimRly", null, object: MethodChannel.Result{
            override fun success(result: Any?) {
                println("RLY claimed")
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("error claiming rly: $errorMessage")
            }
            override fun notImplemented() {
                TODO("Not yet implemented")
            }
        })
    }

    fun transfer(){
        methodChannel.invokeMethod("transferPermit", mapOf(
            "destinationAddress" to "0xe75625f0c8659f18caf845eddae30f5c2a49cb00",
            "amount" to "2000000000000000000"
        ), object: MethodChannel.Result{
            override fun success(result: Any?) {
                println("tx hash $result")
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("error on transfer: $errorMessage")
            }
            override fun notImplemented() {
                TODO("Not yet implemented")
            }
        })
    }

    fun getBalance(){
        methodChannel.invokeMethod("getBalance", null, object: MethodChannel.Result{
            override fun success(result: Any?) {
                println("RLY balance $result")
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("error getting  balance: $errorMessage")
            }
            override fun notImplemented() {
                TODO("Not yet implemented")
            }
        })
    }


}
