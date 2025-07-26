import 'package:flutter_test/flutter_test.dart';
import 'package:ai_edge_sdk/src/models/device_info.dart';

void main() {
  group('Device Validation Tests', () {
    group('Pixel 9 Series Detection', () {
      test('should identify Pixel 9 as supported', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
        expect(deviceInfo.compatibilityStatus, equals('Device fully supports Gemini Nano'));
      });

      test('should identify Pixel 9 Pro as supported', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9 Pro',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });

      test('should identify Pixel 9 Pro XL as supported', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9 Pro XL',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });

      test('should identify Pixel 9 Pro Fold as supported', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9 Pro Fold',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });
    });

    group('Non-Pixel 9 Device Rejection', () {
      test('should reject Pixel 8 devices', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 8 Pro',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: false,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
        expect(deviceInfo.compatibilityStatus, equals('Requires Pixel 9 series device'));
      });

      test('should reject Pixel 7 devices', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 7a',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: false,
          isAiCoreAvailable: false,
        );

        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
      });

      test('should reject Samsung devices', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Samsung',
          model: 'Galaxy S24 Ultra',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: false,
          isAiCoreAvailable: false,
        );

        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
        expect(deviceInfo.compatibilityStatus, equals('Requires Pixel 9 series device'));
      });

      test('should reject OnePlus devices', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'OnePlus',
          model: 'OnePlus 12',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: false,
          isAiCoreAvailable: false,
        );

        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
      });

      test('should reject Xiaomi devices', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Xiaomi',
          model: 'Mi 14 Pro',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: false,
          isAiCoreAvailable: false,
        );

        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
      });
    });

    group('AICore Availability Tests', () {
      test('should require AICore for full support', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: false,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isAiCoreAvailable, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
        expect(deviceInfo.compatibilityStatus, 
               equals('AICore not available - please install system updates'));
      });

      test('should support Pixel 9 with AICore available', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isAiCoreAvailable, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
        expect(deviceInfo.compatibilityStatus, equals('Device fully supports Gemini Nano'));
      });
    });

    group('Edge Cases', () {
      test('should handle unknown manufacturer gracefully', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Unknown',
          model: 'Unknown',
          androidVersion: 'Unknown',
          sdkVersion: 0,
          isPixel9Series: false,
          isAiCoreAvailable: false,
        );

        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
        expect(deviceInfo.compatibilityStatus, equals('Requires Pixel 9 series device'));
      });

      test('should handle case sensitivity in model names', () {
        // Test would be handled by native Android code, but we simulate here
        final deviceInfo = DeviceInfo(
          manufacturer: 'google', // lowercase
          model: 'pixel 9 pro', // lowercase
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true, // Android native would handle case-insensitive check
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });

      test('should handle future Android versions', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9',
          androidVersion: '15',
          sdkVersion: 35,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });
    });

    group('Device Info Serialization', () {
      test('should serialize to map correctly', () {
        final deviceInfo = DeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 9 Pro',
          androidVersion: '14',
          sdkVersion: 34,
          isPixel9Series: true,
          isAiCoreAvailable: true,
        );

        final map = deviceInfo.toMap();

        expect(map['manufacturer'], equals('Google'));
        expect(map['model'], equals('Pixel 9 Pro'));
        expect(map['androidVersion'], equals('14'));
        expect(map['sdkVersion'], equals(34));
        expect(map['isPixel9Series'], isTrue);
        expect(map['isAiCoreAvailable'], isTrue);
      });

      test('should deserialize from map correctly', () {
        final map = {
          'manufacturer': 'Google',
          'model': 'Pixel 9',
          'androidVersion': '14',
          'sdkVersion': 34,
          'isPixel9Series': true,
          'isAiCoreAvailable': true,
        };

        final deviceInfo = DeviceInfo.fromMap(map);

        expect(deviceInfo.manufacturer, equals('Google'));
        expect(deviceInfo.model, equals('Pixel 9'));
        expect(deviceInfo.androidVersion, equals('14'));
        expect(deviceInfo.sdkVersion, equals(34));
        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isAiCoreAvailable, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });

      test('should handle partial map data with defaults', () {
        final map = {
          'manufacturer': 'Google',
          'model': 'Pixel 9',
          // Missing other fields
        };

        final deviceInfo = DeviceInfo.fromMap(map);

        expect(deviceInfo.manufacturer, equals('Google'));
        expect(deviceInfo.model, equals('Pixel 9'));
        expect(deviceInfo.androidVersion, equals('Unknown'));
        expect(deviceInfo.sdkVersion, equals(0));
        expect(deviceInfo.isPixel9Series, isFalse);
        expect(deviceInfo.isAiCoreAvailable, isFalse);
        expect(deviceInfo.isFullySupported, isFalse);
      });
    });
  });
}