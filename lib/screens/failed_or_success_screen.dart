import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';

class FailedOrSuccessScreen extends StatelessWidget {
  const FailedOrSuccessScreen({super.key, required String id}) : _id = id;
  final String _id;

  Future<dynamic> _futureDatas() async {
    dynamic res = '';
    try {
      res = await MySQLServices.genericSelect('iter',
          param: 'id_candidatura=$_id');
    } catch (e) {
      throw Exception('Error: $e');
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureDatas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Errore nel caricamento dei dati'),
            );
          } else if (snapshot.hasData) {
            switch (snapshot.data.first['status']) {
              case 'inProgress':
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      "Iter ancora in corso, maggiori informazioni alla chiusura.",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                );
              case 'closed':
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      "Iter ancora non ancora iniziato.",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                );
              case 'failed':
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Il candidato non ha superato l'iter di selezione, di seguito le motivazioni: ",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          snapshot.data.first['final_note'],
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                );
              case 'success':
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Il candidato ha superato l'iter di selezione, di seguito il giudizio: ",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          snapshot.data.first['final_note'],
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                );
              default:
                return Container();
            }
          } else {
            return Container();
          }
        });
  }
}
