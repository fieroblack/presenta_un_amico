import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/template_with_logo.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'components/custom_list_tile.dart';

class ListWidgetCandidates extends StatefulWidget {
  const ListWidgetCandidates({super.key});

  static const bool admin = true;

  @override
  State<ListWidgetCandidates> createState() => _ListWidgetCandidatesState();
}

class _ListWidgetCandidatesState extends State<ListWidgetCandidates> {
  late Future<List<Widget>> _listFuture;

  @override
  void initState() {
    super.initState();
    _listFuture = _recoverDatas();
  }

  Future<void> _refreshList() async {
    setState(() {
      _listFuture = _recoverDatas();
    });
  }

  Future<List<Widget>> _recoverDatas() async {
    List<Widget> list = [];
    dynamic res;
    try {
      var conn = await MySQLServices.connectToMySQL();
      //TODO check admin or not
      res = await MySQLServices.selectAll(conn);
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception("Cannot upload the list $e");
    }
    for (var i in res) {
      list.add(CustomListTile(
          func: _refreshList,
          id: i['ID'],
          name: i['name'],
          lastName: i['lastName'],
          date: i['date']));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LogoTemplate(
              listWidget: [
                Expanded(child: Center(child: CircularProgressIndicator())),
              ],
            );
          } else if (snapshot.data!.isEmpty) {
            return const LogoTemplate(
              listWidget: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Elenco vuoto',
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return LogoTemplate(
              listWidget: [
                Center(
                  child: Text('Errore: ${snapshot.error}'),
                ),
              ],
            );
          } else {
            List<Widget> data = snapshot.data as List<Widget>;
            return LogoTemplate(
              listWidget: [
                Expanded(
                  child: ListView(
                    children: data,
                  ),
                ),
              ],
            );
          }
        });
  }
}
