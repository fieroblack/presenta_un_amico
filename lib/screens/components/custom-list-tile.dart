import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/detail-screen.dart';
import '../../utilities/constants.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.id,
    required this.name,
    required this.lastName,
    required this.date,
    required this.func,
  });

  final int id;
  final String name;
  final String lastName;
  final DateTime date;
  final Function() func;

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
                    DetailScreen(id: id, name: name, lName: lastName)));
        func();
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
                  '${id.toString()} $name $lastName',
                  style: kLabelStyle,
                ),
                Text(
                  'Data inserimento: ${date.day}/${date.month}/${date.year}',
                ),
                if (admin) Text('Inserito da: Stefano Gallo'),
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
