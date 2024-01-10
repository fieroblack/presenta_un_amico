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
              height: 20.0,
            ),
            false
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.grey,
                      ),
                      Text('In progress'),
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.grey,
                      ),
                      Text('In progress'),
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.grey,
                      ),
                      Text('In progress'),
                    ],
                  )
                : Text(
                    'Iter non ancora attivo',
                    style: TextStyle(color: Colors.red),
                  )
          ],
        ),
      ),
    );
  }
}
