import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ai_edge_sdk_platform_interface.dart';
import 'src/exceptions/ai_edge_exceptions.dart';

/// MethodChannel-based implementation of [AiEdgeSdkPlatform].
class MethodChannelAiEdgeSdk extends AiEdgeSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('ai_edge_sdk');

  @override
  Future<Map<String, dynamic>> initialize({
    required String modelName,
    required double temperature,
    required int topK,
    required double topP,
    required int maxOutputTokens,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'initialize',
        {
          'modelName': modelName,
          'temperature': temperature,
          'topK': topK,
          'topP': topP,
          'maxOutputTokens': maxOutputTokens,
        },
      );
      return Map<String, dynamic>.from(result ?? {});
    } on PlatformException catch (e) {
      if (e.code == 'UNSUPPORTED_DEVICE') {
        throw UnsupportedDeviceException(
          e.message ?? 'Device not supported for Gemini Nano',
          code: e.code,
          details: e.details,
        );
      } else if (e.code == 'AICORE_UNAVAILABLE') {
        throw AiCoreUnavailableException(
          e.message ?? 'AICore not available',
          code: e.code,
          details: e.details,
        );
      }
      throw InitializationException(
        e.message ?? 'Failed to initialize model',
        code: e.code,
        details: e.details,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> generateContent(String prompt) async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'generateContent',
        {'prompt': prompt},
      );
      return Map<String, dynamic>.from(result ?? {});
    } on PlatformException catch (e) {
      if (e.code == 'NOT_INITIALIZED') {
        throw InitializationException(e.message ?? 'Model not initialized');
      }
      throw GenerationException(
        e.message ?? 'Failed to generate content',
        code: e.code,
        details: e.details,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> generateContentStream(String prompt) async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'generateContentStream',
        {'prompt': prompt},
      );
      return Map<String, dynamic>.from(result ?? {});
    } on PlatformException catch (e) {
      if (e.code == 'NOT_INITIALIZED') {
        throw InitializationException(e.message ?? 'Model not initialized');
      }
      throw StreamException(
        e.message ?? 'Failed to generate content stream',
        code: e.code,
        details: e.details,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> isSupported() async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'isSupported',
      );
      return Map<String, dynamic>.from(result ?? {});
    } on PlatformException catch (e) {
      throw UnsupportedDeviceException(
        e.message ?? 'Failed to check device support',
        code: e.code,
        details: e.details,
      );
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await methodChannel.invokeMethod('dispose');
    } on PlatformException catch (e) {
      throw InitializationException(
        e.message ?? 'Failed to dispose resources',
        code: e.code,
        details: e.details,
      );
    }
  }
}
