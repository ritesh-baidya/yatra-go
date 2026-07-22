import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/pages/passenger/passenger_edit_request_page.dart';
import 'package:yatri_dashboard/pages/passenger/passenger_my_booking_page.dart';

void main() {
  testWidgets('PassengerEditRequestPage renders correctly with all elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PassengerEditRequestPage(),
      ),
    );

    // Verify Title
    expect(find.text('Edit Request'), findsOneWidget);

    // Verify Request Pending Banner
    expect(find.text('Request Pending'), findsOneWidget);
    expect(find.text('Waiting for the driver to review your request.'), findsOneWidget);

    // Verify Driver Info
    expect(find.text('Ram Kumar'), findsOneWidget);
    expect(find.text('Verified Driver'), findsOneWidget);

    // Verify Locations
    expect(find.text('Gongabu, Kathmandu'), findsOneWidget);
    expect(find.text('Lakeside, Pokhara'), findsOneWidget);

    // Verify Price Details
    expect(find.text('Price Details'), findsOneWidget);
    expect(find.text('Total Payable'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Update Request'), findsOneWidget);
    expect(find.text('Cancel Request'), findsOneWidget);
  });

  testWidgets('Tapping pending card in PassengerMyBookingPage opens PassengerEditRequestPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PassengerMyBookingPage(),
      ),
    );

    // Switch to Pending Tab
    final pendingTab = find.text('Pending');
    expect(pendingTab, findsOneWidget);
    await tester.tap(pendingTab);
    await tester.pumpAndSettle();

    // Verify Pending card driver name
    final driverCardText = find.text('Sujan Thapa');
    expect(driverCardText, findsOneWidget);

    // Tap pending card
    await tester.tap(driverCardText);
    await tester.pumpAndSettle();

    // Verify Edit Request page is opened
    expect(find.text('Edit Request'), findsOneWidget);
    expect(find.text('Request Pending'), findsOneWidget);
  });
}
