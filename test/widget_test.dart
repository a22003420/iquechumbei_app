import 'package:flutter_test/flutter_test.dart';
import 'package:iquechumbei_app/registo.dart';

void main() {
  testWidgets('Teste de Registo', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Registo());

    // Verify that our counter starts at 0.
    expect(find.text('Registo de avaliação'), findsOneWidget);
    expect(find.text('Disciplina'), findsOneWidget);
    expect(find.text('Nível de dificuldade'), findsOneWidget);
    expect(find.text('Tipo de avaliação'), findsOneWidget);
    expect(find.text('Data da realização'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.text('Guardar'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('Registo de avaliação'), findsOneWidget);
    expect(find.text('Disciplina'), findsOneWidget);
    expect(find.text('Nível de dificuldade'), findsOneWidget);
    expect(find.text('Tipo de avaliação'), findsOneWidget);
    expect(find.text('Data da realização'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });



  }
