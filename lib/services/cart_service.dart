import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
   cart.doc(user!.uid).set({
     'users': user?.uid,
     'sellerUid': document['seller']['sellerUid'],
     'shopName': document['seller']['shopName'],
  });
  return cart.doc(user?.uid).collection('products').add({
    'productId': document['productId'],
    'productName': document['productName'],
    'productImage': document['productImage'],
    'weight': document['weight'],
    'price': document['price'],
    'comapredPrice': document['comapredPrice'],
    'sku': document['sku'],
    'quantity': 1,
    'total': document['price']
  });
  }

  Future<void> updateCart(documentId,quantity, total) async{
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user?.uid).collection('products').doc(documentId);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        throw Exception("Product does not exist in cart!");
      }
      transaction.update(documentReference, {'quantity': quantity, 'total': total});
      return quantity;
    })
        .then((value) => print("Follower count updated to $value"))
        .catchError((error) => print("Failed to update user followers: $error"));
  }
  Future<void> deleteCart() async{
    final result = await cart.doc(user?.uid).collection('products').get().then((value){
      for(DocumentSnapshot ds in value.docs){
        ds.reference.delete();
      }
    });
  }

  Future<void> checkCart(docId) async{
    final snapShot = await cart.doc(user?.uid).collection('products').get();
    if(snapShot.docs.isEmpty){
      cart.doc(user?.uid).delete();
    }
  }

  Future<String?> checkSeller() async {
    final snapshot =  await cart.doc(user!.uid).get();
    return snapshot.exists ? snapshot['shopName']: null;
  }

  Future<DocumentSnapshot<Object?>> shopName() async {
    DocumentSnapshot snapshot =  await cart.doc(user!.uid).get();
    return snapshot;
  }
}