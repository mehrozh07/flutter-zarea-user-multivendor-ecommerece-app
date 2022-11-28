import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CouponProvider extends ChangeNotifier{
  bool? _expired;
  bool? get expired => _expired;
  DocumentSnapshot? _document;
  DocumentSnapshot? get document => _document;
  int discountRate = 0;
 getCouponDetails(title, sellerId) async{
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('coupon').doc(title).get();
  if(snapshot.exists){
    _document = snapshot;
    notifyListeners();
    if(snapshot['sellerId'] == sellerId){
      checkExpiryDate(snapshot);
    }
  }else{
    _document = null;
    notifyListeners();
  }
}
   checkExpiryDate(DocumentSnapshot documentSnapshot) async{
  DateTime dateTime = documentSnapshot['expiryDate'].toDate();
  var dateDifference =  dateTime.difference(DateTime.now()).inDays;
  if(dateDifference<0){
    _expired = true;
    notifyListeners();
  }else{
    _document = documentSnapshot;
  _expired = false;
  discountRate = documentSnapshot['discount'];
  notifyListeners();
  }
  }
}