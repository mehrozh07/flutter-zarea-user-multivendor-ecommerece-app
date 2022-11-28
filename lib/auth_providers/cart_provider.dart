import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zarea_user/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  CartService cartService = CartService();

  double subTotal = 0;
  int quantity = 0;
  QuerySnapshot? snapshot;
  double saving = 0.0;
  bool cod = false;
  DocumentSnapshot? documentSnapshot;
  List _orders = [];
  List get orders => _orders;

  Future<double?> getCartTotal() async {
    double cartTotal = 0.0;
    double saving = 0.0;
    List savingOrder = [];
    QuerySnapshot querySnapshot = await cartService.cart
        .doc(cartService.user?.uid)
        .collection('products')
        .get();
    for (var element in querySnapshot.docs) {
      if(!savingOrder.contains(element.data())){
        savingOrder.add(element.data());
        _orders = savingOrder;
        notifyListeners();
      }
      cartTotal = cartTotal+element['total'];
      saving = saving+((element['comapredPrice']- element['price'])>0 ?
      element['comapredPrice']- element['price']: 0);
    }
    subTotal = cartTotal;
    quantity = querySnapshot.size;
    snapshot  = querySnapshot;
    this.saving = saving;
    notifyListeners();

    return cartTotal;
  }
var distance = 0;
  getDistance(distance){
    this.distance = distance;
    notifyListeners();
  }

  getPaymentMethod(index){
    if(index==0){
      cod = false;
      notifyListeners();
    }else{
      cod = true;
      notifyListeners();
    }
  }

  getShopName() async{
    DocumentSnapshot doc = await cartService.cart.doc(cartService.user!.uid).get();
    if(doc.exists){
      documentSnapshot = doc;
      notifyListeners();
    }else{
      documentSnapshot = null;
      notifyListeners();
    }
  }
}
