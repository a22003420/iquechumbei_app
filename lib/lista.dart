import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
          Text('Data da Realização: 2021/02/20 12:30'),
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
          Text('Data da Realização: 2021/03/20 13:30'),
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
          Text('Data da Realização: 2021/06/20 14:30'),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDisciplinas();
  }

  // bool _isFirstRun = true;

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
      final values = value as List<dynamic>;
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
            Text('Data da Realização: $dataHora'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Eliminar disciplina'),
                  content:
                  Text('Tem certeza que quer eliminar esta disciplina?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('Excluir'),
                      onPressed: () {
                        _eliminarDisciplina(key);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Detalhes(
                      //HERE IS THE PROBLEM
                      disciplina: key,
                      tipoAvaliacao: avaliacao,
                      dataHora: dataHora,
                      dificuldade: dificuldade,
                      observacoes: observacoes,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Detalhes(
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
      final aDataHora =
      aChildren != null && aChildren.length > 2 ? aChildren[2] : null;
      final bDataHora =
      bChildren != null && bChildren.length > 2 ? bChildren[2] : null;
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

  int _disciplinasEliminadas = 0; //

  void _eliminarDisciplina(String disciplina) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(disciplina);
    await _loadDisciplinas();
    _disciplinasEliminadas++;
    print('Total de disciplinas removidas: $_disciplinasEliminadas');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O registo de avaliação selecionado foi eliminado '
              'com sucesso.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int _disciplinasEditadas = 0; //

  Future<void> _editarDisciplina(String key, String avaliacao, String dataHora,
      String dificuldade, String observacoes) async {
    final prefs = await SharedPreferences.getInstance();
    final values = [avaliacao, dataHora, dificuldade, observacoes];
    await prefs.setStringList(key, values);
    setState(() {
      _loadDisciplinas();
    });
    _disciplinasEditadas++;
    print('Total de disciplinas editadas: $_disciplinasEliminadas');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O registo de avaliação selecionado foi editado'
              ' com sucesso.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Total de disciplinas adicionadas: ${_disciplinas_added.length}");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Listagem de avaliações",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              "Avaliações adicionadas",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      blurRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: Scrollbar(
                  thickness: 6.0,
                  radius: Radius.circular(10.0),
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    children: _disciplinas_fixo + _disciplinas_added,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
