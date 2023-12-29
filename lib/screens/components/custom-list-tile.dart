import 'package:flutter/material.dart';
import '../../utilities/constants.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.id,
      required this.name,
      required this.lastName,
      required this.date});

  final int id;
  final String name;
  final String lastName;
  final DateTime date;
  //TODO Controllo admin
  static const bool admin = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO navigate to another page
        print('ciao');
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
