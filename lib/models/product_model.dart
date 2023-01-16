import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
   String? productName, productCategory, image, weight,brand, shipName;
   int? productPrice, comparedPrice;
   DocumentSnapshot? documentSnapshot;

   ProductModel(
      {this.productName,
      this.productCategory,
      this.image,
      this.weight,
      this.brand,
      this.shipName,
      this.productPrice,
         this.documentSnapshot,
      this.comparedPrice});
   }