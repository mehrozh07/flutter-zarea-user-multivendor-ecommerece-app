import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/product_widgets/product_card_widget.dart';
import 'package:zarea_user/services/product_service.dart';

class FeaturedCollection extends StatelessWidget {
  final DocumentSnapshot? snapshot;
  FeaturedCollection({Key? key,this.snapshot}) : super(key: key);


  ProductService productService = ProductService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: productService.featured
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Featured Collection').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:const Center(
                    child:  Center(
                      child: Text('Featured Products',
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              offset: Offset(2.0,2.0),
                              blurRadius: 3,
                              color: Colors.black38,
                            )
                          ],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return ProductCard(snapshot: document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
