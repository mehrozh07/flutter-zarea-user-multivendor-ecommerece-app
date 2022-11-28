import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/utils/error_message.dart';
import '../auth_providers/auth_provider.dart';
import '../bottomBar/main_screen.dart';
import 'home_page.dart';
import 'login_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation =  LatLng(37.42796133580664, -122.085749655962);
  GoogleMapController? _googleMapController;
  bool _locating = false;
  bool loggedIn = false;
  User? user;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider?>(context);
    final auth = Provider.of<AuthProviders>(context);
    setState(() {
      currentLocation = LatLng(
        locationData!.latitude!, locationData.longitude!
      );
    }
    );
    void onCreated(GoogleMapController googleController) {
      setState(() {
        _googleMapController = googleController;
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Set Location'),
      ),
      bottomSheet: Container(
          height: 200.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _locating
                  ?  LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )
                  : Container(),
              TextButton.icon(
                  onPressed: () {

                  },
                  icon:  Icon(Icons.location_searching_outlined, color: Theme.of(context).primaryColor,),
                  label: Text("${locationData?.selectedAddress.featureName}",style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(_locating
                    ? "Locating"
                    : '${locationData?.selectedAddress.addressLine}'),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: AbsorbPointer(
                    absorbing: _locating ? true : false,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: _locating
                              ? Colors.grey
                              : Theme.of(context).primaryColor, backgroundColor: _locating
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          locationData?.savePrefs();
                          if (loggedIn == false) {
                            Navigator.pushNamed(
                                context, LoginScreen.id);
                          } else {
                            setState(() {
                              auth.latitude = locationData?.latitude;
                              auth.longitude = locationData?.longitude;
                              auth.address =  locationData?.selectedAddress.addressLine;
                              auth.location = locationData?.selectedAddress.featureName;
                            });
                            auth.updateUser(
                              id: user?.uid,
                              number: user?.phoneNumber,
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> const MainScreen()));
                            Utils.flushBarErrorMessage("Successfully Location Updated".toLowerCase(), context);
                          }
                        },
                        child: Text(
                          "confirm location".toLowerCase(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              )
            ],
          )),
      body: Stack(
        children: [
          GoogleMap(
            compassEnabled: true,
            initialCameraPosition:CameraPosition(
                target: currentLocation,
                zoom: 14 ),
            mapType: MapType.normal,
            onCameraMove: (CameraPosition position){
              setState(() {
                _locating = true;
              });
              locationData!.onCameraMove(position);
            },
            onMapCreated: onCreated,
            onCameraIdle: () {
              setState(() {
                _locating = false;
              });
             locationData!.getCameraMove(context);
            },
          ),
          Center(
            child: Container(
              height: 50.h,
              margin: EdgeInsets.only(bottom: 40.h),
              child: Image.asset(
                'assets/images/marker.png',
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: SpinKitPulse(
              color: Colors.white,
              size: 100.sp,
            ),
          ),
        ],
      ),
    );
  }
}
