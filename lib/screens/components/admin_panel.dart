import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presenta_un_amico/screens/components/custom_text_input.dart';
import 'package:presenta_un_amico/screens/failed_or_success_screen.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';

import 'package:presenta_un_amico/services/mysql-services.dart';

import '../../utilities/constants.dart';
import 'info_interview_tab.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key, required int id}) : _id = id;

  final int _id;

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool _activate = false;

  Future<void> _activateIter() async {
    try {
      await MySQLServices.manageIter(
          "status='inProgress', data_apertura='${DateTime.now()}'",
          widget._id.toString());
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _updateIterProcess(String field, String value) async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      await MySQLServices.manageIter("$field='$value'", widget._id.toString());

      FlutterGeneralServices.showSnackBar(
          context, 'Modifica avvenuta con successo');
    } catch (e) {
      FlutterGeneralServices.showSnackBar(
          context, 'Si è verificato un problema');
      throw Exception("Error: $e");
    }
  }

  Future<void> _endSuccessProcess(bool success) async {
    String parameter = "";

    if (success) {
      parameter = "status='success'";
    } else {
      parameter = "status='failed'";
    }

    try {
      await MySQLServices.manageIter(parameter, widget._id.toString());
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Widget> _iterDatas() async {
    dynamic result = '';
    try {
      print(widget._id);
      result = await MySQLServices.genericSelect('iter',
          param: 'id_candidatura=${widget._id}');
      print(result.first['status']);
    } catch (e) {
      throw Exception('Error: $e');
    }
    switch (result.first['status']) {
      case 'closed':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Attiva candidatura',
              style: kLabelStyle,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Switch(
                activeTrackColor: LogoColor.greenLogoColor,
                value: _activate,
                onChanged: (bool? value) async {
                  await _activateIter();
                  setState(() {
                    _activate = !_activate;
                  });
                })
          ],
        );
      case 'inProgress':
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              info_interview_tab(
                stepNumber: 1,
                id: widget._id.toString(),
                label: 'Colloquio conoscitivo',
              ),
              SizedBox(height: 10.0),
              info_interview_tab(
                stepNumber: 2,
                id: widget._id.toString(),
                label: 'Colloquio tecnico',
              ),
              SizedBox(height: 10.0),
              info_interview_tab(
                stepNumber: 3,
                id: widget._id.toString(),
                label: 'Proposta economica',
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController controller =
                              TextEditingController();
                          return AlertDialog(
                            content: CustomTextInput(
                              label: 'Giudizio finale',
                              readOnly: false,
                              controller: controller,
                              textCapitalization: true,
                              kType: TextInputType.text,
                              maxCharacter: 255,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await _endSuccessProcess(false);
                                    setState(() {
                                      _updateIterProcess(
                                          'final_note', controller.text);
                                    });
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Conferma')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Annulla'))
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'TERMINA',
                      style: kButtonStyle,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LogoColor.greenLogoColor,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController controller =
                              TextEditingController();
                          return AlertDialog(
                            content: CustomTextInput(
                              label: 'Giudizio finale',
                              readOnly: false,
                              controller: controller,
                              textCapitalization: true,
                              kType: TextInputType.text,
                              maxCharacter: 255,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await _endSuccessProcess(true);
                                    setState(() {
                                      _updateIterProcess(
                                          'final_note', controller.text);
                                    });
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Conferma')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Annulla'))
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'SUCCESSO',
                      style: kButtonStyle,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      case 'success':
        return FailedOrSuccessScreen(
          id: widget._id.toString(),
        );

      case 'failed':
        return FailedOrSuccessScreen(id: widget._id.toString());

      default:
        return Text('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _iterDatas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: LogoColor.greenLogoColor,
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
              child: Text(
            'Elenco vuoto',
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Errore: ${snapshot.error}'),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
