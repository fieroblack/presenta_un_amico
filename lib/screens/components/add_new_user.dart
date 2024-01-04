import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/custom_email_pwd_input.dart';
import 'package:presenta_un_amico/screens/components/custom_text_input.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';

import '../../utilities/constants.dart';

class AddNewUserFrame extends StatefulWidget {
  AddNewUserFrame({super.key});

  @override
  State<AddNewUserFrame> createState() => _AddNewUserFrameState();
}

class _AddNewUserFrameState extends State<AddNewUserFrame> {
  bool _value = false;

  final List<TextEditingController> _fieldController =
      List.generate(4, (index) => TextEditingController());

  Future<void> _createNewUser() async {
    for (var i in _fieldController) {
      if (i.text.isEmpty) {
        if (context.mounted) {
          Navigator.pop(context);
          FlutterGeneralServices.showSnackBar(
              context, 'Inserire tutti i campi');
          return;
        }
      }
    }
    Uint8List data = Uint8List.fromList(utf8.encode(_fieldController[3].text));
    String hashedPassword = sha256.convert(data).toString();
    try {
      var conn = await MySQLServices.connectToMySQL();
      await MySQLServices.appendRowUsers(
          conn,
          _fieldController[0].text,
          _fieldController[1].text,
          _fieldController[2].text,
          hashedPassword,
          _value ? 1 : 0);
      await MySQLServices.connectClose(conn);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        FlutterGeneralServices.showSnackBar(
            context, 'Qualcosa è andato storto');
        return;
      }
    }

    if (context.mounted) {
      Navigator.pop(context);
      FlutterGeneralServices.showSnackBar(context, 'Nuovo utente creato');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextInput(
            label: 'Nome',
            readOnly: false,
            controller: _fieldController[0],
            textCapitalization: true,
            kType: TextInputType.text),
        CustomTextInput(
            label: 'Cognome',
            readOnly: false,
            controller: _fieldController[1],
            textCapitalization: true,
            kType: TextInputType.text),
        CustomTextInput(
            label: 'Email',
            readOnly: false,
            controller: _fieldController[2],
            textCapitalization: true,
            kType: TextInputType.text),
        CustomEmPwInput(
          hintText: 'Password',
          pwd: true,
          controller: _fieldController[3],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Amministratore',
              style: kLabelStyle,
            ),
            Checkbox(
                value: _value,
                onChanged: (bool? value) {
                  setState(() {
                    _value = value!;
                  });
                }),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LogoColor.greenLogoColor,
            ),
            onPressed: () {
              _createNewUser();
            },
            child: const Text(
              'Conferma dati',
              style: kButtonStyle,
            ),
          ),
        ),
      ],
    );
  }
}
