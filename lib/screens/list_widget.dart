import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/template_with_logo.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'components/custom_list_tile.dart';

class ListWidgetCandidates extends StatefulWidget {
  const ListWidgetCandidates({super.key, required LoggedInUser user})
      : _user = user;

  final LoggedInUser _user;

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
      if (!widget._user.admin) {
        res = await MySQLServices.selectAll(conn, promoter: widget._user.email);
      } else {
        res = await MySQLServices.selectAll(conn);
      }

      print(widget._user.email);
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception("Cannot upload the list $e");
    }
    for (var i in res) {
      list.add(
        CustomListTile(
          func: _refreshList,
          id: i['ID'],
          name: i['name'],
          lastName: i['lastName'],
          date: i['date'],
          promoter: i['promoter'],
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LogoTemplate(
              user: widget._user,
              listWidget: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: LogoColor.greenLogoColor,
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.data!.isEmpty) {
            return LogoTemplate(
              user: widget._user,
              listWidget: const [
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
              user: widget._user,
              listWidget: [
                Center(
                  child: Text('Errore: ${snapshot.error}'),
                ),
              ],
            );
          } else {
            List<Widget> data = snapshot.data as List<Widget>;
            return LogoTemplate(
              user: widget._user,
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
