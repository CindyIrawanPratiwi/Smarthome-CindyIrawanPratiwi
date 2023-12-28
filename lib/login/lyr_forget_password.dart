import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_smarthome/component/custom_form_button.dart';
import 'package:flutter_app_smarthome/component/custom_input_field.dart';
import 'package:flutter_app_smarthome/component/page_header.dart';
import 'package:flutter_app_smarthome/component/page_heading.dart';
import 'package:flutter_app_smarthome/login/lyr_forget_password.dart';
import 'package:flutter_app_smarthome/login/lyr_login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  // Fungsi untuk menampilkan pop-up window
  Future<void> _showMessageDialog(String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mereset password
  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      _showMessageDialog(
          'Email reset kata sandi telah dikirim. Silakan periksa kotak masuk Anda.');
    } catch (e) {
      String errorMessage = 'Gagal mereset kata sandi. Silakan coba lagi.';
      _showMessageDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ForgetPasswordPage extends StatefulWidget {
//   const ForgetPasswordPage({Key? key}) : super(key: key);

//   @override
//   State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
// }

// class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
//   final _forgetPasswordFormKey = GlobalKey<FormState>();



//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 247, 233, 194),
//         body: Column(
//           children: [
//             const PageHeader(),
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _forgetPasswordFormKey,
//                     child: Column(
//                       children: [
//                         const PageHeading(
//                           title: 'Forgot password',
//                         ),
//                         CustomInputField(
//                             labelText: 'Email',
//                             hintText: 'Your email id',
//                             isDense: true,
//                             validator: (textValue) {
//                               if (textValue == null || textValue.isEmpty) {
//                                 return 'Email is required!';
//                               }
//                               if (!EmailValidator.validate(textValue)) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             }),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         CustomFormButton(
//                           innerText: 'Submit',
//                           onPressed: _handleForgetPassword,
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           alignment: Alignment.center,
//                           child: GestureDetector(
//                             onTap: () => {
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => const Login()))
//                             },
//                             child: const Text(
//                               'Back to login',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Color(0xff939393),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleForgetPassword() {
//     // forget password
//     if (_forgetPasswordFormKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Submitting data..')),
//       );
//     }
//   }
// }
