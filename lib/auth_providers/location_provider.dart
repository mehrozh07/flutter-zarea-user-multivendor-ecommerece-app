import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zarea_user/utils/error_message.dart';

class LocationProvider extends ChangeNotifier {
 double? _latitude;
 double? get latitude => _latitude;

 double? _longitude;
 double? get longitude => _longitude;

 bool _isPermissionAllowed = false;
 bool get isPermissionAllowed => _isPermissionAllowed;

 bool loading = false;

 var selectedAddress;

 LocationPermission? _permission;
 LocationPermission? get permission => _permission;

final Utils utils = Utils();
 Future<Position?> getCurrentPosition(BuildContext  context) async{
   try{
     _permission = await Geolocator.requestPermission();
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     if(position != null){
       _latitude = position.latitude;
       _longitude = position.longitude;
       final coordinates = Coordinates(position.latitude, position.longitude);
        final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        selectedAddress = addresses.first;
        _isPermissionAllowed = true;
        notifyListeners();
     }else{
       if (kDebugMode) {
         print('permission Not Allowed');
       }
       Utils.flushBarErrorMessage('Permission Not Allowed', context);
     }
     return position;
   }catch(e){
     Utils.flushBarErrorMessage(e.toString(), context);
   }

 }
void onCameraMove(CameraPosition cameraPosition) {
   _latitude = cameraPosition.target.latitude;
   _longitude = cameraPosition.target.longitude;
   notifyListeners();
}
Future<void> getCameraMove(BuildContext context) async {
// From coordinates
  final coordinates =  Coordinates(_latitude, _longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  selectedAddress = addresses.first;
  notifyListeners();
  if (kDebugMode) {
    print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
  }
  Utils.flushBarErrorMessage('address successfully updated', context);
  notifyListeners();
}
Future<void> savePrefs() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setDouble('latitude', _latitude?? 0);
   prefs.setDouble('longitude', _longitude?? 0);
   prefs.setString('address', selectedAddress.addressLine);
   prefs.setString('location', selectedAddress.featureName);
 }
}