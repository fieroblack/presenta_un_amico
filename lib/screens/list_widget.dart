import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
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
    _listFuture = recoverDatas();
  }

  Future<void> _refreshList() async {
    setState(() {
      _listFuture = recoverDatas();
    });
  }

  Future<List<Widget>> recoverDatas() async {
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            //TODO gestire pagina di no data
            return const Center(
              child: Text('No data'),
            );
          } else if (snapshot.hasError) {
            //TODO gestire errore
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Widget> data = snapshot.data as List<Widget>;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/iagica_logo.png',
                    scale: 12,
                  ),
                  Expanded(
                      child: ListView(
                    children: data,
                  ))
                ],
              ),
            );
          }
        });
  }
}
