import 'package:flutter/material.dart';
import 'package:presenta_un_amico/services/login_gate.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:presenta_un_amico/utilities/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoggedInUser(),
      child: const MyApp(),
    ),
  );
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
      home: const LoginGate(),
    );
  }
}
