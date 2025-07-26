import 'package:flutter_test/flutter_test.dart';
import 'package:ai_edge_sdk/ai_edge_sdk.dart';
import 'package:ai_edge_sdk/ai_edge_sdk_platform_interface.dart';
import 'package:ai_edge_sdk/ai_edge_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/services.dart';

class MockAiEdgeSdkPlatform
    with MockPlatformInterfaceMixin
    implements AiEdgeSdkPlatform {

  final Map<String, dynamic> _mockResponses = {};
  final List<String> _methodCalls = [];

  void setMockResponse(String method, dynamic response) {
    _mockResponses[method] = response;
  }

  void setMockError(String method, PlatformException error) {
    _mockResponses[method] = error;
  }

  List<String> get methodCalls => List.unmodifiable(_methodCalls);

  void clearCalls() {
    _methodCalls.clear();
  }

  @override
  Future<Map<String, dynamic>> initialize({
    required String modelName,
    required double temperature,
    required int topK,
    required double topP,
    required int maxOutputTokens,
  }) async {
    _methodCalls.add('initialize');
    final response = _mockResponses['initialize'];
    if (response is PlatformException) {
      // Convert to proper exception types
      if (response.code == 'UNSUPPORTED_DEVICE') {
        throw UnsupportedDeviceException(response.message ?? '', code: response.code);
      } else if (response.code == 'AICORE_UNAVAILABLE') {
        throw AiCoreUnavailableException(response.message ?? '', code: response.code);
      } else {
        throw InitializationException(response.message ?? '');
      }
    }
    return response ?? {'success': true, 'message': 'Mock initialized'};
  }

  @override
  Future<Map<String, dynamic>> generateContent(String prompt) async {
    _methodCalls.add('generateContent');
    final response = _mockResponses['generateContent'];
    if (response is PlatformException) {
      throw response;
    }
    return response ?? {
      'success': true,
      'content': 'Mock generated content for: $prompt',
      'finishReason': 'STOP'
    };
  }

  @override
  Future<Map<String, dynamic>> generateContentStream(String prompt) async {
    _methodCalls.add('generateContentStream');
    final response = _mockResponses['generateContentStream'];
    if (response is PlatformException) {
      throw response;
    }
    return response ?? {
      'success': true,
      'content': 'Mock stream content',
      'chunks': ['Mock ', 'stream ', 'content']
    };
  }

  @override
  Future<Map<String, dynamic>> isSupported() async {
    _methodCalls.add('isSupported');
    final response = _mockResponses['isSupported'];
    if (response is PlatformException) {
      throw response;
    }
    return response ?? {
      'isSupported': true,
      'deviceInfo': {
        'manufacturer': 'Google',
        'model': 'Pixel 9',
        'androidVersion': '14',
        'sdkVersion': 34,
        'isPixel9Series': true,
        'isAiCoreAvailable': true,
      }
    };
  }

  @override
  Future<void> dispose() async {
    _methodCalls.add('dispose');
    final response = _mockResponses['dispose'];
    if (response is PlatformException) {
      throw response;
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiEdgeSdk', () {
    late MockAiEdgeSdkPlatform mockPlatform;
    late AiEdgeSdk aiEdgeSdk;

    setUp(() {
      mockPlatform = MockAiEdgeSdkPlatform();
      AiEdgeSdkPlatform.instance = mockPlatform;
      aiEdgeSdk = AiEdgeSdk();
    });

    tearDown(() {
      mockPlatform.clearCalls();
    });

    test('should be singleton', () {
      final instance1 = AiEdgeSdk();
      final instance2 = AiEdgeSdk();
      expect(identical(instance1, instance2), isTrue);
    });

    group('initialization', () {
      test('should initialize successfully with default parameters', () async {
        mockPlatform.setMockResponse('initialize', {
          'success': true,
          'message': 'Model initialized successfully'
        });

        final result = await aiEdgeSdk.initialize();

        expect(result, isTrue);
        expect(mockPlatform.methodCalls, contains('initialize'));
      });

      test('should initialize with custom parameters', () async {
        mockPlatform.setMockResponse('initialize', {
          'success': true,
          'message': 'Model initialized successfully'
        });

        final result = await aiEdgeSdk.initialize(
          modelName: 'custom-model',
          temperature: 0.5,
          topK: 20,
          topP: 0.8,
          maxOutputTokens: 512,
        );

        expect(result, isTrue);
      });

      test('should throw UnsupportedDeviceException for non-Pixel 9 devices', () async {
        mockPlatform.setMockError('initialize', 
          PlatformException(
            code: 'UNSUPPORTED_DEVICE',
            message: 'Gemini Nano is only available on Pixel 9 series devices',
          )
        );

        expect(
          () => aiEdgeSdk.initialize(),
          throwsA(isA<UnsupportedDeviceException>()),
        );
      });

      test('should throw AiCoreUnavailableException when AICore is missing', () async {
        mockPlatform.setMockError('initialize',
          PlatformException(
            code: 'AICORE_UNAVAILABLE',
            message: 'AICore is not available on this device',
          )
        );

        expect(
          () => aiEdgeSdk.initialize(),
          throwsA(isA<AiCoreUnavailableException>()),
        );
      });

      test('should throw InitializationException for other errors', () async {
        mockPlatform.setMockError('initialize',
          PlatformException(
            code: 'UNKNOWN_ERROR',
            message: 'Something went wrong',
          )
        );

        expect(
          () => aiEdgeSdk.initialize(),
          throwsA(isA<InitializationException>()),
        );
      });
    });

    group('content generation', () {
      setUp(() async {
        mockPlatform.setMockResponse('initialize', {
          'success': true,
          'message': 'Model initialized successfully'
        });
        await aiEdgeSdk.initialize();
      });

      test('should generate content successfully', () async {
        const prompt = 'Test prompt';
        mockPlatform.setMockResponse('generateContent', {
          'success': true,
          'content': 'Generated response',
          'finishReason': 'STOP'
        });

        final result = await aiEdgeSdk.generateContent(prompt);

        expect(result.success, isTrue);
        expect(result.content, equals('Generated response'));
        expect(result.finishReason, equals('STOP'));
      });

      test('should throw exception when not initialized', () async {
        final uninitializedSdk = AiEdgeSdk();
        // Reset initialization state
        await uninitializedSdk.dispose();

        expect(
          () => uninitializedSdk.generateContent('test'),
          throwsA(isA<InitializationException>()),
        );
      });

      test('should generate content stream successfully', () async {
        const prompt = 'Stream test';
        final chunks = <String>[];
        
        mockPlatform.setMockResponse('generateContentStream', {
          'success': true,
          'content': 'Full stream content',
          'chunks': ['Full ', 'stream ', 'content']
        });

        final result = await aiEdgeSdk.generateContentStream(
          prompt,
          onChunk: (chunk) => chunks.add(chunk),
        );

        expect(result.success, isTrue);
        expect(result.content, equals('Full stream content'));
        expect(chunks, equals(['Full ', 'stream ', 'content']));
      });
    });

    group('device support', () {
      test('should check if device is supported', () async {
        mockPlatform.setMockResponse('isSupported', {
          'isSupported': true,
          'deviceInfo': {
            'manufacturer': 'Google',
            'model': 'Pixel 9 Pro',
            'androidVersion': '14',
            'sdkVersion': 34,
            'isPixel9Series': true,
            'isAiCoreAvailable': true,
          }
        });

        final isSupported = await aiEdgeSdk.isSupported();
        expect(isSupported, isTrue);
      });

      test('should return false for unsupported devices', () async {
        mockPlatform.setMockResponse('isSupported', {
          'isSupported': false,
          'deviceInfo': {
            'manufacturer': 'Samsung',
            'model': 'Galaxy S24',
            'androidVersion': '14',
            'sdkVersion': 34,
            'isPixel9Series': false,
            'isAiCoreAvailable': false,
          }
        });

        final isSupported = await aiEdgeSdk.isSupported();
        expect(isSupported, isFalse);
      });

      test('should get device info correctly', () async {
        mockPlatform.setMockResponse('isSupported', {
          'isSupported': true,
          'deviceInfo': {
            'manufacturer': 'Google',
            'model': 'Pixel 9 Pro XL',
            'androidVersion': '15',
            'sdkVersion': 35,
            'isPixel9Series': true,
            'isAiCoreAvailable': true,
          }
        });

        final deviceInfo = await aiEdgeSdk.getDeviceInfo();
        
        expect(deviceInfo.manufacturer, equals('Google'));
        expect(deviceInfo.model, equals('Pixel 9 Pro XL'));
        expect(deviceInfo.androidVersion, equals('15'));
        expect(deviceInfo.sdkVersion, equals(35));
        expect(deviceInfo.isPixel9Series, isTrue);
        expect(deviceInfo.isAiCoreAvailable, isTrue);
        expect(deviceInfo.isFullySupported, isTrue);
      });

      test('should check Pixel 9 series specifically', () async {
        mockPlatform.setMockResponse('isSupported', {
          'isSupported': false,
          'deviceInfo': {
            'manufacturer': 'Google',
            'model': 'Pixel 8 Pro',
            'androidVersion': '14',
            'sdkVersion': 34,
            'isPixel9Series': false,
            'isAiCoreAvailable': true,
          }
        });

        final isPixel9 = await aiEdgeSdk.isPixel9Series();
        expect(isPixel9, isFalse);
      });

      test('should check AICore availability', () async {
        mockPlatform.setMockResponse('isSupported', {
          'isSupported': false,
          'deviceInfo': {
            'manufacturer': 'Google',
            'model': 'Pixel 9',
            'androidVersion': '14',
            'sdkVersion': 34,
            'isPixel9Series': true,
            'isAiCoreAvailable': false,
          }
        });

        final isAiCoreAvailable = await aiEdgeSdk.isAiCoreAvailable();
        expect(isAiCoreAvailable, isFalse);
      });
    });

    group('resource management', () {
      test('should dispose resources', () async {
        await aiEdgeSdk.dispose();
        expect(mockPlatform.methodCalls, contains('dispose'));
      });

      test('should reset initialization state after dispose', () async {
        mockPlatform.setMockResponse('initialize', {
          'success': true,
          'message': 'Model initialized successfully'
        });
        
        await aiEdgeSdk.initialize();
        await aiEdgeSdk.dispose();

        expect(
          () => aiEdgeSdk.generateContent('test'),
          throwsA(isA<InitializationException>()),
        );
      });
    });
  });

  group('DeviceInfo', () {
    test('should create from map correctly', () {
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
      expect(deviceInfo.isPixel9Series, isTrue);
      expect(deviceInfo.isAiCoreAvailable, isTrue);
      expect(deviceInfo.isFullySupported, isTrue);
    });

    test('should handle missing values with defaults', () {
      final deviceInfo = DeviceInfo.fromMap({});

      expect(deviceInfo.manufacturer, equals('Unknown'));
      expect(deviceInfo.model, equals('Unknown'));
      expect(deviceInfo.androidVersion, equals('Unknown'));
      expect(deviceInfo.sdkVersion, equals(0));
      expect(deviceInfo.isPixel9Series, isFalse);
      expect(deviceInfo.isAiCoreAvailable, isFalse);
      expect(deviceInfo.isFullySupported, isFalse);
    });

    test('should provide correct compatibility status', () {
      // Fully supported
      final supported = DeviceInfo(
        manufacturer: 'Google',
        model: 'Pixel 9',
        androidVersion: '14',
        sdkVersion: 34,
        isPixel9Series: true,
        isAiCoreAvailable: true,
      );
      expect(supported.compatibilityStatus, equals('Device fully supports Gemini Nano'));

      // Not Pixel 9
      final notPixel9 = DeviceInfo(
        manufacturer: 'Samsung',
        model: 'Galaxy S24',
        androidVersion: '14',
        sdkVersion: 34,
        isPixel9Series: false,
        isAiCoreAvailable: true,
      );
      expect(notPixel9.compatibilityStatus, equals('Requires Pixel 9 series device'));

      // No AICore
      final noAiCore = DeviceInfo(
        manufacturer: 'Google',
        model: 'Pixel 9',
        androidVersion: '14',
        sdkVersion: 34,
        isPixel9Series: true,
        isAiCoreAvailable: false,
      );
      expect(noAiCore.compatibilityStatus, equals('AICore not available - please install system updates'));
    });
  });

  group('GenerationResult', () {
    test('should create from map correctly', () {
      final map = {
        'success': true,
        'content': 'Test content',
        'finishReason': 'STOP',
        'chunks': ['Test ', 'content']
      };

      final result = GenerationResult.fromMap(map);

      expect(result.success, isTrue);
      expect(result.content, equals('Test content'));
      expect(result.finishReason, equals('STOP'));
      expect(result.chunks, equals(['Test ', 'content']));
    });

    test('should handle missing values', () {
      final result = GenerationResult.fromMap({});

      expect(result.success, isFalse);
      expect(result.content, equals(''));
      expect(result.finishReason, isNull);
      expect(result.chunks, isNull);
    });
  });

  group('MethodChannelAiEdgeSdk', () {
    late MethodChannelAiEdgeSdk methodChannel;
    
    setUp(() {
      methodChannel = MethodChannelAiEdgeSdk();
    });

    test('should be the default platform instance', () {
      // Reset to default instance for this test
      AiEdgeSdkPlatform.instance = MethodChannelAiEdgeSdk();
      expect(AiEdgeSdkPlatform.instance, isInstanceOf<MethodChannelAiEdgeSdk>());
      // Restore mock for other tests  
      // Note: mockPlatform is defined in the outer scope
    });
  });
}