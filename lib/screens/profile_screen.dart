import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/screens/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const id = '/profile-screen';
   ProfileScreen({Key? key}) : super(key: key);

 final firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          firebaseAuth.signOut().then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
          });
        }, child: const Text('sign out'),),
      )
    );
  }
}
