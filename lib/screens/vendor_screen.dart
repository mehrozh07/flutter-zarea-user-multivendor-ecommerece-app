import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarea_user/product_widgets/featured_products.dart';
import 'package:zarea_user/product_widgets/best_selling.dart';
import 'package:zarea_user/widgets/image_slider.dart';
import '../auth_providers/store_provider.dart';
import '../widgets/category_widgets.dart';
import '../product_widgets/recently_added.dart';

class VendorScreen extends StatefulWidget {
  static const id = "Vendor-Screen";
  const VendorScreen({Key? key}) : super(key: key);

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {

  @override
  Widget build(BuildContext context) {
    var storeProvider = Provider.of<StoreProvider>(context);
    mapLauncher() async{

      GeoPoint location = storeProvider.documentSnapshot!['location'];
      final availableMaps = await MapLauncher.installedMaps;
      // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: "${storeProvider.documentSnapshot!["shopName"]+ "is here"}",
      );
    }
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              SliverAppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
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
                                image: NetworkImage(storeProvider.documentSnapshot!['imageUrl']),
                            )
                          ),
                          child: Container(
                            color: Colors.grey.withOpacity(.7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: [
                                  Text(storeProvider.documentSnapshot!['dialogue'],
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),                                  ),
                                  Text(storeProvider.documentSnapshot!['address'],
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                  Text(storeProvider.documentSnapshot!['email'],
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                  Text("${storeProvider.distance}KM",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                          onPressed: () async{
                                            await launch("tel:${storeProvider.documentSnapshot!['mobile']}");

                                          },
                                          icon: Icon(Icons.phone, color: Theme.of(context).primaryColor,),
                                      ),
                                      IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: (){
                                          mapLauncher();
                                        },
                                        icon: Icon(Icons.map, color: Theme.of(context).primaryColor),
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
                title:  Text('${storeProvider.documentSnapshot!['shopName']}',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ];
          },
          body: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children:   [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SliderWidget(),
              ),
              const VendorCategory(),
               BestSelling(),
              FeaturedCollection(),
              RecentlyAdded(),
            ],
          )
      ),
    );
  }
}