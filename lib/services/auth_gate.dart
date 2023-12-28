import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_smarthome/login/login.dart';
import 'package:flutter_app_smarthome/login/lyr_homepage.dart';
import 'package:flutter_app_smarthome/login/lyr_login.dart';
import 'package:flutter_app_smarthome/login/lyr_register.dart';
import 'package:flutter_app_smarthome/services/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return LoginPage();
          }

          //user is NOT Logged in
          else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
