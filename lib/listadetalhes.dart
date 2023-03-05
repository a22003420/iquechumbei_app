import 'package:flutter/material.dart';

class Detalhes extends StatelessWidget {
  final String disciplina;
  final String tipoAvaliacao;
  final String dataHora;
  final String dificuldade;
  final String observacoes;

  const Detalhes({
    Key? key,
    required this.disciplina,
    required this.tipoAvaliacao,
    required this.dataHora,
    required this.dificuldade,
    required this.observacoes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disciplina: " + disciplina,
          style: TextStyle(
            fontSize: 24.0, // tamanho da fonte em pontos
            fontWeight: FontWeight.bold, // negrito
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nível de dificuldade: $dificuldade'),
            const SizedBox(height: 8),
            Text('Tipo de Avaliação: $tipoAvaliacao'),
            const SizedBox(height: 8),
            Text('Data e hora da realização: $dataHora'),
            const SizedBox(height: 8),
            Text('Observações: $observacoes'),

          ],
        ),
      ),
    );
  }
}
