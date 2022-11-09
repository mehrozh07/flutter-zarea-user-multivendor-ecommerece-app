import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/widgets/cart_buttons/save_later.dart';
import 'add_to_cart.dart';


class BottomSheetWidget extends StatelessWidget {
  final DocumentSnapshot? snapshot;
  const BottomSheetWidget({Key? key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SaveLater(snapshot: snapshot,),
          AddToCartWidget(snapshot: snapshot),
        ],
      ),
    );
  }
}
