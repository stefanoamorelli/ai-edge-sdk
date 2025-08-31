/// Device information and compatibility details for Gemini Nano.
class DeviceInfo {
  final String manufacturer;
  final String model;
  final String androidVersion;
  final int sdkVersion;
  final bool isPixel9Series;
  final bool isAiCoreAvailable;

  DeviceInfo({
    required this.manufacturer,
    required this.model,
    required this.androidVersion,
    required this.sdkVersion,
    required this.isPixel9Series,
    required this.isAiCoreAvailable,
  });

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      manufacturer: map['manufacturer'] ?? 'Unknown',
      model: map['model'] ?? 'Unknown',
      androidVersion: map['androidVersion'] ?? 'Unknown',
      sdkVersion: map['sdkVersion'] ?? 0,
      isPixel9Series: map['isPixel9Series'] ?? false,
      isAiCoreAvailable: map['isAiCoreAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'androidVersion': androidVersion,
      'sdkVersion': sdkVersion,
      'isPixel9Series': isPixel9Series,
      'isAiCoreAvailable': isAiCoreAvailable,
    };
  }

  /// Returns true if this device meets all requirements for Gemini Nano
  bool get isFullySupported => isPixel9Series && isAiCoreAvailable;

  /// Returns a user-friendly description of device compatibility
  String get compatibilityStatus {
    if (isFullySupported) {
      return 'Device fully supports Gemini Nano';
    } else if (!isPixel9Series) {
      return 'Requires Pixel 9 series device';
    } else if (!isAiCoreAvailable) {
      return 'AICore not available - please install system updates';
    } else {
      return 'Device not supported';
    }
  }

  @override
  String toString() {
    return 'DeviceInfo(manufacturer: $manufacturer, model: $model, '
           'androidVersion: $androidVersion, sdkVersion: $sdkVersion, '
           'isPixel9Series: $isPixel9Series, isAiCoreAvailable: $isAiCoreAvailable)';
  }
}
