import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_edge_sdk/ai_edge_sdk_method_channel.dart';
import 'package:ai_edge_sdk/src/exceptions/ai_edge_exceptions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelAiEdgeSdk', () {
    late MethodChannelAiEdgeSdk platform;
    late List<MethodCall> methodCalls;

    setUp(() {
      platform = MethodChannelAiEdgeSdk();
      methodCalls = <MethodCall>[];
      
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(platform.methodChannel, (call) async {
        methodCalls.add(call);
        
        switch (call.method) {
          case 'initialize':
            return {
              'success': true,
              'message': 'Model initialized successfully'
            };
          case 'generateContent':
            return {
              'success': true,
              'content': 'Generated content for: ${call.arguments['prompt']}',
              'finishReason': 'STOP'
            };
          case 'generateContentStream':
            return {
              'success': true,
              'content': 'Stream content',
              'chunks': ['Stream ', 'content']
            };
          case 'isSupported':
            return {
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
          case 'dispose':
            return null;
          default:
            throw PlatformException(
              code: 'UNIMPLEMENTED',
              message: 'Method ${call.method} not implemented',
            );
        }
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(platform.methodChannel, null);
      methodCalls.clear();
    });

    group('initialize', () {
      test('should call native initialize with correct parameters', () async {
        final result = await platform.initialize(
          modelName: 'gemini-nano',
          temperature: 0.8,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        );

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('initialize'));
        expect(methodCalls.first.arguments, equals({
          'modelName': 'gemini-nano',
          'temperature': 0.8,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        }));
        expect(result['success'], isTrue);
      });

      test('should throw UnsupportedDeviceException for unsupported device', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'UNSUPPORTED_DEVICE',
            message: 'Device not supported',
            details: {'manufacturer': 'Samsung', 'model': 'Galaxy S24'},
          );
        });

        expect(
          () => platform.initialize(
            modelName: 'gemini-nano',
            temperature: 0.8,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 1024,
          ),
          throwsA(isA<UnsupportedDeviceException>()
              .having((e) => e.message, 'message', contains('Device not supported'))
              .having((e) => e.code, 'code', equals('UNSUPPORTED_DEVICE'))),
        );
      });

      test('should throw AiCoreUnavailableException when AICore missing', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'AICORE_UNAVAILABLE',
            message: 'AICore not available',
          );
        });

        expect(
          () => platform.initialize(
            modelName: 'gemini-nano',
            temperature: 0.8,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 1024,
          ),
          throwsA(isA<AiCoreUnavailableException>()
              .having((e) => e.message, 'message', contains('AICore not available'))
              .having((e) => e.code, 'code', equals('AICORE_UNAVAILABLE'))),
        );
      });

      test('should throw InitializationException for other errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'UNKNOWN_ERROR',
            message: 'Unknown error occurred',
          );
        });

        expect(
          () => platform.initialize(
            modelName: 'gemini-nano',
            temperature: 0.8,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 1024,
          ),
          throwsA(isA<InitializationException>()
              .having((e) => e.code, 'code', equals('UNKNOWN_ERROR'))),
        );
      });
    });

    group('generateContent', () {
      test('should call native generateContent with prompt', () async {
        const prompt = 'Test prompt';
        final result = await platform.generateContent(prompt);

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('generateContent'));
        expect(methodCalls.first.arguments, equals({'prompt': prompt}));
        expect(result['success'], isTrue);
        expect(result['content'], contains(prompt));
      });

      test('should throw InitializationException when not initialized', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'NOT_INITIALIZED',
            message: 'Model not initialized',
          );
        });

        expect(
          () => platform.generateContent('test'),
          throwsA(isA<InitializationException>()
              .having((e) => e.message, 'message', contains('Model not initialized'))),
        );
      });

      test('should throw GenerationException for generation errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'GENERATION_ERROR',
            message: 'Failed to generate content',
          );
        });

        expect(
          () => platform.generateContent('test'),
          throwsA(isA<GenerationException>()
              .having((e) => e.code, 'code', equals('GENERATION_ERROR'))),
        );
      });
    });

    group('generateContentStream', () {
      test('should call native generateContentStream with prompt', () async {
        const prompt = 'Stream test';
        final result = await platform.generateContentStream(prompt);

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('generateContentStream'));
        expect(methodCalls.first.arguments, equals({'prompt': prompt}));
        expect(result['success'], isTrue);
        expect(result['chunks'], isA<List>());
      });

      test('should throw StreamException for stream errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'STREAM_ERROR',
            message: 'Failed to generate content stream',
          );
        });

        expect(
          () => platform.generateContentStream('test'),
          throwsA(isA<StreamException>()
              .having((e) => e.code, 'code', equals('STREAM_ERROR'))),
        );
      });
    });

    group('isSupported', () {
      test('should call native isSupported method', () async {
        final result = await platform.isSupported();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('isSupported'));
        expect(result['isSupported'], isTrue);
        expect(result['deviceInfo'], isA<Map>());
        expect(result['deviceInfo']['manufacturer'], equals('Google'));
        expect(result['deviceInfo']['isPixel9Series'], isTrue);
      });

      test('should throw UnsupportedDeviceException for support check errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'SUPPORT_CHECK_ERROR',
            message: 'Failed to check support',
          );
        });

        expect(
          () => platform.isSupported(),
          throwsA(isA<UnsupportedDeviceException>()
              .having((e) => e.code, 'code', equals('SUPPORT_CHECK_ERROR'))),
        );
      });
    });

    group('dispose', () {
      test('should call native dispose method', () async {
        await platform.dispose();

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, equals('dispose'));
      });

      test('should throw InitializationException for dispose errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(platform.methodChannel, (call) async {
          throw PlatformException(
            code: 'DISPOSE_ERROR',
            message: 'Failed to dispose',
          );
        });

        expect(
          () => platform.dispose(),
          throwsA(isA<InitializationException>()
              .having((e) => e.code, 'code', equals('DISPOSE_ERROR'))),
        );
      });
    });
  });
}