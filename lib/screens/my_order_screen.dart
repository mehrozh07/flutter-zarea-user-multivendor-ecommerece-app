import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  static const id = '/order-screen';
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Order Screen', style: TextStyle(color: Colors.black26, fontSize: 20),),
      ),
    );
  }
}
