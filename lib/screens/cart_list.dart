import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/services/cart_service.dart';
import 'package:zarea_user/widgets/cart_card.dart';

class CartList extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;
  const CartList({Key? key,this.documentSnapshot}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartService services = CartService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: services.cart.doc(services.user!.uid).collection('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: snapshot.data!.docs.map((DocumentSnapshot? document) {
            return CartCard(
              snapshot: document,
            );
          }).toList(),
        );
      },
    );
  }
}
