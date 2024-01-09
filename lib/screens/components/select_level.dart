import 'package:flutter/material.dart';
import 'package:presenta_un_amico/utilities/constants.dart';

class SelectGrade extends StatefulWidget {
  const SelectGrade({super.key});

  @override
  State<SelectGrade> createState() => _SelectGradeState();
}

class _SelectGradeState extends State<SelectGrade> {
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RadioListTile(
              title: Text('Junior - Da 0 a 2 anni di esperienza'),
              value: 'Junior',
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Mid-level - Da 2 a 4 anni di esperienza'),
              value: 'Mid-level',
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Senior - Oltre 4 di esperienza'),
              value: 'Senior',
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value.toString();
                });
              },
            ),
            RadioListTile(
              title: Text('Specialist - Team leader - Manager'),
              value: 'Specialist',
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value.toString();
                });
              },
            ),
            const Divider(),
            Text(
              selectedValue.isEmpty ? '' : 'Hai selezionato $selectedValue',
              style: kUserPwdTextStyle,
            ),
            const SizedBox(
              height: 25.0,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LogoColor.greenLogoColor,
                ),
                onPressed: () {
                  Navigator.pop(context, selectedValue);
                },
                child: const Text(
                  'Conferma dati',
                  style: kButtonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
