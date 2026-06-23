import 'package:flutter_test/flutter_test.dart';

import 'package:arape/main.dart';

void main() {
  testWidgets('App inicia na Tela de Boas-vindas', (WidgetTester tester) async {
    await tester.pumpWidget(const ArapeApp());
    await tester.pump();

    // O CTA principal da Tela de Boas-vindas deve estar presente.
    expect(find.text('Explore a Amazônia'), findsOneWidget);
  });
}
