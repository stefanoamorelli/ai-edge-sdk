import 'ai_edge_sdk_android_only_platform_interface.dart';

class AiEdgeSdkAndroidOnly {
  Future<String?> getPlatformVersion() {
    return AiEdgeSdkAndroidOnlyPlatform.instance.getPlatformVersion();
  }
}
