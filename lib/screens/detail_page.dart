import 'package:flutter/material.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key,
      required int id,
      required String name,
      required String lastName,
      required DateTime date})
      : _date = date,
        _lastName = lastName,
        _name = name,
        _id = id;

  final int _id;
  final String _name;
  final String _lastName;
  final DateTime _date;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Id: ${_id.toString()}',
              style: kTitleStyle,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _name.toString(),
                  style: kTitleStyle,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  _lastName.toString(),
                  style: kTitleStyle,
                )
              ],
            ),
            Text(
              'Data inserimento: ${_date.day}/${_date.month}/${_date.year}',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SfPdfViewer.asset('assets/pdf/prova.pdf'),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
