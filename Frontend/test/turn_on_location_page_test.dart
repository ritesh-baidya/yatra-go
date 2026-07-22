import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatri_dashboard/pages/shared/turn_on_location_page.dart';

void main() {
  testWidgets('TurnOnLocationPage renders correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: TurnOnLocationPage(),
      ),
    );

    // Verify Title exists
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('Turn your location on'),
      ),
      findsOneWidget,
    );

    // Verify Subtitle
    expect(
      find.text(
        'You’ll be able to find yourself on the map,\nand drivers will be able to find you at the pickup point.',
      ),
      findsOneWidget,
    );

    // Verify Button
    expect(find.text('Enable location services'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
