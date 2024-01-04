import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/flutter_general_services.dart';

class ButtonFileScanner extends StatelessWidget {
  const ButtonFileScanner({
    super.key,
    required List<TextEditingController> controller,
  }) : _controller = controller;

  final List<TextEditingController> _controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        //TODO write a function to select file
        FilePickerResult? res = await FilePicker.platform.pickFiles(
            withData: true, type: FileType.custom, allowedExtensions: ['PDF']);
        if (res != null) {
          _controller[0].text = res.files.first.path.toString();
          _controller[1].text = res.files.first.name.toString();
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
