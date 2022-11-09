import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/store_provider.dart';
import 'package:zarea_user/screens/vendor_screen.dart';
import 'package:zarea_user/services/store_services.dart';

class TopPickedStore extends StatefulWidget {
  const TopPickedStore({Key? key}) : super(key: key);

  @override
  State<TopPickedStore> createState() => _TopPickedStoreState();
}

class _TopPickedStoreState extends State<TopPickedStore> {
  final StoresServices _storesServices = StoresServices();
  User? user = FirebaseAuth.instance.currentUser;

  String? getDistance(location){
    var distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      location.latitude,
      location.longitude,
    );
    var distanceInKm = distance/1000;
    return distanceInKm.toStringAsFixed(2);
  }

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void didChangeDependencies() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
     storeProvider.determinePosition().then((position){
       setState(() {
         latitude = position.latitude;
         longitude = position.longitude;
       });
     });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var storeProvider = Provider.of<StoreProvider>(context);
    // storeProvider.getUserLocation(context);

    return SizedBox(
      child: StreamBuilder<QuerySnapshot?>(
          stream: _storesServices.getTopPickedStore(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapShot) {
            if (!snapShot.hasData) {
              return const Center(child: CircularProgressIndicator(),
              );
            }
            List shopDistance = [];
            for(int i = 0; i<= snapShot.data!.docs.length-1; i++){
              var distance = Geolocator.distanceBetween(
                  latitude,
                  longitude,
                  snapShot.data?.docs[i]['location'].latitude,
                  snapShot.data?.docs[i]['location'].longitude,
              );
              var distanceInKm = distance/1000;
              shopDistance.add(distanceInKm);
            }
            shopDistance.sort();
            if(shopDistance[0]>10){
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text('Currently We are not servicing in your Area,'
                        ' Please Try Later or another Location',
                      style: GoogleFonts.poppins(
                          textStyle:  TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                      )),),
                  ),
                ),
              );
            }
              return SizedBox(
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 20),
                        child: Row(
                          children: [
                            Image.asset('assets/images/like.gif', height: 35, alignment: Alignment.centerLeft,),
                            const SizedBox(width: 5,),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text("Top Picked Stores For You", textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(color: Colors.black54, letterSpacing: .5, fontSize: 14),
                                ),
                              ),
                            )
                          ],),
                      ),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: snapShot.data!.docs.map<Widget>((DocumentSnapshot document) {
                            //if Store is in the Range of 20km
                            if(double.parse(getDistance(document['location'])!)<=10){
                              return GestureDetector(
                                onTap: (){
                                  debugPrint(document['uid']);
                                  storeProvider.getSelectedStore(document, getDistance(document['location']));
                                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                    context,
                                    settings: const RouteSettings(name: VendorScreen.id),
                                    screen: const VendorScreen(),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 80,

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black45,
                                                  width: 2),
                                                borderRadius: const BorderRadius.all(Radius.circular(4))
                                            ),
                                            child: Card(
                                              child:
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: Image.network(document['imageUrl'],
                                                  fit: BoxFit.cover,),
                                              ),
                                            )),
                                        Center(
                                          child: SizedBox(
                                            height: 35,
                                            child: Text(document['shopName'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12, fontWeight: FontWeight.bold,),
                                              maxLines: 2, overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        Center(
                                          child: Text('${getDistance(document['location'])}km',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            else{
                              //if No store Near by 20km
                              return Container();
                            }
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }),
    );
  }
}
