import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/form_widget.dart';
import 'package:presenta_un_amico/screens/list_widget.dart';
import 'package:presenta_un_amico/utilities/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late Widget _bodyWidget;
  @override
  void initState() {
    _bodyWidget = FormWidget();
    super.initState();
  }

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _bodyWidget = FormWidget();
          break;
        case 1:
          _bodyWidget = const ListWidgetCandidates();
          break;
        default:
          _bodyWidget = FormWidget();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _bodyWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _changePage(index);
        },
        selectedItemColor: LogoColor.greenLogoColor,
        iconSize: 35.0,
        selectedFontSize: 18.0,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
            ),
            label: 'Presenta',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'Consulta',
          ),
        ],
      ),
    );
  }
}
