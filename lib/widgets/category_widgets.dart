import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/store_provider.dart';

import '../screens/product_list_screen.dart';
import '../services/product_service.dart';

class VendorCategory extends StatefulWidget {
  const VendorCategory({Key? key}) : super(key: key);

  @override
  State<VendorCategory> createState() => _VendorCategoryState();
}

class _VendorCategoryState extends State<VendorCategory> {

  List catList = [];

  @override
  void didChangeDependencies() {
    final vendorCategory = Provider.of<StoreProvider>(context);
    FirebaseFirestore.instance
        .collection('products').where("seller.sellerUid", isEqualTo: vendorCategory.documentSnapshot?['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          catList.add(doc["category"]["mainCategory"]);
        });
      }
    });
    super.didChangeDependencies();
  }
  ProductService productService = ProductService();
  @override
  Widget build(BuildContext context) {
var storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder(
      future:productService.reference.get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          const Text('Something Went Wrong');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: Text('Saber kr Bahi Zara Data Load hu rha h'),);
        }
        if(catList.isEmpty){
          return const Center(child: Text('No Category Available'),);
        }
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/ZAREA.png'))
                  ),
                  child:  const Center(
                    child: Text('Shop By Category', style: TextStyle(
                      shadows: [
                        Shadow(
                          offset: Offset(2.0,2.0),
                          blurRadius: 3,
                          color: Colors.black,
                        )
                      ],
                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white70,
                    ),),
                  ),
                ),
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: (){
                      storeProvider.selectedByCategory(documentSnapshot['name']);
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: const RouteSettings(name: ProductListScreen.id),
                        screen:  const ProductListScreen(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              )
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Image.network(
                                      documentSnapshot['image'],
                                      fit: BoxFit.cover),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8),
                                  child: Text("${documentSnapshot['name']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                ) ;

              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
