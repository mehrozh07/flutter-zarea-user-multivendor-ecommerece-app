import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/store_provider.dart';
import 'package:zarea_user/constants/constants.dart';
import 'package:zarea_user/screens/vendor_screen.dart';
import 'package:zarea_user/services/store_services.dart';

class NearestStore extends StatefulWidget {
  static const id = 'nearest-store-screen';
  const NearestStore({Key? key}) : super(key: key);

  @override
  _NearestStoreState createState() => _NearestStoreState();
}

class _NearestStoreState extends State<NearestStore> {
  final StoresServices _storeServices = StoresServices();
  PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();

  @override
  void didChangeDependencies() {
    final storeProvider = Provider.of<StoreProvider>(context);
    storeProvider.determinePosition().then((position){
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
    super.didChangeDependencies();
  }

  double latitude = 0.0;
  double longitude = 0.0;

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      location.latitude,
      location.longitude,
    );
    var distanceInKM = distance / 1000;
    return distanceInKM.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String getDistance(location) {
      var distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        location.latitude,
        location.longitude,
      );
      var distanceInKM = distance / 1000;
      return distanceInKM.toStringAsFixed(2);
    }

    return StreamBuilder<QuerySnapshot?>(
      stream: _storeServices.getTopPickedStore(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapShot) {
        if (!snapShot.hasData) {
          return  Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor),
        ));
        }
        List shopDistance = [];
        for (int i = 0; i <= snapShot.data!.docs.length - 1; i++) {
          var distance = Geolocator.distanceBetween(
              latitude,
              longitude,
              snapShot.data!.docs[i]['location'].latitude,
              snapShot.data!.docs[i]['location'].longitude);
          var distanceInKM = distance / 1000;
          shopDistance.add(distanceInKM);
        }
        shopDistance.sort();
        if (shopDistance[0] <0) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RefreshIndicator(
                child: PaginateFirestore(
                  bottomLoader: SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  header: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 20,
                          ),
                          child: Text(
                            'All Nearby Stores',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 10,
                          ),
                          child: Text(
                            'Find out quality products Nearby You',
                            style: TextStyle(
                                fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilderType: PaginateBuilderType.listView,
                  itemBuilder: (context, documentSnapShot, index) {
                    final document = documentSnapShot[index].data() as Map?;
                    return GestureDetector(
                      onTap: (){
                        debugPrint(document['uid']);
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: VendorScreen.id),
                          screen: const VendorScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54,
                                      width: 2),
                                  borderRadius: const BorderRadius.all(Radius.circular(4))
                                ),
                                child: Card(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: !snapShot.hasData
                                        ? Center(child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                    )):Image.network(
                                        document!['imageUrl'],
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${document!['shopName']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '${document['dialogue']}',
                                    maxLines: 2,
                                    style: cardStyle,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width-250,
                                    child: Text(
                                      '${document['address']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: cardStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '${getDistance(document['location'])}KM',
                                    overflow: TextOverflow.ellipsis,
                                    style: cardStyle,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '4.0',
                                        style: cardStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  query: _storeServices.getNearByStore(),
                  listeners: [
                    refreshedChangeListener,
                  ],
                  footer: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Text(
                              "**That's all folks**",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          Image.asset('assets/images/city.png',
                            color: Colors.grey,
                            width: double.infinity,),
                          Positioned(
                            right: 10.0,
                            top: 80,
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    'Made by: ',
                                      style: GoogleFonts.poppins(
                                        textStyle:  const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 2,
                                        ),
                                      )
                                  ),
                                  Text('Muneeb Danish',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 2,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onRefresh: () async {
                  refreshedChangeListener.refreshed = true;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
