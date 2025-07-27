// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ai_edge_sdk/ai_edge_sdk.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isSupported test', (WidgetTester tester) async {
    final AiEdgeSdk plugin = AiEdgeSdk();
    try {
      final bool isSupported = await plugin.isSupported();
      // Should return a boolean value
      expect(isSupported, isA<bool>());
    } catch (e) {
      // Might throw on unsupported devices, which is expected
      expect(e, isA<Exception>());
    }
  });
}
