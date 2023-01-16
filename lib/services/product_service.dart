import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zarea_user/utils/error_message.dart';

class ProductService{
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference reference = FirebaseFirestore.instance.collection('category');
  CollectionReference featured = FirebaseFirestore.instance.collection('products');
  CollectionReference favourite = FirebaseFirestore.instance.collection('favProducts');

   updateFavourite(isLiked, productId, context){
     if(isLiked){
       featured.doc(productId).update({
         "favorites": FieldValue.arrayUnion([user?.uid]),
       });
       Utils.showMessage('product added to favorite', context);
     }else{
       featured.doc(productId).update({
         "favorites": FieldValue.arrayRemove([user?.uid]),
       });
       Utils.showMessage('product removed to favorite', context);
     }
   }
}