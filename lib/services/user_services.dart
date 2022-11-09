import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UserServices{
   String collections = 'users';
   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

   Future<void> createUserData(Map<String, dynamic> values)async {
      String? id = values['id'];
    await  _firebaseFirestore.collection(collections).doc(id).set(values);
   }

   Future<void> updateUserData(Map<String, dynamic> values)async {
     String? id = values['id'];
    await  _firebaseFirestore.collection(collections).doc(values[id]).update(values);
   }

   Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async{
     var result = await _firebaseFirestore.collection(collections).doc(id).get();
            return result;
   }
}