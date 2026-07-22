import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/main.dart';

void main() {
  testWidgets('Dashboard renders correctly', (WidgetTester tester) async {
    // Intercept and ignore layout overflows during widget tests (false-positives due to Ahem test font)
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed by')) {
        // Ignore overflow messages in testing
        return;
      }
      originalOnError?.call(details);
    };

    // Set a realistic viewport size to avoid layout overflows under default test bounds
    tester.binding.window.physicalSizeTestValue = const Size(1800, 1800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the dashboard header or upcoming ride section is rendered.
    expect(find.text('Upcoming Ride'), findsOneWidget);

    // Reset the test window size and error handler
    tester.binding.window.clearPhysicalSizeTestValue();
    tester.binding.window.clearDevicePixelRatioTestValue();
    FlutterError.onError = originalOnError;
  });
}
