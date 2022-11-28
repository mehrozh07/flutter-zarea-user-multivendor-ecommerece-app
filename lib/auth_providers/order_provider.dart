import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider extends ChangeNotifier{
 User? user = FirebaseAuth.instance.currentUser;

 String? status;

 orderStatus(status){
   this.status = status;
   notifyListeners();
 }
}