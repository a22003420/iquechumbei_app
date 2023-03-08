import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  Future<double> _AverageDifficulty() async {
    final now = DateTime.now();
    final nextWeek = now.add(Duration(days: 7));

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final difficultyValues = [];

    for (final key in keys) {
      final value = prefs.get(key);
      final values = value as List<dynamic>;
      final dataHora = values.length > 1 ? values[1] : '';

      final date = DateFormat("yyyy/MM/dd HH:mm").parse(dataHora);

      if (date.isAfter(now) && date.isBefore(nextWeek)) {
        final difficulty = values.length > 2 ? values[2] : '';
        difficultyValues.add(int.parse(difficulty));
      }
    }

    if (difficultyValues.isNotEmpty) {
      final average =
          difficultyValues.reduce((a, b) => a + b) / difficultyValues.length;
      return double.parse(average.toStringAsFixed(2));
    } else {
      return 0;
    }
  }

  Future<double> _AverageDifficultyForFuture() async {
    final now = DateTime.now();
    final nextWeek = now.add(Duration(days: 7));
    final twoWeeksAhead = now.add(Duration(days: 14));

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final difficultyValues = [];

    for (final key in keys) {
      final value = prefs.get(key);
      final values = value as List<dynamic>;
      final dataHora = values.length > 1 ? values[1] : '';
      final date = DateFormat("yyyy/MM/dd HH:mm").parse(dataHora);

      if (date.isAfter(nextWeek) && date.isBefore(twoWeeksAhead)) {
        final difficulty = values.length > 2 ? values[2] : '';
        difficultyValues.add(int.parse(difficulty));
      }
    }

    if (difficultyValues.isNotEmpty) {
      final average =
          difficultyValues.reduce((a, b) => a + b) / difficultyValues.length;
      return double.parse(average.toStringAsFixed(2));
    } else {
      return 0;
    }
  }

  Future<List<dynamic>> _getNextWeekAssessmentsNames() async {
    final now = DateTime.now();
    final nextWeek = now.add(Duration(days: 7));

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final examNames = [];

    for (final key in keys) {
      final value = prefs.get(key);
      final values = value as List<dynamic>;
      final dataHora = values.length > 1 ? values[1] : '';
      final date = DateFormat("yyyy/MM/dd HH:mm").parse(dataHora);

      if (date.isAfter(now) && date.isBefore(nextWeek)) {
        final examName = key.toString();
        if (date.difference(now).inDays <= 1) {
          examNames.add({'name': examName, 'color': Colors.red, 'date': date});
        } else if (date.difference(now).inDays > 1) {
          examNames
              .add({'name': examName, 'color': Colors.orange, 'date': date});
        } else {
          examNames
              .add({'name': examName, 'color': Colors.green, 'date': date});
        } // datas passadas ficam verdes
      }
    }

    examNames.sort((a, b) => a['date'].compareTo(b['date']));
    // assim fica mais bonito no ecrã, ordena crescente
    return examNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'iQueChumbei',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 650,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.all(16.0),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<List<dynamic>>(
                        future: _getNextWeekAssessmentsNames(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          } else {
                            final examNames = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Próximas avaliações:',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: examNames.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final exam = examNames[index];
                                      return ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          exam['name'],
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: exam['color'],
                                          ),
                                        ),
                                        subtitle: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(exam['date']),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<double>(
                        future: _AverageDifficulty(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          } else {
                            final nextWeekAverage = snapshot.data!;
                            return Text(
                              'Nível médio de dificuldade das avaliações dos próximos 7 dias: ${nextWeekAverage.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<double>(
                        future: _AverageDifficultyForFuture(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          } else {
                            final nextWeekAverage = snapshot.data!;
                            return Text(
                              'Nível médio de dificuldade das avaliações entre os 7 e os 14 dias: ${nextWeekAverage.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                            );
                          }
                        },
                      ),
                    ],
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
