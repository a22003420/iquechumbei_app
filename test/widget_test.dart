import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iquechumbei_app/listadetalhes.dart';


void main() {
  group('Detalhes', () {
    testWidgets('Verifica se o texto a ser compartilhado é gerado corretamente',
            (WidgetTester tester) async {
          // cria a widget de Detalhes
          final widget = MaterialApp(home: Detalhes(
              disciplina: 'Matemática',
              tipoAvaliacao: 'Prova',
              dataHora: '01/01/2023 14:00',
              dificuldade: '3',
              observacoes: 'Estudar funções trigonométricas'
          ));

          // renderiza o widget
          await tester.pumpWidget(widget);

          // obtém a instância do state
          final state = tester.state(find.byType(Detalhes)) as DetalhesState;

          // verifica se o texto gerado é igual ao esperado (Mensagem do Dealer)
          expect(state.textToShare, 'Mensagem do Dealer!!\n\nVamos ter avaliação de Matemática, em 01/01/2023 14:00, com a dificuldade de 3 numa escala de 1 a 5.\nObservações para esta avaliação:\nEstudar funções trigonométricas');
        });
  });
}
