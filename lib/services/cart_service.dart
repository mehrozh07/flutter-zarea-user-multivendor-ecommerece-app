import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User? user = FirebaseAuth.instance.currentUser;

  Future<Future<DocumentReference<Map<String, dynamic>>>> addToCart(document) async{
  cart.doc(user?.uid).set({
    'user': user?.uid,
    'sellerUid': document['seller']['sellerUid'],
  });
  return cart.doc(user?.uid).collection('products').add({
    'productId': document['productId'],
    'productName': document['productName'],
    'weight': document['weight'],
    'price': document['price'],
    'comparePrice': document['comparePrice'],
    'sku': document['sku'],
    'quantity': 1,
  });
  }

  Future<void> updateCart(documentId,quantity) async{
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user?.uid).collection('products').doc(documentId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Product does not exist in cart!");
      }
      transaction.update(documentReference, {'quantity': quantity});
      return quantity;
    })
        .then((value) => print("Follower count updated to $value"))
        .catchError((error) => print("Failed to update user followers: $error"));
  }
  Future<void> deleteCart(docId) async{
    cart.doc(user?.uid).collection('products').doc(docId).delete();
  }

  Future<void> checkCart(docId) async{
    final snapShot = await cart.doc(user?.uid).collection('products').get();
    if(snapShot.docs.length==0){
      cart.doc(user?.uid).delete();
    }
  }
}