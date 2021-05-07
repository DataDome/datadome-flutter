package co.datadome.demo

import android.Manifest
import android.os.AsyncTask
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.Toast
import androidx.core.app.ActivityCompat
import co.datadome.sdk.DataDomeInterceptor
import co.datadome.sdk.DataDomeSDK
import co.datadome.sdk.DataDomeSDKListener
import okhttp3.*
import java.io.IOException
import java.lang.ref.Reference
import java.lang.ref.WeakReference
import okhttp3.logging.HttpLoggingInterceptor

class MainActivity : AppCompatActivity() {
    private var dataDomeSdk: DataDomeSDK.Builder? = null

    internal class OkHttpRequestTask(dataDomeInterceptor: DataDomeInterceptor,
                                     customId: String = "") : AsyncTask<String, Void, Void>() {
        private var dataDomeInterceptorRef: WeakReference<DataDomeInterceptor>
                = WeakReference(dataDomeInterceptor)

        private var customTextRef: Reference<String> = WeakReference(customId)

        override fun doInBackground(vararg args: String): Void? {
            val dataDomeInterceptor = dataDomeInterceptorRef.get()
            val customText = customTextRef.get()

            if (dataDomeInterceptor != null) {
                val builder = OkHttpClient.Builder()

                builder.addInterceptor(dataDomeInterceptor)

                val loggingInterceptor = HttpLoggingInterceptor()
                loggingInterceptor.level = HttpLoggingInterceptor.Level.BASIC
                loggingInterceptor.redactHeader("Authorization")
                builder.addInterceptor(loggingInterceptor)
                val client = builder.build()

                val request = Request.Builder()
                        .header("User-Agent", args[1])
                        .url(args[0])
                        .build()

                try {
                    val callback: Callback = object: Callback {
                        override fun onFailure(call: Call, e: IOException) {
                            Log.d("DEBUG","ERROR")
                        }

                        override fun onResponse(call: Call, response: Response) {
                            Log.d("DEBUG","Task $customText -> ${response.code()}")
                        }
                    }

                    client.newCall(request).enqueue(callback)
                } catch (e: IOException) {
                    Log.d("DEBUG", "ERROR")
                }

            }
            return null
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        dataDomeSdk = DataDomeSDK
                .with(application, "test", BuildConfig.VERSION_NAME)
                .listener(dataDomeSDKListener)
                .agent("BLOCKUA")

        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 101)

        findViewById<Button>(R.id.button).setOnClickListener {
            makeRequest()
        }
    }

    fun makeRequest() {
        val dataDomeInterceptor = DataDomeInterceptor(
                application,
                dataDomeSdk
        )
        var requests: MutableList<OkHttpRequestTask> = ArrayList()
        val task = OkHttpRequestTask(dataDomeInterceptor, "1")
        requests.add(task)
        requests.forEach {
            it.execute("https://datadome.co/wp-json", "BLOCKUA")
        }
    }

    private var dataDomeSDKListener: DataDomeSDKListener = object: DataDomeSDKListener() {

        @Suppress("OverridingDeprecatedMember", "DEPRECATION")
        override fun onDataDomeResponse(code: Int, response: String?) {
            super.onDataDomeResponse(code, response)
            runOnUiThread {
                if (response != null)
                    Toast.makeText(this@MainActivity, "Response code: $code", Toast.LENGTH_LONG).show()
            }
        }

        override fun onError(errno: Int, error: String?) {
            runOnUiThread { Toast.makeText(this@MainActivity, "Error: $error", Toast.LENGTH_LONG).show() }
        }

        override fun onHangOnRequest(code: Int) {
            super.onHangOnRequest(code)
            runOnUiThread { Toast.makeText(this@MainActivity, "HangOn Request - code: $code", Toast.LENGTH_SHORT).show() }
        }

        override fun onCaptchaSuccess() {
            super.onCaptchaSuccess()
            runOnUiThread { Toast.makeText(this@MainActivity, "Success", Toast.LENGTH_SHORT).show() }
        }

        override fun onCaptchaCancelled() {
            super.onCaptchaCancelled()
            runOnUiThread { Toast.makeText(this@MainActivity, "User cancelled captcha", Toast.LENGTH_SHORT).show() }
        }

        override fun onCaptchaLoaded() {
            super.onCaptchaLoaded()
        }

        override fun onCaptchaDismissed() {
            super.onCaptchaDismissed()
        }
    }
}