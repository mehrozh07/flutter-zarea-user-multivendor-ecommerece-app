import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarea_user/services/cart_service.dart';

import '../counter_widget/counter_widget.dart';

class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot? snapshot;
  const AddToCartWidget({Key? key, this.snapshot}) : super(key: key);

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {

  @override
  void initState() {
   getCartData();
    super.initState();
  }
  bool loading = false;


  void getCartData() async{
    var snapShot  = await cartService.cart.doc(user?.uid).collection('products').get();
    if(snapShot.docs.isEmpty){
   setState(() {
     loading = false;
   });
    }else{
setState(() {
  loading = true;
});
    }
  }
CartService cartService = CartService();
  User? user = FirebaseAuth.instance.currentUser;
  bool exist = false;
  int quantity = 1;
  String? docId;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cart').doc(user?.uid).collection('products')
        .where('productId', isEqualTo: widget.snapshot?['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['productId'] == widget.snapshot?['productId']){
          setState(() {
            exist = true;
            quantity = doc['quantity'];
            docId = doc.id;
          });
        }
        print(doc["productId"]);
      }
    });
    return Expanded(
      flex: 3,
      child: loading ?  const SizedBox(
        height: 56,
        child:  Center(child: CircularProgressIndicator()),
      ): exist? CounterWidget(
        snapshot: widget.snapshot,
        quantity: quantity,
        docId: docId,
      ) :SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(
                side: BorderSide.none),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            EasyLoading.show(status: "Adding");
            cartService.addToCart(widget.snapshot).then((value){
              exist = true;
              EasyLoading.showSuccess("successfully");
            });
          },
          child: Row(
            children: [
              const Icon(Icons.shopping_bag, color: Colors.white,),
              const SizedBox(width: 3,),
              Text(
                'Add to Cart',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}