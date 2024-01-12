import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';

import '../../utilities/constants.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key, required int id}) : _id = id;

  final int _id;

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool _activate = false;

  Future<void> _activateIter() async {
    try {
      var conn = await MySQLServices.connectToMySQL();
      await MySQLServices.activateIter(conn, widget._id.toString());
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Widget>> _iterDatas() async {
    dynamic result = '';
    try {
      var conn = await MySQLServices.connectToMySQL();
      print(widget._id);
      result = await MySQLServices.genericSelect(conn, 'iter',
          param: 'id_candidatura=${widget._id}');
      print(result.first['status']);
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception('Error: $e');
    }
    if (result.first['status'] == 'closed') {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Attiva candidatura',
              style: kLabelStyle,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Switch(
                activeTrackColor: LogoColor.greenLogoColor,
                value: _activate,
                onChanged: (bool? value) async {
                  setState(() {
                    _activate = !_activate;
                  });

                  await _activateIter();
                })
          ],
        ),
      ];
    } else {
      return [Text('In progress')];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _iterDatas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: LogoColor.greenLogoColor,
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
            'Elenco vuoto',
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Errore: ${snapshot.error}'),
          );
        } else {
          return Column(
            children: snapshot.data!,
          );
        }
        ;
      },
    );
  }
}
