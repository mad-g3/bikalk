import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bikalk/features/homeScreen/presentation/widgets/bike_selection_card.dart';

void main() {
  testWidgets('BikeSelectionCard shows label and responds to tap', (
    tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BikeSelectionCard(
            icon: Icons.bolt,
            label: 'Electric',
            selected: false,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Electric'), findsOneWidget);
    await tester.tap(find.byType(BikeSelectionCard));
    expect(tapped, isTrue);
  });

  testWidgets('BikeSelectionCard shows selected state visually', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BikeSelectionCard(
            icon: Icons.bolt,
            label: 'Electric',
            selected: true,
            onTap: () {},
          ),
        ),
      ),
    );

    // Selected state renders without error and label is present
    expect(find.text('Electric'), findsOneWidget);
  });
}
