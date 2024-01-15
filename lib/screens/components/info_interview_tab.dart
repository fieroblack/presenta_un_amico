import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/flutter_general_services.dart';
import '../../services/mysql-services.dart';
import 'custom_text_input.dart';

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
