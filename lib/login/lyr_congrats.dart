import 'package:flutter/material.dart';
import 'package:flutter_app_smarthome/login/login.dart';
import 'package:flutter_app_smarthome/login/lyr_login.dart';

class LayarCongrats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 233, 194),
        body: ListView(
          children: [
            SizedBox(height: 250),
            Text(
              "Congratulation, \n You have successfully Registered👋🏻",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              "Click Login to Login",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 179, 223, 218),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
                ],
              ),
            ),
          ],
        ));
  }
}
