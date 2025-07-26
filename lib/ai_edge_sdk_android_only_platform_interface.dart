import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ai_edge_sdk_android_only_method_channel.dart';

abstract class AiEdgeSdkAndroidOnlyPlatform extends PlatformInterface {
  /// Constructs a AiEdgeSdkAndroidOnlyPlatform.
  AiEdgeSdkAndroidOnlyPlatform() : super(token: _token);

  static final Object _token = Object();

  static AiEdgeSdkAndroidOnlyPlatform _instance = MethodChannelAiEdgeSdkAndroidOnly();

  /// The default instance of [AiEdgeSdkAndroidOnlyPlatform] to use.
  ///
  /// Defaults to [MethodChannelAiEdgeSdkAndroidOnly].
  static AiEdgeSdkAndroidOnlyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AiEdgeSdkAndroidOnlyPlatform] when
  /// they register themselves.
  static set instance(AiEdgeSdkAndroidOnlyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
