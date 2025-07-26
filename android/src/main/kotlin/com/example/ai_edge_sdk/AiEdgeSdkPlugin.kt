package com.example.ai_edge_sdk

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.google.android.ai.edge.generativeai.GenerativeModel
import com.google.android.ai.edge.generativeai.InferenceConfig
import com.google.android.ai.edge.generativeai.Content
import com.google.android.ai.edge.generativeai.TextPart
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.coroutines.flow.collect

class AiEdgeSdkPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var generativeModel: GenerativeModel? = null
  private val scope = CoroutineScope(Dispatchers.Main)

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ai_edge_sdk")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "initialize" -> initializeModel(call, result)
      "generateContent" -> generateContent(call, result)
      "generateContentStream" -> generateContentStream(call, result)
      "isSupported" -> checkSupport(result)
      "dispose" -> disposeModel(result)
      else -> result.notImplemented()
    }
  }

  private fun initializeModel(call: MethodCall, result: Result) {
    scope.launch {
      try {
        // Enforce Pixel 9 series requirement
        if (!isPixel9Device()) {
          result.error(
            "UNSUPPORTED_DEVICE",
            "Gemini Nano is only available on Pixel 9 series devices. Current device: ${android.os.Build.MANUFACTURER} ${android.os.Build.MODEL}",
            mapOf(
              "manufacturer" to android.os.Build.MANUFACTURER,
              "model" to android.os.Build.MODEL,
              "requiredDevice" to "Pixel 9 series"
            )
          )
          return@launch
        }
        
        // Check AICore availability
        if (!GenerativeModel.isAvailable(context)) {
          result.error(
            "AICORE_UNAVAILABLE",
            "AICore is not available on this device. Please ensure AICore is installed and up to date.",
            mapOf(
              "device" to "${android.os.Build.MANUFACTURER} ${android.os.Build.MODEL}",
              "androidVersion" to android.os.Build.VERSION.RELEASE
            )
          )
          return@launch
        }
        
        val modelName = call.argument<String>("modelName") ?: "gemini-nano"
        val temperature = call.argument<Double>("temperature") ?: 0.8
        val topK = call.argument<Int>("topK") ?: 40
        val topP = call.argument<Double>("topP") ?: 0.95
        val maxOutputTokens = call.argument<Int>("maxOutputTokens") ?: 1024

        generativeModel = GenerativeModel(
          model = modelName,
          context = context,
          inferenceConfig = InferenceConfig(
            temperature = temperature.toFloat(),
            topK = topK,
            topP = topP.toFloat(),
            maxOutputTokens = maxOutputTokens
          )
        )
        
        result.success(mapOf(
          "success" to true,
          "message" to "Model initialized successfully"
        ))
      } catch (e: Exception) {
        result.error(
          "INITIALIZATION_ERROR",
          e.message ?: "Failed to initialize model",
          mapOf("exception" to e.toString())
        )
      }
    }
  }

  private fun generateContent(call: MethodCall, result: Result) {
    val prompt = call.argument<String>("prompt")
    if (prompt == null) {
      result.error("INVALID_ARGUMENT", "Prompt cannot be null", null)
      return
    }

    if (generativeModel == null) {
      result.error("NOT_INITIALIZED", "Model not initialized. Call initialize first.", null)
      return
    }

    scope.launch {
      try {
        val content = withContext(Dispatchers.IO) {
          generativeModel!!.generateContent(prompt)
        }
        
        result.success(mapOf(
          "success" to true,
          "content" to content.text,
          "finishReason" to content.candidates.firstOrNull()?.finishReason?.name
        ))
      } catch (e: Exception) {
        result.error(
          "GENERATION_ERROR",
          e.message ?: "Failed to generate content",
          mapOf("exception" to e.toString())
        )
      }
    }
  }

  private fun generateContentStream(call: MethodCall, result: Result) {
    val prompt = call.argument<String>("prompt")
    if (prompt == null) {
      result.error("INVALID_ARGUMENT", "Prompt cannot be null", null)
      return
    }

    if (generativeModel == null) {
      result.error("NOT_INITIALIZED", "Model not initialized. Call initialize first.", null)
      return
    }

    scope.launch {
      try {
        val chunks = mutableListOf<String>()
        
        withContext(Dispatchers.IO) {
          generativeModel!!.generateContentStream(prompt).collect { chunk ->
            chunks.add(chunk.text ?: "")
          }
        }
        
        result.success(mapOf(
          "success" to true,
          "content" to chunks.joinToString(""),
          "chunks" to chunks
        ))
      } catch (e: Exception) {
        result.error(
          "STREAM_ERROR",
          e.message ?: "Failed to generate content stream",
          mapOf("exception" to e.toString())
        )
      }
    }
  }

  private fun checkSupport(result: Result) {
    scope.launch {
      try {
        val isPixel9Series = isPixel9Device()
        val isAICoreAvailable = GenerativeModel.isAvailable(context)
        val isSupported = isPixel9Series && isAICoreAvailable
        
        result.success(mapOf(
          "isSupported" to isSupported,
          "deviceInfo" to mapOf(
            "manufacturer" to android.os.Build.MANUFACTURER,
            "model" to android.os.Build.MODEL,
            "androidVersion" to android.os.Build.VERSION.RELEASE,
            "sdkVersion" to android.os.Build.VERSION.SDK_INT,
            "isPixel9Series" to isPixel9Series,
            "isAICoreAvailable" to isAICoreAvailable
          )
        ))
      } catch (e: Exception) {
        result.error(
          "SUPPORT_CHECK_ERROR",
          e.message ?: "Failed to check support",
          mapOf("exception" to e.toString())
        )
      }
    }
  }
  
  private fun isPixel9Device(): Boolean {
    val manufacturer = android.os.Build.MANUFACTURER.lowercase()
    val model = android.os.Build.MODEL.lowercase()
    
    return manufacturer == "google" && (
      model.contains("pixel 9") ||
      model.contains("pixel9") ||
      model == "gkws6" ||  // Pixel 9
      model == "tokay" ||   // Pixel 9 Pro
      model == "caiman" ||  // Pixel 9 Pro XL
      model == "komodo"     // Pixel 9 Pro Fold
    )
  }

  private fun disposeModel(result: Result) {
    generativeModel = null
    result.success(true)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    generativeModel = null
  }
}