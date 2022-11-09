// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zarea/auth_providers/location_provider.dart';
// import 'package:zarea/screens/home_page.dart';
// import 'package:zarea/services/user_services.dart';
// import '../helpers/navigation_root.dart';
// import '../models/user_models.dart';
//
// enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }
//
// class AuthProvider with ChangeNotifier {
//   UserServices userServices = UserServices();
//   static const LOGGED_IN = "loggedIn";
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   User? _user;
//   Status _status = Status.Uninitialized;
//
//   final UserServices _userServicse = UserServices();
//   UserModel? _userModel;
//   TextEditingController? phoneNo;
//   late String smsOTP;
//   late String verificationId;
//   String errorMessage = '';
//   late bool loggedIn;
//   bool loading = false;
//   LocationProvider locationData = LocationProvider();
//
// //  getter
//   UserModel? get userModel => _userModel;
//
//   Status get status => _status;
//
//   User? get user => _user;
//
//   AuthProvider.initialize() {
//     readPrefs();
//   }
//   Future<void> readPrefs() async {
//     await Future.delayed(const Duration(seconds: 3)).then((v) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       loggedIn = prefs.getBool(LOGGED_IN) ?? false;
//
//       if (loggedIn) {
//         // _user = await auth.currentUser();
//         _userModel = await _userServicse.getUserById(_user!.uid) as dynamic;
//         _status = Status.Authenticated;
//         notifyListeners();
//         return;
//       }
//
//       _status = Status.Unauthenticated;
//       notifyListeners();
//     });
//   }
//
//   Future<void> verifyPhoneNumber({
//     required BuildContext context,
//     required String? number,
//     required double? latitude,
//     required double? longitude,
//     required String? address
//   }) async {
//     loading = true;
//     notifyListeners();
//
//     final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
//       verificationId = verId;
//       smsOTPDialog(context, latitude,longitude, address ).then((value) {
//         if (kDebugMode) {
//           print('sign in');
//         }
//       });
//     };
//     try {
//       await auth.verifyPhoneNumber(
//           phoneNumber: number!.trim(),
//           // PHONE NUMBER TO SEND OTP
//           codeAutoRetrievalTimeout: (String verId) {
//             verificationId = verId;
//           },
//           codeSent:
//           smsOTPSent,
//           // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
//           timeout: const Duration(seconds: 60),
//           verificationCompleted: (AuthCredential phoneAuthCredential) {
//             loading = false;
//             notifyListeners();
//             if (kDebugMode) {
//               print("${phoneAuthCredential}lets make this work");
//             }
//           },
//           verificationFailed: (FirebaseAuthException exceptio) {
//             errorMessage = e.toString();
//             loading = false;
//             notifyListeners();
//             if (kDebugMode) {
//               print('${exceptio.message} + something is wrong');
//             }
//           });
//     } catch (e) {
//       handleError(e, context);
//       errorMessage = e.toString();
//       notifyListeners();
//     }
//   }
//
//   handleError(error, BuildContext context) {
//     print(error);
//     errorMessage = error.toString();
//     notifyListeners();
//     switch (error.code) {
//       case 'ERROR_INVALID_VERIFICATION_CODE':
//         print("The verification code is invalid");
//         break;
//       default:
//         errorMessage = error.message;
//         break;
//     }
//     notifyListeners();
//   }
//   void _createUser({String? id, String? number, double? latitude, double? longitude, required address}){
//     _userServicse.createUserData({
//       "id": id,
//       "number": number,
//       'latitude': latitude,
//       'longitude': longitude,
//     });
//   }
//
//   signIn(BuildContext context) async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsOTP,
//       );
//       final User? user = (await auth.signInWithCredential(credential)).user;
//       final User currentUser = auth.currentUser!;
//       assert(user?.uid == currentUser.uid);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setBool(LOGGED_IN, true);
//       loggedIn = true;
//
//         if(locationData.selectedAddress != null){
//         updateUser(id: user?.uid, number: user?.phoneNumber, latitude: locationData.latitude, longitude: locationData.longitude,
//             address: locationData.selectedAddress.addressLine);
//       }else{
//         createUser(
//           number: user?.phoneNumber,
//           latitude: null,
//           longitude: null,
//           address: null,
//           id: user?.uid
//         );
//       }
//       if (user != null) {
//         _userModel = await _userServicse.getUserById(user.uid) as dynamic;
//         // if (_userModel == null) {
//         //   _createUser(id: user.uid, number: user.phoneNumber);
//         // }
//         loading = false;
//         Navigator.of(context).pop();
//         changeScreenReplacement(context, HomeScreen());
//       }
//       loading = false;
//
//       Navigator.of(context).pop();
//       changeScreenReplacement(context, HomeScreen());
//       notifyListeners();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//   }
//
//   Future<bool?> smsOTPDialog(BuildContext context, double? latitude, double? longitude, String? address) {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Enter SMS Code'),
//             content: Container(
//               height: 80,
//               decoration: const BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     Color(0xFFb440fe),
//                     Color(0xFF7488ea),
//                   ])),
//               child: Column(
//                   children: [
//                 TextField(
//                   onChanged: (value) {
//                     smsOTP = value;
//                   },
//                 ),
//               ]),
//             ),
//             contentPadding: const EdgeInsets.all(10),
//             actions: <Widget>[
//               Align(
//                 alignment: Alignment.center,
//                 child: TextButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.purpleAccent,
//                     primary: Colors.white,
//                   ),
//                   onPressed: () async {
//                     try {
//                       PhoneAuthCredential phone = PhoneAuthProvider.credential(
//                           verificationId: verificationId, smsCode: smsOTP);
//                       final User? user = (await auth.signInWithCredential(
//                           phone)).user;
//
//                       if (user != null) {
//                         Navigator.of(context).pop();
//                         Navigator.pushReplacementNamed(context, HomeScreen.id);
//                       } else {
//                         const SnackBar(
//                           content: Text("Login Failed"),
//                           behavior: SnackBarBehavior.floating,
//                         );
//                       }
//                     } catch (e) {
//                       if (kDebugMode) {
//                         print(e.toString());
//                         SnackBar(
//                           content: Text(e.toString()),
//                           behavior: SnackBarBehavior.floating,
//                         );
//                       }
//                     }
//                   },
//                   child: const Text('VERIFY'),
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   Future signOut() async {
//     auth.signOut();
//     _status = Status.Unauthenticated;
//     notifyListeners();
//     return Future.delayed(Duration.zero);
//   }
//
//   void createUser(
//       {required String? id,
//       required String? number,
//       required double? latitude,
//      required double? longitude,
//         required String? address
//   }) {
//     _userServicse.createUserData({
//       "id": id,
//       "number": number,
//       "latitude": latitude,
//       "longitude": longitude,
//       'address': address
//     });
//   }
//
//   void updateUser({required String? id, required String? number,  required double? latitude,  required double? longitude, required String? address}) {
//     _userServicse.updateUserData({
//       "id": id,
//       "number": number,
//       "latitude": latitude,
//       "longitude": longitude,
//       'address': address
//     });
//   }
// }
//
//
