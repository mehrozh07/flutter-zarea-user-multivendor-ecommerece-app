import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarea_user/services/cart_service.dart';

class AnotherCounter extends StatefulWidget {
  final DocumentSnapshot? snapshot;
  const AnotherCounter({Key? key, this.snapshot}) : super(key: key);

  @override
  State<AnotherCounter> createState() => _AnotherCounterState();
}

class _AnotherCounterState extends State<AnotherCounter> {
  User? user = FirebaseAuth.instance.currentUser;
  int quantity = 1;
  bool exist = false;
  bool updating = false;
  CartService service = CartService();
  String? docId;

   void getCart() async {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user?.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.snapshot!['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isNotEmpty){
        for (var doc in querySnapshot.docs) {
          if (doc['productId'] == widget.snapshot?['productId']) {
            setState(() {
              quantity = doc['quantity'];
              docId = doc.id;
              exist = true;
            });
          }
        }
      }else{
       setState(() {
         exist = false;
       });
      }
    });
  }
@override
  void initState() {
   getCart();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     getCart();
    return exist
        ? Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.pink,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      updating = true;
                    });

                    if (quantity == 1) {
                      service.deleteCart().then((value) {
                        updating = false;
                        exist = false;
                      });
                      service.checkCart(docId);
                    }
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                      var total = quantity* widget.snapshot!['price'];
                      service
                          .updateCart(docId, quantity, total)
                          .then((value) {
                        updating = false;
                      });
                    }
                  },
                  child: quantity == 1
                      ? const Icon(Icons.delete)
                      : const Icon(
                    Icons.remove,
                    color: Colors.pink,
                  )),
            ),
          ),
          Container(
              width: 30,
              height: double.infinity,
              color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.only(left: 3, right: 3),
                child: Center(
                    child: FittedBox(
                        child: updating
                            ? const CircularProgressIndicator()
                            : Text(
                          quantity.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ))),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: InkWell(
                onTap: () {
                  setState(() {
                    updating = true;
                    quantity++;
                  });
                  var total = quantity* widget.snapshot!['price'];
                  service.updateCart(docId, quantity, total).then((value) {
                    updating = false;
                  });
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.pink,
                )),
          ),
        ],
      ),
    )
        : InkWell(
      onTap: () {
        EasyLoading.show(status: "Adding");
        service.checkSeller().then((value){
          if(value == widget.snapshot?['seller']['sellerUid']){
            setState(() {
              exist = true;
            });
            service.addToCart(docId).then((value) {
              EasyLoading.showSuccess("successfully");
            });
          }else{
            EasyLoading.dismiss();
          }
          if(value==null){
            setState(() {
              exist = true;
            });
            service.addToCart(docId).then((value) {
              EasyLoading.showSuccess("successfully");
            });
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.pink,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30, right: 30, bottom: 7, top: 7),
          child: Text(
            'Add',
            style: GoogleFonts.poppins(
                textStyle:
                const TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
