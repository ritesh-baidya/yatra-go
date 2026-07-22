import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/pages/shared/welcome_page.dart';

void main() {
  testWidgets('LoginPage renders custom keypad and processes key taps',
      (WidgetTester tester) async {
    // Intercept and ignore layout overflows during widget tests (false-positives due to Ahem test font)
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed by')) {
        return;
      }
      originalOnError?.call(details);
    };

    // Set viewport size
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Verify text field initially empty/hint text is displayed
    final phoneFieldFinder = find.byType(TextField);
    expect(phoneFieldFinder, findsOneWidget);
    TextField phoneField = tester.widget<TextField>(phoneFieldFinder);
    expect(phoneField.controller?.text, '');

    // Focus the text field to make the keypad appear
    await tester.tap(phoneFieldFinder);
    await tester.pumpAndSettle();

    // Verify keypad digit '9' is present now
    final key9 = find.text('9');
    expect(key9, findsOneWidget);

    // Tap digit '9'
    await tester.tap(key9);
    await tester.pumpAndSettle();

    // Verify text field now has '9'
    phoneField = tester.widget<TextField>(phoneFieldFinder);
    expect(phoneField.controller?.text, '9');

    // Tap digit '8'
    final key8 = find.text('8');
    await tester.tap(key8);
    await tester.pumpAndSettle();

    // Verify text field now has '98'
    phoneField = tester.widget<TextField>(phoneFieldFinder);
    expect(phoneField.controller?.text, '98');

    // Tap delete key (Icons.backspace_rounded)
    final deleteKey = find.byIcon(Icons.backspace_rounded);
    expect(deleteKey, findsOneWidget);
    await tester.tap(deleteKey);
    await tester.pumpAndSettle();

    // Verify text field back to '9'
    phoneField = tester.widget<TextField>(phoneFieldFinder);
    expect(phoneField.controller?.text, '9');

    // Tap digit '8' again to have '98'
    await tester.tap(key8);
    await tester.pumpAndSettle();

    // Long press delete key to clear everything
    await tester.longPress(deleteKey);
    await tester.pumpAndSettle();

    // Verify text field is cleared
    phoneField = tester.widget<TextField>(phoneFieldFinder);
    expect(phoneField.controller?.text, '');

    // Reset physical size and error handler
    tester.binding.window.clearPhysicalSizeTestValue();
    tester.binding.window.clearDevicePixelRatioTestValue();
    FlutterError.onError = originalOnError;
  });
}
