import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iquechumbei_app/listadetalhes.dart';
import 'package:iquechumbei_app/registo.dart';


void main() {
  group('Detalhes', () {
    testWidgets('Verifica se o texto a ser compartilhado é gerado corretamente',
            (WidgetTester tester) async {
          // cria o widget de Detalhes
          final widget = MaterialApp(home: Detalhes(
              disciplina: 'LP2',
              tipoAvaliacao: 'mini-teste',
              dataHora: '06/03/2023 02:00',
              dificuldade: '3',
              observacoes: 'Vai ser tarefa dificil'
          ));

          // renderiza o widget
          await tester.pumpWidget(widget);

          // obtém a instância do state
          final state = tester.state(find.byType(Detalhes)) as DetalhesState;

          // verifica se o texto gerado é igual ao esperado (Mensagem do Dealer)
          expect(state.textToShare, 'Mensagem do Dealer!!\n\nVamos ter'
              ' avaliação de LP2, em 06/03/2023 02:00, com a dificuldade de '
              '3 numa escala de 1 a 5.\nObservações para esta avaliação:\n'
              'Vai ser tarefa dificil');
        });
  });

  test('Validação do TextFormField', () {
    // Cria uma instância do formulário
    final form = GlobalKey<FormState>();

    // Define os valores de entrada
    const invalidDisciplina = '';
    const invalidAvaliacao = 'teste';
    const invalidDataHora = '';
    const invalidDificuldade = '10';

    // Adiciona os valores de entrada ao formulário
    form.currentState!.validate();

    // Verifica se as mensagens de erro esperadas são retornadas
    expect(find.text('Faltar colocar o nome da disciplina'), findsOneWidget);
    expect(find.text('Falta colocar o tipo de avaliação'), findsOneWidget);
    expect(find.text('Falta colocar a Data e Hora da realização da avaliação'), findsOneWidget);
    expect(find.text('Falta colocar o nível de dificuldade esperado'), findsOneWidget);
  });

  testWidgets('DatePicker e TimePicker', (WidgetTester tester) async {
    // Define a data e hora para testar
    final DateTime pickedDateTime = DateTime(2023, 3, 7, 12, 0);

    // Abre o DatePicker
    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pumpAndSettle();

    // Seleciona a data
    await tester.tap(find.text('7'));
    await tester.pumpAndSettle();

    // Abre o TimePicker
    await tester.tap(find.text('12:00'));
    await tester.pumpAndSettle();

    // Seleciona a hora
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();

    // Verifica se o valor do TextFormField está correto
    expect(find.text('2023/03/07 13:00'), findsOneWidget);
  });

  testWidgets('ElevatedButton', (WidgetTester tester) async {
    // Cria uma instância do formulário
    final form = GlobalKey<FormState>();

    // Define os valores de entrada
    final disciplina = 'LP2';
    final avaliacao = 'frequencia';
    final dataHora = '2023/03/07 12:00';
    final dificuldade = '3';

    // Adiciona os valores de entrada ao formulário
    await tester.enterText(find.byType(TextFormField).at(0), disciplina);
    await tester.enterText(find.byType(TextFormField).at(1), avaliacao);
    await tester.enterText(find.byType(TextFormField).at(2), dataHora);
    await tester.enterText(find.byType(TextFormField).at(3), dificuldade);

    // Pressiona o botão
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verifica se a função _guardarRegisto foi chamada
    expect(form.currentState!.validate(), isTrue);
  });

  test('Quando o valor do campo está vazio, deve retornar uma mensagem de erro', () {
    // Arrange
    final controller = TextEditingController();
    final validator = (value) {
      if (value!.isEmpty) {
        return 'Falta colocar o tipo de avaliação';
      }
      List<String> tiposAvaliacao = [
        'frequencia',
        'mini-teste',
        'projeto',
        'defesa'
      ];
      if (!tiposAvaliacao.contains(value.toLowerCase())) {
        return 'Tipo de avaliação inválido.';
      }
      return null;
    };
    // Act
    final result = validator(controller.text);
    // Assert
    expect(result, 'Falta colocar o tipo de avaliação');
  });

  test('Quando um valor inválido é inserido, deve retornar uma mensagem de erro', () {
    // Arrange
    final controller = TextEditingController(text: 'avaliacao_invalida');
    final validator = (value) {
      if (value!.isEmpty) {
        return 'Falta colocar o tipo de avaliação';
      }
      List<String> tiposAvaliacao = [
        'frequencia',
        'mini-teste',
        'projeto',
        'defesa'
      ];
      if (!tiposAvaliacao.contains(value.toLowerCase())) {
        return 'Tipo de avaliação inválido.';
      }
      return null;
    };
    // Act
    final result = validator(controller.text);
    // Assert
    expect(result, 'Tipo de avaliação inválido.');
  });

  test('Quando um valor válido é inserido, deve retornar null', () {
    // Arrange
    final controller = TextEditingController(text: 'frequencia');
    final validator = (value) {
      if (value!.isEmpty) {
        return 'Falta colocar o tipo de avaliação';
      }
      List<String> tiposAvaliacao = [
        'frequencia',
        'mini-teste',
        'projeto',
        'defesa'
      ];
      if (!tiposAvaliacao.contains(value.toLowerCase())) {
        return 'Tipo de avaliação inválido.';
      }
      return null;
    };
    // Act
    final result = validator(controller.text);
    // Assert
    expect(result, null);
  });



}
