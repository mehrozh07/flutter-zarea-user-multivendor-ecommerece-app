import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService{
  CollectionReference reference = FirebaseFirestore.instance.collection('category');
  CollectionReference featured = FirebaseFirestore.instance.collection('products');
}