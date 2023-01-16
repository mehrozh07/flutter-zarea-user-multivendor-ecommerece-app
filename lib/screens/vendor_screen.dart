import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarea_user/models/product_model.dart';
import 'package:zarea_user/product_widgets/featured_products.dart';
import 'package:zarea_user/product_widgets/best_selling.dart';
import 'package:zarea_user/screens/product_detail.dart';
import 'package:zarea_user/widgets/counter_widget/another_counter.dart';
import 'package:zarea_user/widgets/image_slider.dart';
import '../auth_providers/store_provider.dart';
import '../widgets/category_widgets.dart';
import '../product_widgets/recently_added.dart';

class VendorScreen extends StatefulWidget {
  static const id = "Vendor-Screen";
  static List<ProductModel> productModel = [];
  const VendorScreen({Key? key}) : super(key: key);

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  DocumentSnapshot? snapshot;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
       setState(() {
          snapshot = doc;
         VendorScreen.productModel.add(
           ProductModel(
             brand: doc['brand'],
             comparedPrice: doc['comapredPrice'],
             productCategory: doc['category']['mainCategory'],
             weight: doc['weight'],
             productName: doc['productName'],
             productPrice: int.parse(doc['price']),
             shipName: doc['seller']['shopName'],
             documentSnapshot: doc,
           ) 
         );
       });
      }
    });
    super.initState();
  }
@override
  void dispose() {
    VendorScreen.productModel.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var textSize = MediaQuery.textScaleFactorOf(context);
    var width = MediaQuery.of(context).size.width;
    var storeProvider = Provider.of<StoreProvider>(context);
    mapLauncher() async {
      GeoPoint location = storeProvider.documentSnapshot!['location'];
      final availableMaps = await MapLauncher.installedMaps;
      // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: "${storeProvider.documentSnapshot!["shopName"] + "is here"}",
      );
    }


    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    )),
                actions: [
                  IconButton(
                      onPressed: () => {

                        showSearch(
                          context: context,
                          delegate: SearchPage(
                            onQueryUpdate: print,
                            items: VendorScreen.productModel,
                            searchLabel: 'Search product',
                            suggestion: const Center(
                              child: Text('Filter product by name, price'),
                            ),
                            failure: const Center(
                              child: Text('No product found :('),
                            ),
                            filter: (product) => [
                              product.productName,
                              product.brand,
                              product.productCategory,
                              product.productPrice.toString(),
                            ],
                            // sort: (a, b) => a.compareTo(b),
                            builder: (products){
                              String offer = ((products.documentSnapshot!['comapredPrice']
                                  - products.documentSnapshot!['price'])/products.documentSnapshot!['comapredPrice']*100)
                                  .toStringAsFixed(0);
                              return products.shipName == products.shipName ?
                              Container(
                                height: 185,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                              context,
                                              settings: const RouteSettings(name: ProductDetail.id),
                                              screen:  ProductDetail(document: products.documentSnapshot,),
                                              withNavBar: false,
                                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            );
                                          },
                                          child: Material(
                                            elevation: 5,
                                            borderRadius: BorderRadius.circular(10),
                                            child: SizedBox(
                                              height: 140,
                                              width: 130,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Hero(
                                                    tag: '${products.documentSnapshot!['productImage']}',
                                                    child: Image.network('${products.documentSnapshot!['productImage']}',
                                                      fit: BoxFit.cover,),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text('$offer% OFF',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: textSize*12,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                              ),),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${products.documentSnapshot!['brand']}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: textSize*14,
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                ),),
                                              const SizedBox(height: 5,),
                                              Text('${products.documentSnapshot!['productName']}', style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: textSize*14,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                              ),),
                                              const SizedBox(height: 5,),
                                              Container(
                                                width: width-160,
                                                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  color: Colors.grey.shade400,
                                                ),
                                                child: Text('${products.documentSnapshot!['weight']}Kg', style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: textSize*14,
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                ),),
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  Text('Rs:${products.documentSnapshot!['price'].toString()}', style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize: textSize*14,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                  ),),
                                                  const SizedBox(width: 10,),
                                                  Text('Rs:${products.documentSnapshot!['comapredPrice'].toString()}',
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            decoration: TextDecoration.lineThrough,
                                                            fontSize: textSize*12,
                                                            color: Colors.grey
                                                        )
                                                    ),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){

                                                    },
                                                    child: SizedBox(
                                                      width: width-160,
                                                      height: 50,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children:  [
                                                          CounterForCard(snapshot: products.documentSnapshot,)
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ) :
                              Container();
                            }
                          ),
                        ),
                          },
                      icon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.white,
                      )),
                ],
                floating: true,
                snap: true,
                pinned: true,
                expandedHeight: 280,
                flexibleSpace: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter:
                                    const ColorFilter.linearToSrgbGamma(),
                                image: NetworkImage(
                                    "${storeProvider.documentSnapshot?['imageUrl']}"),
                              )),
                          child: Container(
                            color: Colors.grey.withOpacity(.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: [
                                  Text(
                                    '${storeProvider.documentSnapshot?['dialogue']}',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ),
                                  Text(
                                    '${storeProvider.documentSnapshot?['address']}',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    )),
                                  ),
                                  Text(
                                    '${storeProvider.documentSnapshot?['email']}',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    )),
                                  ),
                                  Text(
                                    "${storeProvider.distance}KM",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    )),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          await launch(
                                              "tel:${storeProvider.documentSnapshot?['mobile']}");
                                        },
                                        icon: Icon(
                                          Icons.phone,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          mapLauncher();
                                        },
                                        icon: Icon(Icons.map,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '${storeProvider.documentSnapshot?['shopName']}',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ];
          },
          body: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SliderWidget(),
              ),
              const VendorCategory(),
              BestSelling(),
              FeaturedCollection(),
              RecentlyAdded(),
            ],
          )),
    );
  }
}