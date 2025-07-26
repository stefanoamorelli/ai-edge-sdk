import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ai_edge_sdk_method_channel.dart';

abstract class AiEdgeSdkPlatform extends PlatformInterface {
  AiEdgeSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static AiEdgeSdkPlatform _instance = MethodChannelAiEdgeSdk();

  static AiEdgeSdkPlatform get instance => _instance;

  static set instance(AiEdgeSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<String, dynamic>> initialize({
    required String modelName,
    required double temperature,
    required int topK,
    required double topP,
    required int maxOutputTokens,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<Map<String, dynamic>> generateContent(String prompt) {
    throw UnimplementedError('generateContent() has not been implemented.');
  }

  Future<Map<String, dynamic>> generateContentStream(String prompt) {
    throw UnimplementedError('generateContentStream() has not been implemented.');
  }

  Future<Map<String, dynamic>> isSupported() {
    throw UnimplementedError('isSupported() has not been implemented.');
  }

  Future<void> dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}