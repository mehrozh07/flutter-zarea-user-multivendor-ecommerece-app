import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zarea_user/screens/welcome_screen.dart';
import 'package:zarea_user/services/user_services.dart';

import '../services/store_services.dart';

class StoreProvider extends ChangeNotifier{
  final UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;

  var userLatitude = 0.0;
  var userLongitude = 0.0;
  String? storeName;
  String? storeId;
  String? distance ;
  String? selectCategory;

DocumentSnapshot? documentSnapshot;

  getSelectedStore(documentSnapshot, distance){
    this.documentSnapshot = documentSnapshot;
    this.distance = distance;
    notifyListeners();
  }

  selectedByCategory(category){
    selectCategory = category;
    notifyListeners();
  }

  Future<void> getUserLocation(context) async {
    _userServices.getUserById(user!.uid).then((value){
      if(user != null){
        userLatitude = value['latitude'];
        userLongitude = value['longitude'];
        notifyListeners();
      }else{
        Navigator.pushNamed(context, WelcomeScreen.id);
      }
    });
  }


  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}