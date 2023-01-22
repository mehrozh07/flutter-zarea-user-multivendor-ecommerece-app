import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarea_user/services/product_service.dart';

class SaveLater extends StatefulWidget {
  final DocumentSnapshot? snapshot;
  const SaveLater({Key? key, this.snapshot}) : super(key: key);

  @override
  State<SaveLater> createState() => _SaveLaterState();
}

class _SaveLaterState extends State<SaveLater> {
  ProductService productService = ProductService();
  List favorites = [];
  bool isLiked = false;

getFavProducts(){
  productService.featured.doc(widget.snapshot?.id).get().then((document){
    setState(() {
      favorites = document['favorites'];
    });
    if(favorites.contains(FirebaseAuth.instance.currentUser?.uid)){
      setState(() {
        isLiked = true;
      });
    }else{
      setState(() {
        isLiked = false;
      });
    }
  });
}

@override
  void initState() {
    getFavProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const RoundedRectangleBorder(
                  side: BorderSide.none),
              backgroundColor: Colors.transparent,
            ),
            onPressed:() async{
              setState(() {
                isLiked = !isLiked;
              });
              productService.updateFavourite(isLiked, widget.snapshot?.id, context);
            },
            child: isLiked ? const Icon(Icons.favorite, color: Colors.red) :
            const Icon(Icons.favorite_border, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
