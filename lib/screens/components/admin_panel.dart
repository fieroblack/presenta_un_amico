import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presenta_un_amico/screens/components/custom_text_input.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';

import 'package:presenta_un_amico/services/mysql-services.dart';

import '../../utilities/constants.dart';

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
                  setState(() {
                    _activate = !_activate;
                  });

                  await _activateIter();
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
              SizedBox(height: 15.0),
              info_interview_tab(
                stepNumber: 2,
                id: widget._id.toString(),
                label: 'Colloquio tecnico',
              ),
              SizedBox(height: 15.0),
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
                    onPressed: () {
                      setState(() {
                        _endSuccessProcess(false);
                      });
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
                    onPressed: () {
                      setState(() {
                        _endSuccessProcess(true);
                      });
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
        return Center(
          child: Text('successo'),
        );
      case 'failed':
        return Center(
          child: Text('fallito'),
        );
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

class info_interview_tab extends StatelessWidget {
  info_interview_tab({
    super.key,
    required String label,
    required String id,
    required int stepNumber,
  })  : _stepNumber = stepNumber,
        _id = id,
        _label = label;

  final String _label;
  final String _id;
  final int _stepNumber;
  final TextEditingController controller = TextEditingController();

  Future<String> _futureDatas() async {
    dynamic result = '';
    try {
      result = await MySQLServices.genericSelect('iter',
          param: "id_candidatura='$_id'");
    } catch (e) {
      throw Exception("Error: $e");
    }
    return result.first['note_${_stepNumber}_step'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(25.0)),
      child: Column(
        children: [
          Text(
            _label,
            textAlign: TextAlign.center,
          ),
          FutureBuilder(
              future: _futureDatas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CustomTextInput(
                      label: 'Note',
                      readOnly: false,
                      controller: controller,
                      textCapitalization: true,
                      kType: TextInputType.text,
                      maxCharacter: 255);
                } else {
                  controller.text = snapshot.data!;
                  return CustomTextInput(
                      label: 'Note',
                      readOnly: false,
                      controller: controller,
                      textCapitalization: true,
                      kType: TextInputType.text,
                      maxCharacter: 255);
                }
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).canvasColor,
                ),
                onPressed: () async {
                  try {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');

                    await MySQLServices.manageIter(
                        "note_${_stepNumber}_step='${controller.text}'", _id);
                    FlutterGeneralServices.showSnackBar(
                        context, 'Modifica avvenuta con successo');
                  } catch (e) {
                    FlutterGeneralServices.showSnackBar(
                        context, 'Si è verificato un problema');
                    throw Exception("Error: $e");
                  }
                },
                child: Icon(
                  Icons.check,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }
}
