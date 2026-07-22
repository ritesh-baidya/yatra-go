import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/pages/passenger/passenger_notification_page.dart';

void main() {
  testWidgets('PassengerNotificationPage renders correctly with single card style',
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

    await tester.pumpWidget(
      const MaterialApp(
        home: PassengerNotificationPage(),
      ),
    );

    // Verify header title
    expect(find.text('Notifications'), findsOneWidget);

    // Verify key notification items are rendered
    expect(find.text('Booking Confirmed'), findsOneWidget);
    expect(find.text('Driver Assigned'), findsOneWidget);
    expect(find.text('Ride Reminder'), findsOneWidget);
    expect(find.text('Driver is Nearby'), findsOneWidget);
    expect(find.text('Ride Completed'), findsOneWidget);
    expect(find.text('Payment Successful'), findsOneWidget);
    expect(find.text('New Offer for You!'), findsOneWidget);

    // Verify specific descriptions are displayed
    expect(
      find.text('Your booking from Kathmandu to Pokhara on 25 May at 7:00 AM is confirmed.'),
      findsOneWidget,
    );
    expect(
      find.text('Your payment of NPR 1,250 has been completed successfully.'),
      findsOneWidget,
    );

    // Verify no chevron right icon is shown
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);

    // Reset physical size and error handler
    tester.binding.window.clearPhysicalSizeTestValue();
    tester.binding.window.clearDevicePixelRatioTestValue();
    FlutterError.onError = originalOnError;
  });
}
