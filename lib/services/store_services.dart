import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoresServices{
  getTopPickedStore() {
    return FirebaseFirestore.instance.collection('vendors').where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true).orderBy('shopName').snapshots();
  }
  getNearByStore(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shopName');
  }

}