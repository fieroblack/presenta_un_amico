import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presenta_un_amico/screens/components/custom_text_input.dart';
import 'package:presenta_un_amico/screens/components/template_with_logo.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'components/button_file_scanner.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key});

  // final TextEditingController _name = TextEditingController();
  // final TextEditingController _lName = TextEditingController();
  // final TextEditingController _email = TextEditingController();
  // final TextEditingController _tel = TextEditingController();
  // final TextEditingController _level = TextEditingController();
  // final TextEditingController _fileName = TextEditingController();

  //0: Name, 1: LastName, 2: Email, 3: Telefono, 4: Level, 5: File
  final List<TextEditingController> _fieldList =
      List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LogoTemplate(
        listWidget: [
          const Text(
            //TODO should be a loggedin user
            'Stefano Gallo',
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
                  controller: _fieldList[5],
                  label: 'Seleziona il file da allegare',
                  readOnly: true,
                ),
              ),
              ButtonFileScanner(
                controller: _fieldList[5],
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LogoColor.greenLogoColor,
              ),
              onPressed: () async {
                for (TextEditingController i in _fieldList) {
                  if (i.text.isEmpty) {
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
                    return;
                  }
                }

                try {
                  FlutterGeneralServices.buildShowDialog(context);
                  var conn = await MySQLServices.connectToMySQL();
                  await MySQLServices.selectAll(conn);
                  await MySQLServices.appendRow(
                      conn,
                      //TODO ----> promoter, who is logged in
                      'Stefano Gallo',
                      _fieldList[0].text,
                      _fieldList[1].text,
                      _fieldList[2].text,
                      _fieldList[3].text,
                      _fieldList[4].text,
                      _fieldList[5].text);
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
