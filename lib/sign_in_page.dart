import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:project_manager/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool connected;
  // noInternet() {
  //   return AlertDialog();
  // }

  Future<bool> _checkConnectivity() async {
    print('init');
    bool connect;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connected = false;
      });
    }
    return connect;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _checkConnectivity();
  // }

  @override
  Widget build(BuildContext context) {
    // bool connected = false;
    // _checkConnectivity().then((internet) {
    //   setState(() {
    //     connected = internet;
    //   });
    // });
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 15),
            child: Text(
              'App Creator  : ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 15),
            child: Container(
              height: 100,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                // shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage("assets/p5.jpeg"), fit: BoxFit.fill),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffb121212),
      body: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 12, top: 8),
                  child: Text(
                    "Email Id",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff313131),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 8,
                        ),
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          decoration: InputDecoration.collapsed(
                            hintText: "",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 12, top: 8),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff313131),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 8,
                        ),
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          decoration: InputDecoration.collapsed(
                            hintText: "",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                GestureDetector(
                  onTap: () async {
                    await _checkConnectivity();
                    if (connected) {
                      context.read<AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                    } else {
                      Flushbar(
                        borderWidth: 2,
                        duration: Duration(seconds: 2),
                        borderColor: Colors.orangeAccent,
                        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                        titleText: Text(
                          'No Internet',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w900),
                        ),
                        borderRadius: 20,
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.orangeAccent,
                        ),
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.black,
                        messageText: Text(
                          'Please check your internet connection!',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w600),
                        ),
                        margin: EdgeInsets.all(10),
                        animationDuration: Duration(seconds: 1),
                      )..show(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
