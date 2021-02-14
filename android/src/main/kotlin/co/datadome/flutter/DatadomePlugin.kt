package co.datadome.flutter

import android.app.Activity
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import co.datadome.sdk.DataDomeInterceptor
import co.datadome.sdk.DataDomeSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import okhttp3.*
import java.io.IOException


/** DatadomePlugin */
class DatadomePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var dataDomeSDK: DataDomeSDK.Builder
  private var context: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "datadome")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    context = binding.activity
  }

  override fun onDetachedFromActivity() {
    context = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    context = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    context = binding.activity
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method != "request") {
      result.notImplemented()
      return
    }

    val params = call.arguments as Map<String, Any>
    val key = params["csk"] as String
    val url = params["url"] as String
    val method = params["method"] as String
    @Suppress("UNCHECKED_CAST")
    val headers = params["headers"] as? Map<String, String>
    val body = params["body"] as? ByteArray

    request(key = key, url = url, method = method, headers = headers, body = body, result = result)
  }

  private fun request(
          key: String,
          url: String,
          method: String,
          headers: Map<String, String>?,
          body: ByteArray?,
          result: Result) {

    var version = ""
    context?.let {
      version = it.packageManager.getPackageInfo(it.packageName, 0).versionName
    }

    dataDomeSDK = DataDomeSDK
            .with(context!!.application, key, version)
            .backBehaviour(DataDomeSDK.BackBehaviour.BLOCKED)

    val builder = OkHttpClient.Builder()
    builder.addInterceptor(DataDomeInterceptor(context!!.application, dataDomeSDK))
    val client = builder.build()
    var requestBuilder = Request.Builder().url(url)
    if (headers != null) {
      requestBuilder = requestBuilder.headers(Headers.of(headers))
    }
    when (method) {
      "get" -> {
        requestBuilder = requestBuilder.get()
      }
      "delete" -> {
        requestBuilder = requestBuilder.delete()
      }
      "post" -> {
        requestBuilder = if (body != null) {
          requestBuilder.post(RequestBody.create(null, body))
        } else {
          requestBuilder.post(RequestBody.create(null, ByteArray(0)))
        }
      }
      "put" -> {
        requestBuilder = if (body != null) {
          requestBuilder.put(RequestBody.create(null, body))
        } else {
          requestBuilder.put(RequestBody.create(null, ByteArray(0)))
        }
      }
      "patch" -> {
        requestBuilder = if (body != null) {
          requestBuilder.patch(RequestBody.create(null, body))
        } else {
          requestBuilder.patch(RequestBody.create(null, ByteArray(0)))
        }
      }
      else -> {
        result.notImplemented()
        return
      }
    }

    client.newCall(requestBuilder.build()).enqueue(object : Callback {
      override fun onFailure(call: Call, e: IOException) {
        Handler(Looper.getMainLooper()).post {
          result.success(emptyMap<String, Any>())
        }
      }

      override fun onResponse(call: Call, response: Response) {
        val statusCode = response.code()
        val bytes = response.body()?.bytes()

        val newHeaders = HashMap<String, String>()
        val responseHeaders = response.headers()
        val headersNames = responseHeaders.names()
        for (name in headersNames) {
          val value = responseHeaders.get(name)
          if (value != null) {
            newHeaders[name] = value
          }
        }

        Handler(Looper.getMainLooper()).post {
          result.success(mapOf("code" to statusCode, "data" to bytes, "headers" to newHeaders))
        }
      }
    })
  }
}
