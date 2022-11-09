import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/bottomBar/main_screen.dart';
import 'package:zarea_user/screens/landing_page,dart.dart';
import 'package:zarea_user/screens/welcome_screen.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3), () {
          if(mounted){
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if(user == null){
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              }else{
                Navigator.pushReplacementNamed(context, MainScreen.id);
                //first go to Landing than will decide where to go

              }
            }
            );
          }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png'),
          ],
        ),
      ),
    );
  }
}