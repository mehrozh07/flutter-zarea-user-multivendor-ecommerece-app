import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoresServices{
  CollectionReference featured = FirebaseFirestore.instance.collection('vendors');

  getTopPickedStore() {
    return featured.where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true).orderBy('shopName').snapshots();
  }
  getNearByStore(){
    return featured.where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shopName');
  }

  Future<DocumentSnapshot> getStoreDetails(sellerUid) async {
    DocumentSnapshot snapshot = await featured.doc(sellerUid).get();
    return snapshot;
  }

}