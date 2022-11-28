import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderService{
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  Future<DocumentReference> saveOrder(Map<String, dynamic> data){
   var result = order.add(data);
return result;
  }
  Color statusColor(document){
    if(document['orderStatus']=="Rejected"){
      return Colors.red;
    }else if(document['orderStatus']=="Accepted"){
      return Colors.blueGrey.shade400;
    }else if(document['orderStatus']=="PickUp"){
      return Colors.pink;
    }else if(document['orderStatus']=="On the Way"){
      return Colors.deepPurpleAccent;
    }else if(document['orderStatus']=="Delivered"){
      return Colors.lightGreen;
    }
    return Colors.orange;
  }

  Icon statusIcons(document){
    if(document['orderStatus']=="Accepted"){
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
    }else if(document['orderStatus']=="PickUp"){
      return Icon(Icons.cases, color: statusColor(document),);
    }else if(document['orderStatus']=="On the Way"){
      return Icon(Icons.delivery_dining, color: statusColor(document),);
    }else if(document['orderStatus']=="Delivered"){
      return Icon(Icons.shopping_bag_outlined, color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
  }

  String statusComment(document){
    if(document['orderStatus']=="Rejected"){
      return "Your order is rejected by shop admin";
    }else  if(document['orderStatus']=="PickUp"){
      return 'Your order is picked up by ${document['deliveryBoy']['name']}';
    }else if(document['orderStatus']=="On the Way"){
      return 'Your order is on the way by ${document['deliveryBoy']['name']}';
    }else if(document['orderStatus']=="Delivered"){
      return 'Your order is delivered by ${document['deliveryBoy']['name']} successfully';
    }else if(document['orderStatus']=="Accepted"){
      return 'Your order is accepted by ${document['seller']['shopName']}';
    }
    return 'Your order is accepted by ${document['seller']['shopName']}';
  }
}