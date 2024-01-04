import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_app_smarthome/component/custom_form_button.dart';
import 'package:flutter_app_smarthome/component/custom_input_field.dart';
import 'package:flutter_app_smarthome/component/page_header.dart';
import 'package:flutter_app_smarthome/component/page_heading.dart';
import 'package:flutter_app_smarthome/login/login.dart';
import 'package:flutter_app_smarthome/login/lyr_congrats.dart';
import 'package:flutter_app_smarthome/login/lyr_login.dart';
import 'package:flutter_app_smarthome/services/auth_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String strLatLong = 'Belum Mendapatkan Lat dan Long, Silahkan tekan tombol';
  String strAlamat = 'Mencari lokasi...';
  bool loading = false;

  //getLatLong
  Future _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // //getAddress
  Future getAddressFromLongLat(Position position) async {
    List placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);

    Placemark place = placemarks[0];
    setState(() {
      strAlamat = '${place.street}, ${place.subLocality}, ${place.locality}, '
          '${place.postalCode}, ${place.country}';
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _fullName = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameEmail = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  bool _isHidden = true;
  bool _isHidden2 = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleVisibility2() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }

  File? _profileImage;

  final _signupFormKey = GlobalKey<FormState>();

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  void _register() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      //Geolocator mendapatkan latitude
      Position position = await _getGeoLocationPosition();
      strLatLong = '${position.latitude}, ${position.longitude}';

      //user
      UserCredential userCredential =
          await authService.signUpWithEmailandPassword(
        _usernameEmail.text,
        _passwordController.text,
        _fullName.text,
        strLatLong.toLowerCase(),
      );

      User? user = userCredential.user;

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      String errorMessage = 'Terjadi Kesalahan';
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email sudah digunakan';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Format email atau password salah';
        }
      }

      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _showErrorDialog(String errorMessage) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
                const PageHeader(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(
                        title: 'Register',
                      ),
                      //ini widget foto
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // CustomInputField(

                      //     labelText: 'Full Name',
                      //     hintText: 'Your full name',
                      //     isDense: true,
                      //     validator: (textValue) {
                      //       if (textValue == null || textValue.isEmpty) {
                      //         return 'Name field is required!';
                      //       }
                      //       return null;
                      //     }),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      // CustomInputField(
                      //     labelText: 'Email',
                      //     hintText: 'Your email id',
                      //     isDense: true,
                      //     validator: (textValue) {
                      //       if (textValue == null || textValue.isEmpty) {
                      //         return 'Email is required!';
                      //       }
                      //       if (!EmailValidator.validate(textValue)) {
                      //         return 'Please enter a valid email';
                      //       }
                      //       return null;
                      //     }),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      // CustomInputField(
                      //   labelText: 'Password',
                      //   hintText: 'Your Password',
                      //   isDense: true,
                      //   obscureText: true,
                      //   validator: (textValue) {
                      //     if (textValue == null || textValue.isEmpty) {
                      //       return 'Contact password is required!';
                      //     }
                      //     return null;
                      //   },
                      //   suffixIcon: true,
                      // ),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      // CustomInputField(
                      //   labelText: 'Confirm Password',
                      //   hintText: 'Your confirm password',
                      //   isDense: true,
                      //   obscureText: true,
                      //   validator: (textValue) {
                      //     if (textValue == null || textValue.isEmpty) {
                      //       return 'Confirm password is required!';
                      //     }
                      //     return null;
                      //   },
                      //   suffixIcon: true,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: TextField(
                          controller: _fullName,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Full Name',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Your full name',
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // border: OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(width: 3, color: Colors.black),
                            //     borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: TextField(
                          controller: _usernameEmail,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Username/Email',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Your username/email',
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // border: OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(width: 3, color: Colors.black),
                            //     borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Your password',
                            isDense: true,
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // border: OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(width: 3, color: Colors.black),
                            //     borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: TextField(
                          controller: _confirmpasswordController,
                          obscureText: _isHidden2,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'Your confirm password',
                            isDense: true,
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // border: OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(width: 3, color: Colors.black),
                            //     borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              onPressed: _toggleVisibility2,
                              icon: _isHidden2
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      CustomFormButton(
                        innerText: 'Register',
                        onPressed: _register,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account ? ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()))
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff748288),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignupUser() {
    // register user
    if (_signupFormKey.currentState!.validate()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LayarCongrats()));
    }
  }
}
