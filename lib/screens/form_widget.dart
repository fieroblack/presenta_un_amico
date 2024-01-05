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
import 'package:provider/provider.dart';
import 'components/button_file_scanner.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key});

  //0: Name, 1: LastName, 2: Email, 3: Telefono, 4: Level, 5: FilePath, 6: FileName
  final List<TextEditingController> _fieldList =
      List.generate(7, (index) => TextEditingController());

  Future<void> submitValue(BuildContext context) async {
    for (var i in _fieldList) {
      if (i.text.isEmpty) {
        if (context.mounted) {
          FlutterGeneralServices.showSnackBar(
              context, 'Tutti i campi devono essere compilati');
          return;
        }
      }
    }
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
      await MySQLServices.appendRowCandidates(
          conn,
          '${Provider.of<LoggedInUser>(context, listen: false).name} ${Provider.of<LoggedInUser>(context, listen: false).lastName}',
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
      FlutterGeneralServices.showSnackBar(context, 'Caricamento effettuato');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LogoTemplate(
        listWidget: [
          Row(
            children: [
              Text(
                '${Provider.of<LoggedInUser>(context).name} ${Provider.of<LoggedInUser>(context).lastName}',
                style: kTitleStyle,
              ),
              const SizedBox(
                width: 5.0,
              ),
              if (Provider.of<LoggedInUser>(context).admin)
                const Icon(Icons.verified_user),
            ],
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
                  kType: TextInputType.text,
                  textCapitalization: true,
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
                  kType: TextInputType.text,
                  textCapitalization: true,
                  controller: _fieldList[1],
                  label: 'Cognome',
                  readOnly: false,
                ),
              )
            ],
          ),
          CustomTextInput(
            kType: TextInputType.emailAddress,
            textCapitalization: false,
            controller: _fieldList[2],
            label: 'Email',
            readOnly: false,
          ),
          CustomTextInput(
            kType: TextInputType.phone,
            textCapitalization: false,
            controller: _fieldList[3],
            label: 'Telefono',
            readOnly: false,
          ),
          CustomTextInput(
            kType: TextInputType.text,
            textCapitalization: true,
            controller: _fieldList[4],
            label: 'Grado di conoscenza',
            readOnly: false,
          ),
          Row(
            children: [
              Flexible(
                child: CustomTextInput(
                  kType: TextInputType.none,
                  textCapitalization: true,
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
              onPressed: () {
                submitValue(context);
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
