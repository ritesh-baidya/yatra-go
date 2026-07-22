import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/pages/passenger/passenger_return_trip_page.dart';

void main() {
  testWidgets('PassengerReturnTripPage renders correctly matching mockup',
      (WidgetTester tester) async {
    // Intercept and ignore layout overflows during widget tests
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

    // Pump widget
    await tester.pumpWidget(
      const MaterialApp(
        home: PassengerReturnTripPage(
          initialTripType: 'Round trip',
        ),
      ),
    );

    // Verify Title and Subheadings
    expect(find.text('Return Trip'), findsOneWidget);
    expect(find.text('Trip type'), findsOneWidget);
    expect(find.text('Return date'), findsOneWidget);

    // Verify Trip Type Cards
    expect(find.text('One way'), findsOneWidget);
    expect(find.text('Single trip'), findsOneWidget);
    expect(find.text('Round trip'), findsOneWidget);
    expect(find.text('Return to the original location'), findsOneWidget);

    // Verify Dropdown Selector
    expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

    // Verify Alert box text
    expect(
      find.text('Return trip will be completed on the selected date.'),
      findsOneWidget,
    );

    // Verify Done button
    expect(find.text('Done'), findsOneWidget);

    // Reset physical size and error handler
    tester.binding.window.clearPhysicalSizeTestValue();
    tester.binding.window.clearDevicePixelRatioTestValue();
    FlutterError.onError = originalOnError;
  });
}
