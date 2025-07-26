import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ai_edge_sdk_android_only_platform_interface.dart';

/// An implementation of [AiEdgeSdkAndroidOnlyPlatform] that uses method channels.
class MethodChannelAiEdgeSdkAndroidOnly extends AiEdgeSdkAndroidOnlyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ai_edge_sdk_android_only');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
