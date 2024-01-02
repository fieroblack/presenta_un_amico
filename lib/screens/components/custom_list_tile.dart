import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
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
  })  : _func = func,
        _date = date,
        _lastName = lastName,
        _name = name,
        _id = id;

  final int _id;
  final String _name;
  final String _lastName;
  final DateTime _date;
  final Function() _func;

  //TODO Controllo admin
  static const bool admin = true;

  Future<void> _deleteRecord(int id) async {
    var conn = await MySQLServices.connectToMySQL();
    await MySQLServices.deleteByKey(conn, id);
    await MySQLServices.connectClose(conn);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onLongPress: () {
        FlutterGeneralServices.showMaterialBanner(
          context,
          "Sei sicuro di voler eliminare l'elemento selezionato?",
          () async {
            try {
              await _deleteRecord(_id);
              _func();
            } catch (e) {
              //TODO print exception
              _func();
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_id.toString()} $_name $_lastName',
                  style: kLabelStyle,
                ),
                Text(
                  'Data inserimento: ${_date.day}/${_date.month}/${_date.year}',
                ),
                if (admin) const Text('Inserito da: Stefano Gallo'),
              ],
            ),
            Icon(
              Icons.arrow_right,
              size: 70,
              color: LogoColor.greenLogoColor,
            )
          ],
        ),
      ),
    );
  }
}
