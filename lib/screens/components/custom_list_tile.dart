import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/detail_page.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:provider/provider.dart';
import '../../services/mysql-services.dart';
import '../../utilities/constants.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required int id,
    required String name,
    required String lastName,
    required DateTime date,
    required dynamic Function() func,
    required String promoter,
    required String skills,
  })  : _skills = skills,
        _promoter = promoter,
        _func = func,
        _date = date,
        _lastName = lastName,
        _name = name,
        _id = id;

  final int _id;
  final String _name;
  final String _lastName;
  final DateTime _date;
  final Function() _func;
  final String _promoter;
  final String _skills;

  Future<Widget> _futureDatas() async {
    dynamic result = '';
    try {
      var conn = await MySQLServices.connectToMySQL();
      result = await MySQLServices.genericSelect(conn, 'iter',
          param: "id_candidatura='$_id'");
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception('Error: $e');
    }
    switch (result.first['status']) {
      case 'closed':
        return Text('Iter non ancora attivo');
      case 'inProgress':
        List<Color> sem = [Colors.grey, Colors.grey, Colors.grey];
        if (result.first['data_1_step'] != null) {
          sem = [Colors.orange, Colors.grey, Colors.grey];
        }
        if (result.first['data_2_step'] != null) {
          sem = [Colors.green, Colors.orange, Colors.grey];
        }
        if (result.first['data_3_step'] != null) {
          sem = [Colors.green, Colors.green, Colors.orange];
        }
        return Row(
          children: [
            Icon(Icons.fiber_manual_record, size: 30.0, color: sem[0]),
            Icon(Icons.fiber_manual_record, size: 30.0, color: sem[1]),
            Icon(Icons.fiber_manual_record, size: 30.0, color: sem[2]),
          ],
        );
      case 'failed':
        return Text('Iter fallito', style: TextStyle(color: Colors.red));
      case 'success':
        return Text('Proposta inviata', style: TextStyle(color: Colors.green));
      default:
        return Text('Non è stato possibile caricare i dati');
    }
  }

  Future<void> _deleteRecord(int id) async {
    var conn = await MySQLServices.connectToMySQL();
    await MySQLServices.deleteByKey(conn, id);
    await MySQLServices.connectClose(conn);
  }

  List<Widget> _skillsListWidget() {
    List<Widget> list = [];

    for (String skill in _skills.split("|")) {
      list.add(
        Text(
          '${skill.split(":")[0]} |',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return DetailPage(
                func: _func,
                date: _date,
                id: _id,
                name: _name,
                lastName: _lastName,
                skills: _skills,
              );
            });
      },
      onLongPress: () {
        if (!Provider.of<LoggedInUser>(context, listen: false).admin) return;
        FlutterGeneralServices.showMaterialBanner(
          context,
          "Sei sicuro di voler eliminare $_name $_lastName dall'elenco?",
          () async {
            try {
              await _deleteRecord(_id);
              _func();
            } catch (e) {
              _func();
              throw Exception('Error: $e');
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: LogoColor.greenComponentColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '[${_id.toString()}] $_name $_lastName',
                  style: kLabelStyle,
                ),
                Icon(Icons.attach_file)
              ],
            ),
            Divider(),
            Wrap(
              children: _skillsListWidget(),
            ),
            Text(
              'Data inserimento: ${_date.day}/${_date.month}/${_date.year}',
            ),
            if (Provider.of<LoggedInUser>(context).admin)
              Text('Promoter: $_promoter'),
            SizedBox(
              height: 10.0,
            ),
            FutureBuilder(
              future: _futureDatas(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return Text('Non ho dati a sufficienza');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
