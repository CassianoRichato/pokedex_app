import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/screens/home_screen.dart';

void main() {
  testWidgets('App inicializa e exibe lista de Pokémon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          toggleTheme: () {}, // função dummy
          isDarkMode: false, // valor inicial
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
