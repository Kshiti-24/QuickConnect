import 'dart:developer';

import 'package:chatterbox/Network/APIs.dart';
import 'package:chatterbox/Screens/home_screen.dart';
import 'package:chatterbox/Screens/login_screen.dart';
import 'package:chatterbox/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));
      if (APIs.auth.currentUser != null) {
        log("\nUser already logged in");
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        log("\nUser need to log in first");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: size.height * 0.15,
              right: size.width * 0.25,
              width: size.width * 0.5,
              child: Lottie.asset("assets/images/login.json")),
          Positioned(
              bottom: size.height * .15,
              width: size.width,
              child: const Text('MADE BY KSHITIZ WITH ❤️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      letterSpacing: .5,
                      fontFamily: "ABeeZee"))),
        ],
      ),
    );
  }
}
