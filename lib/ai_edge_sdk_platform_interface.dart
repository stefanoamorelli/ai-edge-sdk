import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ai_edge_sdk_method_channel.dart';

/// Platform interface for the AI Edge SDK plugin.
///
/// Implementations provide concrete platform-specific behavior. By default,
/// this uses a [MethodChannel]-based implementation.
abstract class AiEdgeSdkPlatform extends PlatformInterface {
  AiEdgeSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static AiEdgeSdkPlatform _instance = MethodChannelAiEdgeSdk();

  static AiEdgeSdkPlatform get instance => _instance;

  static set instance(AiEdgeSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initialize the on-device model with the provided inference parameters.
  Future<Map<String, dynamic>> initialize({
    required String modelName,
    required double temperature,
    required int topK,
    required double topP,
    required int maxOutputTokens,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Generate a single response for the given [prompt].
  Future<Map<String, dynamic>> generateContent(String prompt) {
    throw UnimplementedError('generateContent() has not been implemented.');
  }

  /// Generate a response for the given [prompt] with streamed chunks.
  Future<Map<String, dynamic>> generateContentStream(String prompt) {
    throw UnimplementedError(
        'generateContentStream() has not been implemented.');
  }

  /// Return device support metadata and compatibility information.
  Future<Map<String, dynamic>> isSupported() {
    throw UnimplementedError('isSupported() has not been implemented.');
  }

  /// Dispose any native resources.
  Future<void> dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
