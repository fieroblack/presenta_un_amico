import 'package:flutter/material.dart';

class LogoTemplate extends StatelessWidget {
  const LogoTemplate({super.key, required List<Widget> listWidget})
      : _listWidget = listWidget;

  final List<Widget> _listWidget;

  List<Widget> buildScreen(List<Widget> list) {
    List<Widget> list = [];

    list.add(
      Image.asset(
        'assets/images/iagica_logo.png',
        scale: 12,
      ),
    );

    list.addAll(_listWidget);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildScreen(_listWidget),
      ),
    );
  }
}
