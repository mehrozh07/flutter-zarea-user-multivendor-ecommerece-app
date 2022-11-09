import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  static const id = '/favorite-screen';
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Favorite Screen', style: TextStyle(color: Colors.black26, fontSize: 20),),
      ),
    );
  }
}
