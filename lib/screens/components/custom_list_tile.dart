import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/detail_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailScreen(id: _id, name: _name, lName: _lastName)));
        _func();
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
