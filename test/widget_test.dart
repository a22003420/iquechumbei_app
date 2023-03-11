import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:iquechumbei_app/listadetalhes.dart';

void main() {
  group('Testes de validação dos campos', () {
    test('Valida nome da disciplina - deve retornar null', () {
      final validator = (String? value) {
        if (value!.isEmpty) {
          return 'Faltar colocar o nome da disciplina';
        }
        return null;
      };
      expect(validator('LP2'), null);
    });

    test('Valida campo do nome da disciplina - deve retornar mensagem de erro',
        () {
      final validator = (String? value) {
        if (value!.isEmpty) {
          return 'Faltar colocar o nome da disciplina';
        }
        return null;
      };
      expect(validator(''), 'Faltar colocar o nome da disciplina');
    });

    test('Valida campo do tipo de avaliação - deve retornar null', () {
      final validator = (String? value) {
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
      expect(validator('frequencia'), null);
    });

    test('Valida tipo de avaliação - deve retornar mensagem de erro', () {
      final validator = (String? value) {
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
      expect(validator('teste'), 'Tipo de avaliação inválido.');
    });

    test('Valida data e hora - deve retornar null', () async {
      final validator = (String? value) async {
        if (value!.isEmpty) {
          return 'Falta colocar a Data e Hora da realização da avaliação';
        }

        DateTime pickedDateTime = DateFormat('yyyy/MM/dd HH:mm').parse(value);

        // Valida data e hora igual ou posterior à atual
        if (pickedDateTime.isAtSameMomentAs(DateTime.now()) ||
            pickedDateTime.isAfter(DateTime.now())) {
          return null;
        } else {
          return 'Data e hora inválidas. Selecione uma data e hora posterior ou igual à atual.';
        }
      };

      expect(await validator('2023/03/12 12:00'), null);
    });
  });

  group('Detalhes', () {
    testWidgets(
        'Partilhar a avaliação - deve retornar mensagem com os dados da avaliação selecionada',
        (WidgetTester tester) async {
      final widget = Detalhes(
        disciplina: 'LP2',
        tipoAvaliacao: 'mini-teste',
        dataHora: '12/03/2023 às 13:00',
        dificuldade: '4',
        observacoes: 'Estudar bem',
      );

      await tester.pumpWidget(MaterialApp(home: widget));
      await tester.tap(find.text('Partilhar avaliação'));
      await tester.pumpAndSettle();

      final textToShare = 'Mensagem do Dealer!!\n\nVamos ter avaliação de '
          '${widget.disciplina}, em ${widget.dataHora}, '
          'com a dificuldade de ${widget.dificuldade} numa escala de 1 a 5.\n'
          'Observações para esta avaliação:\n${widget.observacoes}';
      expect(textToShare,
          'Mensagem do Dealer!!\n\nVamos ter avaliação de LP2, em 12/03/2023 às 13:00, com a dificuldade de 4 numa escala de 1 a 5.\nObservações para esta avaliação:\nEstudar bem');
    });
  });
}
