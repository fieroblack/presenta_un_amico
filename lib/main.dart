import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/main_page.dart';
import 'package:presenta_un_amico/utilities/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Presenta un' amico",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LogoColor.greenLogoColor),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
