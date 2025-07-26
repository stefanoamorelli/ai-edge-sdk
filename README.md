# AI Edge SDK for Flutter

Flutter plugin for Google's AI Edge SDK - brings Gemini Nano on-device AI to your Flutter apps.

[![Tests](https://img.shields.io/badge/tests-52%20passing-brightgreen)](test/)
[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen)](coverage/)
[![Platform](https://img.shields.io/badge/platform-Android%20only-orange)](android/)

## ![IMPORTANT](https://img.shields.io/badge/IMPORTANT-red?style=for-the-badge) Limitations

- **Pixel 9 series ONLY** - Will not work on any other device
- **No emulator support** - Requires physical Pixel 9 hardware
- **Experimental** - Not ready for production use
- **Android only** - No iOS support

## Requirements

- Physical Pixel 9, Pixel 9 Pro, Pixel 9 Pro XL, or Pixel 9 Pro Fold
- Android with AICore system module installed
- Flutter 3.0.0+

## Installation

```yaml
dependencies:
  ai_edge_sdk: ^1.0.0
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

## Testing

**Cannot test with emulator.** You need a physical Pixel 9.

Run unit tests:
```bash
flutter test --coverage
```

**Test Results:**
- ✅ 52 tests passing
- ✅ 100% code coverage
- ✅ All device validation scenarios
- ✅ Error handling & exceptions

## Example App

The `/example` folder contains a complete demo app that shows device compatibility checking and error handling.

```bash
cd example
flutter run
# Shows device info and compatibility status
```

## Why So Restrictive?

Gemini Nano requires specialized NPU hardware only available in Pixel 9 devices. This is Google's experimental AI program - broader device support may come later.

## Contributing

See [SECURITY.md](SECURITY.md) for security practices and reporting vulnerabilities.

## License

MIT - Copyright Stefano Amorelli 2025 - see [LICENSE.md](LICENSE.md)