import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen(
      {super.key, required this.id, required this.name, required this.lName});

  final int id;
  final String name;
  final String lName;

  Future<void> deleteRecord(int id) async {
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
            child: Text('id: ${id.toString()} nome: $name cognome: $lName '),
          ),
          TextButton(
              onPressed: () {
                try {
                  deleteRecord(id);
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
