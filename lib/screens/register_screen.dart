import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding:  const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Hero(
              tag: 'assets/images/logo.png',
              child: Image.asset('assets/images/logo.png'),
          ),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),

        ],
      ),
    ),
    );
  }
}
