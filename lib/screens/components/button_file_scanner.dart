import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';

class ButtonFileScanner extends StatelessWidget {
  ButtonFileScanner({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        //TODO write a function to select file
        FilePickerResult? res =
            await FilePicker.platform.pickFiles(withData: true);
        if (res != null) {
          _controller.text = res.files.first.path.toString();
          print('selected: ${res.files.first.bytes}');
        } else {
          if (context.mounted) {
            FlutterGeneralServices.showSnackBar(context, 'No file selected');
          }
        }
      },
      icon: const Icon(
        Icons.document_scanner,
        size: 35.0,
      ),
    );
  }
}
