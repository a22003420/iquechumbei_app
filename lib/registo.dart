import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lista.dart';
import 'package:intl/intl.dart';

class Registo extends StatefulWidget {

  @override
  _RegistoState createState() => _RegistoState();
}



class _RegistoState extends State<Registo> {
  final _formKey = GlobalKey<FormState>();
  final _disciplinaController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _dataHoraController = TextEditingController();
  final _dificuldadeController = TextEditingController();
  final _observacoesController = TextEditingController();

  List<Map<String, dynamic>> _registos = [];

  @override
  void initState() {
    super.initState();
    _recuperarRegistos();

  }

  Future<void> _guardarRegisto() async {
    final preferences = await SharedPreferences.getInstance();
    final disciplina = _disciplinaController.text;
    final avaliacao = _avaliacaoController.text;
    final dataHora = _dataHoraController.text;
    final dificuldade = _dificuldadeController.text;
    final observacoes = _observacoesController.text;

    // Validar o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Guarda a disciplina e seus valores nas SharedPreferences
    await preferences.setStringList(
        disciplina, [avaliacao, dataHora, dificuldade, observacoes]);

    // Limpar os campos
    _disciplinaController.clear();
    _avaliacaoController.clear();
    _dataHoraController.clear();
    _dificuldadeController.clear();
    _observacoesController.clear();
    // Limpar os campos e mostrar a mensagem

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('A avaliação foi registada com sucesso.'),
      ),
    );

    // Recuperar registos updated
    _recuperarRegistos();
  }

  Future<void> _recuperarRegistos() async {
    final preferences = await SharedPreferences.getInstance();
    final keys = preferences.getKeys();

    final registos = keys.map((key) {
      final value = preferences.get(key);
      final values = value as List<String>;
      print(values);
      final avaliacao = values.length > 0 ? values[0] : '';
      final dataHora = values.length > 1 ? values[1] : '';
      final dificuldade = values.length > 2 ? values[2] : '';
      final observacoes = values.length > 3 ? values[3] : '';

      return Map<String, dynamic>.from({
        'disciplina': key,
        'avaliacao': avaliacao,
        'dataHora': dataHora,
        'dificuldade': dificuldade,
        'observacoes': observacoes,
      });
    }).toList();

    setState(() {
      _registos = registos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AppBar(
            title: Text(
              'Registo de avaliação',
              style: TextStyle(
                fontSize: 24.0, // tamanho da fonte em pontos
                fontWeight: FontWeight.bold, // negrito
              ),
            ),
            backgroundColor: Colors.blue,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _disciplinaController,
                    decoration: InputDecoration(
                      labelText: 'Nome da disciplina (ex:. LP2)',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Faltar colocar o nome da disciplina';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _avaliacaoController,
                    decoration: InputDecoration(
                      labelText:
                          'Tipo de avaliação (ex:. frequencia, mini-teste, projeto ou defesa)',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
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
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dataHoraController,
                    decoration: InputDecoration(
                      labelText: 'Data e hora da realização (ex formato:. 2023/01/31 14:30)',
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          DateTime pickedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          // data e hora igual ou posterior à atual - Validação
                          if (pickedDateTime.isAtSameMomentAs(DateTime.now()) || pickedDateTime.isAfter(DateTime.now())) {
                            String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(pickedDateTime);
                            _dataHoraController.text = formattedDate;
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Data e hora inválidas'),
                                  content: Text('Seleccione uma data e hora posterior ou igual à atual.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Falta colocar a Data e Hora da realização da avaliação';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dificuldadeController,
                    decoration: InputDecoration(
                      labelText: ' Nível de dificuldade esperado pelo aluno (Entre 1 e 5)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Falta colocar o nível de dificuldade esperado';
                      }

                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira um número válido';
                      }

                      List<int> dificuldadeRange = [1, 2, 3, 4, 5];

                      if (!dificuldadeRange.contains(int.parse(value))) {
                        return 'Dificuldade inválida. Por favor, insira um valor entre 1 e 5';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _observacoesController,
                    decoration: InputDecoration(
                      labelText: 'Observações (opcional)',
                    ),
                    keyboardType: TextInputType.text,
                    maxLength: 200,
                    validator: (value) {
                      // não tem código, pois é opcional
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _guardarRegisto,
                    child: Text('Guardar o registo da avaliação'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
