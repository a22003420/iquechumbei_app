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
            SizedBox(height: 20),
            Text('Nível de dificuldade:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${widget.dificuldade}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Tipo de Avaliação:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${widget.tipoAvaliacao}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Data e hora da realização:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${widget.dataHora}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Observações:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${widget.observacoes}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Abrir as aplicações to share
                  Share.share(textToShare);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.share,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Partilhar avaliação',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
