// Basic widget test for Number Sprouts app

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_sprouts/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: NumberSproutsApp(),
      ),
    );

    // Verify that the app launches with the home screen
    expect(find.text('Number Sprouts'), findsOneWidget);
    expect(find.text('Grow Your Number Skills!'), findsOneWidget);
    
    // Verify game cards are present
    expect(find.text('Balloon Pop'), findsOneWidget);
    expect(find.text('Number Train'), findsOneWidget);
  });
}
