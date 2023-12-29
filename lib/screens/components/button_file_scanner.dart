import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ButtonFileScanner extends StatelessWidget {
  const ButtonFileScanner({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        //TODO write a function to select file
        FilePickerResult? res = await FilePicker.platform.pickFiles();
        if (res != null) {
          controller.text = res.files.first.name.toString();
        } else {
          //TODO do something
        }
      },
      icon: const Icon(
        Icons.document_scanner,
        size: 35.0,
      ),
    );
  }
}
