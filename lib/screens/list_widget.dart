import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/template_with_logo.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'components/custom_list_tile.dart';

class ListWidgetCandidates extends StatefulWidget {
  const ListWidgetCandidates({super.key});

  @override
  State<ListWidgetCandidates> createState() => _ListWidgetCandidatesState();
}

class _ListWidgetCandidatesState extends State<ListWidgetCandidates> {
  late Future<List<Widget>> _listFuture;

  @override
  void initState() {
    super.initState();
    _listFuture = _recoverDatas(context);
  }

  Future<void> _refreshList() async {
    setState(() {
      _listFuture = _recoverDatas(context);
    });
  }

  Future<List<Widget>> _recoverDatas(BuildContext context) async {
    List<Widget> list = [];
    dynamic res;

    try {
      if (!Provider.of<LoggedInUser>(context, listen: false).admin) {
        String promoter =
            '${Provider.of<LoggedInUser>(context, listen: false).name} ${Provider.of<LoggedInUser>(context, listen: false).lastName}';
        res = await MySQLServices.selectAll(promoter: promoter);
      } else {
        res = await MySQLServices.selectAll();
      }
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
          skills: i['technologies'],
          email: i['email'],
          phone: i['tel'],
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
