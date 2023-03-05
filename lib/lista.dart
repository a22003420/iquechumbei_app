import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'listadetalhes.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Widget> _disciplinas_added = []; // carregadas pelo user

  final List<Widget> _disciplinas_fixo = [
    // pre carregadas
    ListTile(
      title: const Text('IHM'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Nível de dificuldade: 3'),
          Text('Tipo de Avaliação: mini-teste'),
          Text('Data e hora da realização: 2021/02/20 12:30'),
          Text('Observações: Gostei muito da disciplina.'),
        ],
      ),
    ),
    ListTile(
      title: const Text('Computação Móvel'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Nível de dificuldade: 4'),
          Text('Tipo de Avaliação: frequência'),
          Text('Data e hora da realização: 2021/03/20 13:30'),
          Text('Observações: Gostei muito da disciplina.'),
        ],
      ),
    ),
    ListTile(
      title: const Text('LP2'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Nível de dificuldade: 3'),
          Text('Tipo de Avaliação: defesa'),
          Text('Data e hora da realização: 2021/06/20 14:30'),
          Text('Observações: Gostei muito da disciplina.'),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDisciplinas();
  }

  bool _isFirstRun = true;

  Future<void> _loadDisciplinas() async {
    final prefs = await SharedPreferences.getInstance();

    /*if (_isFirstRun==true) { // testa se é a primeira vez que a app é executado
      prefs.clear(); //to clear all the data
      _isFirstRun = false;
    }else{
      print("Não é a primeira vez que a app é corrida");
    }*/
    //prefs.clear(); //to clear all the data | Coloquei no main para abrir sempre limpo
    final keys = prefs.getKeys();
    final disciplinas = keys.map((key) {
      final value = prefs.get(key);
      final values = value as List<String>;
      final avaliacao = values.length > 0 ? values[0] : '';
      final dataHora = values.length > 1 ? values[1] : '';
      final dificuldade = values.length > 2 ? values[2] : '';
      final observacoes = values.length > 3 ? values[3] : '';

      return ListTile(
        title: Text(key),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nível de dificuldade: $dificuldade'),
            Text('Tipo de Avaliação: $avaliacao'),
            Text('Data e hora da realização: $dataHora'),
            Text('Observações: $observacoes'),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  Detalhes(
                    disciplina: key,
                    tipoAvaliacao: avaliacao,
                    dataHora: dataHora,
                    dificuldade: dificuldade,
                    observacoes: observacoes,
                  ),
            ),
          );
        },
      );
    }).toList();

    //set sort list by dataHora
    // set sort list by dataHora
    disciplinas.sort((a, b) {
      final aChildren = (a.subtitle as Column)?.children;
      final bChildren = (b.subtitle as Column)?.children;
      final aDataHora = aChildren != null && aChildren.length > 2 ? aChildren[2] : null;
      final bDataHora = bChildren != null && bChildren.length > 2 ? bChildren[2] : null;
      if (aDataHora != null && bDataHora != null) {
        return aDataHora.toString().compareTo(bDataHora.toString());
      } else {
        return 0;
      }
    });




    setState(() {
      _disciplinas_added = disciplinas;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Lista de disciplinas adicionadas: ${_disciplinas_added.length}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Listagem de avaliações",
          style: TextStyle(
            fontSize: 24.0, // tamanho da fonte em pontos
            fontWeight: FontWeight.bold, // negrito
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: EdgeInsets.only(top: 14.0),
                children: _disciplinas_fixo + _disciplinas_added,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
