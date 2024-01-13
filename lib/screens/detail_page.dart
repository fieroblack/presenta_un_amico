import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/components/admin_panel.dart';
import 'package:presenta_un_amico/services/mysql-services.dart';
import 'package:presenta_un_amico/services/user_model.dart';

import 'package:presenta_un_amico/utilities/constants.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required int id,
    required String name,
    required String lastName,
    required DateTime date,
    required String skills,
    required dynamic Function() func,
  })  : _func = func,
        _skills = skills,
        _date = date,
        _lastName = lastName,
        _name = name,
        _id = id;

  final int _id;
  final String _name;
  final String _lastName;
  final DateTime _date;
  final String _skills;
  final Function() _func;

  Future<List<Widget>> _recoverData() async {
    List<Widget> list = [];
    try {
      var datas = await MySQLServices.readPdfFile(_id);

      list.add(SfPdfViewer.memory(datas));
    } catch (e) {
      throw Exception('Error: $e');
    }
    return list;
  }

  List<Widget> _skillsListWidget() {
    List<Widget> list = [];

    for (String skill in _skills.split("|")) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            '${skill.split(":")[0]} : ${skill.split(":")[1]}',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          print('didPop');
          _func();
        }
      },
      child: FutureBuilder(
        future: _recoverData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: LogoColor.greenLogoColor,
                ),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text(
                  'Elenco vuoto',
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Expanded(
              child: Center(
                child: Text('Errore: ${snapshot.error}'),
              ),
            );
          } else {
            List<Widget> data = snapshot.data as List<Widget>;
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: _skillsListWidget(),
                      ),
                      Text(
                        'Data inserimento proposta: ${_date.day}/${_date.month}/${_date.year}',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 500.0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          //child: SfPdfViewer.asset('assets/pdf/prova.pdf'),
                          child: data[0],
                        ),
                      ),
                      Provider.of<LoggedInUser>(context).admin
                          ? AdminPanel(
                              id: _id,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
