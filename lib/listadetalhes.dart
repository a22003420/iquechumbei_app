import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class Detalhes extends StatefulWidget {
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
  DetalhesState createState() => DetalhesState();
}

class DetalhesState extends State<Detalhes> {
  late String textToShare;

  @override
  void initState() {
    super.initState();
    textToShare = 'Mensagem do Dealer!!\n\nVamos ter avaliação de '
        '${widget.disciplina}, em ${widget.dataHora}, '
        'com a dificuldade de ${widget.dificuldade} numa escala de 1 a 5.\n'
        'Observações para esta avaliação:\n${widget.observacoes}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disciplina: " + widget.disciplina,
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
            Text('Nível de dificuldade: ${widget.dificuldade}'),
            const SizedBox(height: 8),
            Text('Tipo de Avaliação: ${widget.tipoAvaliacao}'),
            const SizedBox(height: 8),
            Text('Data e hora da realização: ${widget.dataHora}'),
            const SizedBox(height: 8),
            Text('Observações: ${widget.observacoes}'),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: (){
                    // Abrir as aplicações to share
                    Share.share(textToShare);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: Text('\u{27A1} Partilhar avaliação'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
