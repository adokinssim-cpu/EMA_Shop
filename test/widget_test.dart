import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:projet3_flutter/presentation/screens/main_navigation_screen.dart';

void main() {
  testWidgets('EMA Shop affiche la navigation principale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: MainNavigationScreen())),
    );

    // Attend les éventuelles opérations asynchrones.
    await tester.pumpAndSettle();

    // Vérifie que l'écran principal existe.
    expect(find.byType(MainNavigationScreen), findsOneWidget);

    // Vérifie la présence de la navigation inférieure.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
