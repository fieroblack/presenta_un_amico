import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presenta_un_amico/screens/components/custom_text_input.dart';
import 'package:presenta_un_amico/screens/components/select_level.dart';
import 'package:presenta_un_amico/screens/components/template_with_logo.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'components/button_file_scanner.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final Map<String, String> chips = {};

  //0: Name, 1: LastName, 2: Email, 3: Telefono, 4: Level, 5: FilePath, 6: FileName
  final List<TextEditingController> _fieldList =
      List.generate(7, (index) => TextEditingController());

  // void _addChips(String value) {
  //   setState(() {
  //     if (!chips.contains(value)) {
  //       chips.add(value);
  //       _generateChipsList();
  //     }
  //   });
  // }
  void _addChips(String value, String seniority) {
    setState(() {
      if (!chips.keys.contains(value)) {
        chips[value] = seniority;
        _generateChipsList();
      }
    });
  }

  Future<List<Widget>> _getTecFromDb() async {
    List<DropdownMenuItem<String>> list = [];
    dynamic result;
    try {
      var conn = await MySQLServices.connectToMySQL();
      result = await MySQLServices.genericSelect(conn, 'technologies');
      await MySQLServices.connectClose(conn);
    } catch (e) {
      throw Exception('Errore: $e');
    }
    for (var i in result) {
      list.add(DropdownMenuItem(
        child: Text(i['name']),
        value: i['name'],
      ));
    }
    return list;
  }

  List<Widget> _generateChipsList() {
    List<Widget> list = [];
    for (String i in chips.keys) {
      list.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: InputChip(
            label: Text('$i:${chips[i]}'),
            onDeleted: () {
              setState(() {
                chips.remove(i);
              });
            },
          )));
    }
    return list;
  }

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
    if (chips.isEmpty) {
      if (context.mounted) {
        FlutterGeneralServices.showSnackBar(
            context, 'Selezionare almeno una tecnologia');
        return;
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
      //TODO inserire anche chips per il candidato
      var conn = await MySQLServices.connectToMySQL();
      List<String> coppieChiaveValore =
          chips.entries.map((entry) => '${entry.key}:${entry.value}').toList();
      await MySQLServices.appendRowCandidates(
          conn,
          '${Provider.of<LoggedInUser>(context, listen: false).name} ${Provider.of<LoggedInUser>(context, listen: false).lastName}',
          _fieldList[0].text,
          _fieldList[1].text,
          _fieldList[2].text,
          _fieldList[3].text,
          _fieldList[4].text,
          coppieChiaveValore.join(" | "),
          base64EncodedData);
      await MySQLServices.connectClose(conn);

      for (TextEditingController i in _fieldList) {
        i.clear();
      }
      setState(() {
        chips.clear();
      });

      SystemChannels.textInput.invokeMethod('TextInput.hide');

      if (context.mounted) {
        Navigator.pop(context);
        FlutterGeneralServices.showSnackBar(context, 'Caricamento effettuato');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        FlutterGeneralServices.showSnackBar(
            context, 'Errore in fase di caricamento');
      }
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
          //TODO refactor this widget
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        width: 2.0,
                        color: Colors.grey, // Colore del bordo
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FutureBuilder(
                        future: _getTecFromDb(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: LogoColor.greenLogoColor,
                              ),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                              'Elenco vuoto',
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Errore: ${snapshot.error}'),
                            );
                          } else {
                            List<DropdownMenuItem<String>> data =
                                snapshot.data as List<DropdownMenuItem<String>>;
                            return DropdownButton<String>(
                              onChanged: (String? value) async {
                                String seniority = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectGrade();
                                    });
                                _addChips(value!, seniority);
                              },
                              isExpanded: true,
                              hint: Text(
                                chips.isEmpty
                                    ? 'Seleziona una o più tecnologie'
                                    : '${chips.keys.length} element${chips.keys.length > 1 ? 'i' : 'o'} selezionat${chips.keys.length > 1 ? 'i' : 'o'}',
                                style: chips.keys.isEmpty
                                    ? null
                                    : kUserPwdTextStyle,
                              ),
                              underline: Container(),
                              items: data,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            children: _generateChipsList(),
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
