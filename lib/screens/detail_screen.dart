import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen(
      {super.key, required int id, required String name, required String lName})
      : _lName = lName,
        _name = name,
        _id = id;

  final int _id;
  final String _name;
  final String _lName;

  Future<void> _deleteRecord(int id) async {
    var conn = await MySQLServices.connectToMySQL();
    await MySQLServices.deleteByKey(conn, id);
    await MySQLServices.connectClose(conn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('id: ${_id.toString()} nome: $_name cognome: $_lName '),
          ),
          TextButton(
              onPressed: () {
                try {
                  _deleteRecord(_id);
                  Navigator.pop(context);
                } catch (e) {
                  throw Exception('Cannot delete record');
                }
              },
              child: const Text('delete'))
        ],
      ),
    );
  }
}
