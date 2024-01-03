import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presenta_un_amico/screens/components/custom_text_input.dart';
import 'package:presenta_un_amico/screens/components/template_with_logo.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'components/button_file_scanner.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key, required this.user});

  final LoggedInUser user;
  //0: Name, 1: LastName, 2: Email, 3: Telefono, 4: Level, 5: FilePath, 6: FileName
  final List<TextEditingController> _fieldList =
      List.generate(7, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LogoTemplate(
        listWidget: [
          Text(
            '${user.name} ${user.lastName}',
            style: kTitleStyle,
          ),
          const Text(
            'Presentaci un amico!',
            style: kLabelStyle,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Flexible(
                child: CustomTextInput(
                  controller: _fieldList[0],
                  label: 'Nome',
                  readOnly: false,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: CustomTextInput(
                  controller: _fieldList[1],
                  label: 'Cognome',
                  readOnly: false,
                ),
              )
            ],
          ),
          CustomTextInput(
            controller: _fieldList[2],
            label: 'Email',
            readOnly: false,
          ),
          CustomTextInput(
            controller: _fieldList[3],
            label: 'Telefono',
            readOnly: false,
          ),
          CustomTextInput(
            controller: _fieldList[4],
            label: 'Grado di conoscenza',
            readOnly: false,
          ),
          Row(
            children: [
              Flexible(
                child: CustomTextInput(
                  //TODO print just a file name
                  controller: _fieldList[6],
                  label: 'File da allegare',
                  readOnly: true,
                ),
              ),
              ButtonFileScanner(
                controller: [_fieldList[5], _fieldList[6]],
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LogoColor.greenLogoColor,
              ),
              onPressed: () async {
                String base64EncodedData = '';
                try {
                  File file = File(_fieldList[5].text);

                  List<int> fileBytes = await file.readAsBytes();
                  base64EncodedData = base64Encode(fileBytes);
                } catch (e) {
                  throw Exception('Error: $e');
                }

                for (TextEditingController i in _fieldList) {
                  if (i.text.isEmpty) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: const Text(
                            'Verificare che tutti i campi siano compilati',
                            textAlign: TextAlign.center,
                            style: kSnackStyle,
                          ),
                          backgroundColor: Colors.grey[300],
                        ),
                      );
                    }
                    return;
                  }
                }

                try {
                  if (context.mounted) {
                    FlutterGeneralServices.buildProgressIndicator(context);
                  }

                  var conn = await MySQLServices.connectToMySQL();
                  await MySQLServices.selectAll(conn);
                  await MySQLServices.appendRow(
                      conn,
                      '${user.name} ${user.lastName}',
                      _fieldList[0].text,
                      _fieldList[1].text,
                      _fieldList[2].text,
                      _fieldList[3].text,
                      _fieldList[4].text,
                      base64EncodedData);
                  await MySQLServices.connectClose(conn);

                  for (TextEditingController i in _fieldList) {
                    i.clear();
                  }

                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    FlutterGeneralServices.showSnackBar(
                        context, 'Errore in fase di caricamento');
                  }
                }
                if (context.mounted) {
                  FlutterGeneralServices.showSnackBar(
                      context, 'Caricamento effettuato');
                }
              },
              child: const Text(
                'Conferma dati',
                style: kButtonStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
