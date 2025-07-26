import 'dart:async';
import 'ai_edge_sdk_platform_interface.dart';
import 'src/models/generation_result.dart';
import 'src/models/device_info.dart';
import 'src/exceptions/ai_edge_exceptions.dart';

export 'src/models/inference_config.dart';
export 'src/models/generation_result.dart';
export 'src/models/device_info.dart';
export 'src/exceptions/ai_edge_exceptions.dart';

class AiEdgeSdk {
  static final AiEdgeSdk _instance = AiEdgeSdk._internal();
  factory AiEdgeSdk() => _instance;
  AiEdgeSdk._internal();

  bool _isInitialized = false;

  /// Initialize the Gemini Nano model
  /// 
  /// This method enforces Pixel 9 series device requirement and throws
  /// [UnsupportedDeviceException] if called on non-Pixel 9 devices.
  /// Also throws [AiCoreUnavailableException] if AICore is not available.
  Future<bool> initialize({
    String modelName = 'gemini-nano',
    double temperature = 0.8,
    int topK = 40,
    double topP = 0.95,
    int maxOutputTokens = 1024,
  }) async {
    try {
      final result = await AiEdgeSdkPlatform.instance.initialize(
        modelName: modelName,
        temperature: temperature,
        topK: topK,
        topP: topP,
        maxOutputTokens: maxOutputTokens,
      );
      _isInitialized = result['success'] as bool;
      return _isInitialized;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  Future<GenerationResult> generateContent(String prompt) async {
    _ensureInitialized();
    
    final result = await AiEdgeSdkPlatform.instance.generateContent(prompt);
    return GenerationResult.fromMap(result);
  }

  Future<GenerationResult> generateContentStream(
    String prompt, {
    void Function(String chunk)? onChunk,
  }) async {
    _ensureInitialized();
    
    final result = await AiEdgeSdkPlatform.instance.generateContentStream(prompt);
    
    if (onChunk != null && result['chunks'] != null) {
      for (final chunk in result['chunks'] as List) {
        onChunk(chunk.toString());
      }
    }
    
    return GenerationResult.fromMap(result);
  }

  /// Check if the current device supports Gemini Nano
  /// 
  /// Returns true only if:
  /// 1. Device is Pixel 9 series
  /// 2. AICore is available
  Future<bool> isSupported() async {
    final result = await AiEdgeSdkPlatform.instance.isSupported();
    return result['isSupported'] as bool;
  }

  /// Get detailed device information and compatibility status
  Future<DeviceInfo> getDeviceInfo() async {
    final result = await AiEdgeSdkPlatform.instance.isSupported();
    return DeviceInfo.fromMap(result['deviceInfo'] as Map<String, dynamic>);
  }

  /// Check if device is Pixel 9 series (convenience method)
  Future<bool> isPixel9Series() async {
    final deviceInfo = await getDeviceInfo();
    return deviceInfo.isPixel9Series;
  }

  /// Check if AICore is available (convenience method)
  Future<bool> isAiCoreAvailable() async {
    final deviceInfo = await getDeviceInfo();
    return deviceInfo.isAiCoreAvailable;
  }

  Future<void> dispose() async {
    await AiEdgeSdkPlatform.instance.dispose();
    _isInitialized = false;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw InitializationException(
        'AiEdgeSdk not initialized. Call initialize() first.',
      );
    }
  }
}

class InitializationException implements Exception {
  final String message;
  InitializationException(this.message);
  
  @override
  String toString() => 'InitializationException: $message';
}