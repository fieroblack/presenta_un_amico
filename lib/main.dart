import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/login_screen.dart';
import 'package:presenta_un_amico/utilities/constants.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Presenta un' amico",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LogoColor.greenLogoColor),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
