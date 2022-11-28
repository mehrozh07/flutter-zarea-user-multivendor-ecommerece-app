import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/store_provider.dart';
import 'package:zarea_user/product_widgets/product_card_widget.dart';
import 'package:zarea_user/services/product_service.dart';

class ProductList extends StatelessWidget {
  static const id = 'Product-List';

  final DocumentSnapshot? snapshot;
  ProductList({Key? key,this.snapshot}) : super(key: key);


  ProductService productService = ProductService();
  @override
  Widget build(BuildContext context) {
    var storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: productService.featured
          .where('published', isEqualTo: true)
          .where('category.mainCategory', isEqualTo: storeProvider.selectCategory).get(),
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
            // Container(
            //   height: 50,
            //   color: Colors.grey,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 8, right: 8),
            //     child: ListView(
            //       padding: EdgeInsets.zero,
            //       shrinkWrap: true,
            //       physics: const BouncingScrollPhysics(),
            //       scrollDirection: Axis.horizontal,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(left: 6, right: 2),
            //           child: Chip(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //               label: Text('Category'),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(left: 6, right: 2),
            //           child: Chip(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             label: Text('Category'),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(left: 6, right: 2),
            //           child: Chip(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             label: Text('Category'),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(left: 6, right: 2),
            //           child: Chip(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             label: Text('Category'),
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            // ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child:  Text('${snapshot.data?.docs.length} Items',),
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
