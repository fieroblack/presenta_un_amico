import 'package:flutter/material.dart';
import 'package:presenta_un_amico/screens/main_page.dart';
import 'package:presenta_un_amico/services/user_model.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';

class LoginGate extends StatelessWidget {
  const LoginGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoggedInUser>(
      builder: (context, auth, child) {
        if (auth.loggedIn) {
          print('auth');
          return MainPage();
        } else {
          print('auth no');
          return LoginScreen();
        }
      },
    );
  }
}
