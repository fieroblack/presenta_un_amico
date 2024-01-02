import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
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

  Future<List<Widget>> _recoverData() async {
    List<Widget> list = [];
    try {
      print('-----------------');
      var conn = await MySQLServices.connectToMySQL();
      var datas = await MySQLServices.readPdfFile(conn, _id);
      await MySQLServices.connectClose(conn);

      list.add(SfPdfViewer.memory(datas));
    } catch (e) {
      print(e);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _recoverData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: LogoColor.greenLogoColor,
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          print('snapshot.data!.isEmpty');
          return Center(
            child: CircularProgressIndicator(
              color: LogoColor.greenLogoColor,
            ),
          );
        } else if (snapshot.hasError) {
          print('snapshot.hasError');
          return Placeholder();
        } else {
          print('ok');
          List<Widget> data = snapshot.data as List<Widget>;
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
                    padding: EdgeInsets.all(25.0),
                    child: data[0],
                  )),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

//
// Dialog(
// child: Container(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Text(
// 'Id: ${_id.toString()}',
// style: kTitleStyle,
// textAlign: TextAlign.center,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// _name.toString(),
// style: kTitleStyle,
// ),
// const SizedBox(
// width: 10.0,
// ),
// Text(
// _lastName.toString(),
// style: kTitleStyle,
// )
// ],
// ),
// Text(
// 'Data inserimento: ${_date.day}/${_date.month}/${_date.year}',
// textAlign: TextAlign.center,
// ),
// Expanded(
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// //child: SfPdfViewer.asset('assets/pdf/prova.pdf'),
// child: SfPdfViewer.memory(bytes),
// ),
// ),
// ],
// ),
// ),
// );
