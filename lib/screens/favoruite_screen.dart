import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarea_user/product_widgets/product_card_widget.dart';
import '../services/product_service.dart';

class FavoriteScreen extends StatelessWidget {
  static const id = '/favorite-screen';
   FavoriteScreen({Key? key}) : super(key: key);
  ProductService productService = ProductService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Favourite Products',
            style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          FutureBuilder<QuerySnapshot>(
            future: productService.featured
                .where('favorites', arrayContains: FirebaseAuth.instance.currentUser?.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  return ProductCard(snapshot: document);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}