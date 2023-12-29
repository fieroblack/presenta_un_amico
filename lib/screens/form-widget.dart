import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presenta_un_amico/screens/components/custom-text-input.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'components/button-file-scanner.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key});

  final TextEditingController _name = TextEditingController();
  final TextEditingController _lName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _level = TextEditingController();
  final TextEditingController _fileName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/iagica_logo.png',
              scale: 12,
            ),
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
                    controller: _name,
                    label: 'Nome',
                    readOnly: false,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: CustomTextInput(
                    controller: _lName,
                    label: 'Cognome',
                    readOnly: false,
                  ),
                )
              ],
            ),
            CustomTextInput(
              controller: _email,
              label: 'Email',
              readOnly: false,
            ),
            CustomTextInput(
              controller: _tel,
              label: 'Telefono',
              readOnly: false,
            ),
            CustomTextInput(
              controller: _level,
              label: 'Grado di conoscenza',
              readOnly: false,
            ),
            Row(
              children: [
                Flexible(
                  child: CustomTextInput(
                    controller: _fileName,
                    label: 'Seleziona il file da allegare',
                    readOnly: true,
                  ),
                ),
                ButtonFileScanner(
                  controller: _fileName,
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                //TODO modificare il pulsante, renderlo esteticamente accettabile e funzionale

                style: ElevatedButton.styleFrom(
                  backgroundColor: LogoColor.greenLogoColor,
                ),

                onPressed: () async {
                  if (_name.text.isEmpty |
                      _lName.text.isEmpty |
                      _email.text.isEmpty |
                      _tel.text.isEmpty |
                      _level.text.isEmpty) {
                    print(
                        'Probabilmente non tutti i campi sono inseriti correttamente');
                    //TODO implementare un toast di controllo
                    //TODO inserire anche verifica su file
                    return;
                  }
                  try {
                    var conn = await MySQLServices.connectToMySQL();
                    await MySQLServices.selectAll(conn);
                    await MySQLServices.appendRow(
                      conn,
                      'Stefano Gallo',
                      _name.text.toString(),
                      _lName.text.toString(),
                      _email.text.toString(),
                      _tel.text.toString(),
                      _level.text.toString(),
                    );
                    await MySQLServices.connectClose(conn);
                    _name.clear();
                    _lName.clear();
                    _email.clear();
                    _tel.clear();
                    _level.clear();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  } catch (e) {
                    //TODO toast
                    print('Exception found: ${e}');
                  }
                },
                child: const Text(
                  'Conferma dati',
                  style: kButtonStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
