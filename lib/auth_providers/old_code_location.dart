// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocationProvider extends ChangeNotifier {
//   double? latitude;
//   double? longitude;
//   bool permissionAllowed = false;
//   var selectedAddress;
//   LocationPermission? permission;
//   bool loading = false;
//   LatLng? _latLng;
//   final Completer<GoogleMapController> _controller = Completer();
//
//
//   Future<void> getCurrentPosition() async {
//     try{
//       permission = await Geolocator.requestPermission();
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print(position.latitude);
//       print(position.longitude);
//       if(position != null) {
//         latitude = position.latitude;
//         longitude = position.longitude;
//         final coordinates = Coordinates(position.latitude, position.longitude);
//         final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//         selectedAddress = addresses.first;
//         permissionAllowed = true;
//         notifyListeners();
//       }
//       else{
//         if (kDebugMode) {
//           print("Permission Not Allowed".toString().toUpperCase());
//         }
//       }
//     }
//     catch(e){
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//   }
//   Future<void> getMoveCamera() async{
//
//     final coordinated = Coordinates(latitude, longitude);
//     final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinated);
//     final selectedAddress = addresses.first;
//     notifyListeners();
//     if (kDebugMode) {
//       print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
//     }
//   }
//   void onCameraMove(CameraPosition cameraPosition) async{
//     latitude =     cameraPosition.target.latitude;
//     longitude = cameraPosition.target.longitude;
//     notifyListeners();
//   }
//
//
//
//
//   Future<void> savePreference() async{
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setDouble('latitude', latitude!);
//     pref.setDouble('longitude', longitude!);
//     pref.setString('address', selectedAddress.addressLine);
//     pref.setString('location', selectedAddress.featureName);
//
//   }
//
//
// }
//
//
//
