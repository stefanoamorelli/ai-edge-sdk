# AI Edge SDK for Flutter

Flutter plugin for [Google's AI Edge SDK](https://developer.android.com/ai/gemini-nano/ai-edge-sdk) - brings [Gemini Nano](https://developer.android.com/ai/gemini-nano) on-device AI to your Flutter apps.

[![Tests](https://img.shields.io/badge/tests-52%20passing-brightgreen)](test/)
[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen)](coverage/)
[![Platform](https://img.shields.io/badge/platform-Android%20only-orange)](android/)

[Gemini Nano](https://developer.android.com/ai/gemini-nano) brings Google's most efficient AI model directly to your device, enabling private, fast AI inference without internet connectivity. On-device AI represents the future of mobile computing, providing instant responses while keeping your data completely private.

> [!IMPORTANT]
> This is an experimental open-source project. The underlying [Google AI Edge SDK](https://developer.android.com/ai/gemini-nano/experimental) is in beta and APIs may change. Use at your own risk.

## Requirements

- Physical [Pixel 9 series](https://store.google.com/category/phones) device (Pixel 9, Pixel 9 Pro, Pixel 9 Pro XL, or Pixel 9 Pro Fold)
- Android with [AICore system module](https://developer.android.com/ai/aicore) installed
- [Flutter](https://flutter.dev) 3.0.0+

### Why So Restrictive?

[Gemini Nano](https://developer.android.com/ai/gemini-nano) requires specialized [NPU hardware](https://developer.android.com/ai/gemini-nano/experimental#device-requirements) only available in [Pixel 9 devices](https://support.google.com/pixelphone/answer/7158570). This case is part of [Google's experimental AI program](https://developer.android.com/ai/gemini-nano/experimental) - broader device support may come later.

## Installation

```yaml
dependencies:
  ai_edge_sdk: ^1.0.1
```

## Quick Start

```dart
import 'package:ai_edge_sdk/ai_edge_sdk.dart';

final sdk = AiEdgeSdk();

// Check if your device is supported
if (await sdk.isSupported()) {
  await sdk.initialize();
  
  final result = await sdk.generateContent('Rewrite this professionally: hey whats up');
  print(result.content);
} else {
  print('Sorry, requires Pixel 9 series device');
}
```

## Features

- **Device validation** - Automatic Pixel 9 series detection
- **Content generation** - Text completion and creative writing
- **Streaming responses** - Real-time token generation
- **Error handling** - Comprehensive exception management
- **Privacy-first** - All processing happens on-device

## Testing

**Cannot test with emulator.** You need a physical [Pixel 9](https://developer.android.com/ai/gemini-nano/experimental#device-requirements).

Run unit tests:
```bash
flutter test --coverage
```


## Example App

The `/example` folder contains a complete demo app that shows [device compatibility checking](https://developer.android.com/ai/gemini-nano/experimental#device-requirements) and error handling.

```bash
cd example
flutter run
# Shows device info and compatibility status
```


## Contributing

See [SECURITY.md](SECURITY.md) for security practices and reporting vulnerabilities.

## References

- [Google AI Edge SDK Documentation](https://developer.android.com/ai/gemini-nano/ai-edge-sdk)
- [Gemini Nano Experimental Access](https://developer.android.com/ai/gemini-nano/experimental)
- [Android AI Samples - Gemini Nano](https://github.com/android/ai-samples/tree/main/gemini-nano)
- [Flutter Plugin Development Guide](https://docs.flutter.dev/packages-and-plugins/developing-packages)
- [Android AICore Documentation](https://developer.android.com/ai/aicore)

## License

MIT - Copyright [Stefano Amorelli](https://amorelli.tech/) 2025 - see [LICENSE](LICENSE)
