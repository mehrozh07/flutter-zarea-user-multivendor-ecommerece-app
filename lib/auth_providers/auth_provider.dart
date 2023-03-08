import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/bottomBar/main_screen.dart';
import 'package:zarea_user/services/user_services.dart';
import 'package:zarea_user/utils/error_message.dart';
import '../screens/landing_page,dart.dart';


class AuthProviders extends ChangeNotifier{

  FirebaseAuth auth = FirebaseAuth.instance;
   String? smsOTP;
  String? verifications;
   String? verificationId;
   String? error = '';
   final UserServices _userServices = UserServices();
   bool loading = false;
   LocationProvider locationProvider = LocationProvider();
   String? screen;
   String? address;
   double? latitude;
   double? longitude;
   String? location;
   DocumentSnapshot? documentSnapshot;


  Future<void> verifyPhone({ BuildContext? context,  String? number}) async{
    loading = true;
    notifyListeners();
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async{
      loading = false;
      notifyListeners();
      await auth.signInWithCredential(phoneAuthCredential);
    }
    verificationFailed(FirebaseAuthException e){
      debugPrint(e.code);
      loading = false;
      error = e.toString();
      notifyListeners();
    }

    codeSent(String? verId, int? resendToken) async{
      verificationId = verId!;
      //open dialogue to enter recieved OTP SMS
      smsOtpDialogue(context!, number!);
    }

    try{
      auth.verifyPhoneNumber(
          phoneNumber: number!,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: (String verid){
            verificationId = verid;
          },
          timeout: const Duration(seconds: 5),
      );

    }catch(e){
      debugPrint(e.toString());
     error = e.toString();
      loading=false;
      notifyListeners();
    }
  }

  Future<Future> smsOtpDialogue(BuildContext context, String number, ) async{
    return showDialog(context: context,
        builder: (BuildContext context){
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height*0.3,
          padding: const EdgeInsets.all(20),
          color: Colors.white70,
          child: SizedBox(
            height: 80,
            child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (v){
                      if(v=='' && v!.isEmpty){
                        return "OTP required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Enter valid otp",
                      labelText: "6-digit OTP"
                    ),
                    onChanged: (value) {
                      smsOTP = value;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () async{
                            try{
                              PhoneAuthCredential poneAuthCredential = PhoneAuthProvider.credential(
                                verificationId: verificationId!,
                                smsCode: smsOTP!,
                              );
                              final User? user = (await auth.signInWithCredential(poneAuthCredential)).user;
                              if(user!=null){
                                loading = false;
                                notifyListeners();
                                _userServices.getUserById(user.uid).then((snapShot) {
                                  if(snapShot.exists){
                                    if(screen=='Login'){
                                      Navigator.pushReplacement(context,
                                          CupertinoPageRoute(builder: (_)=> const LandingPage()));
                                    }else{
                                      updateUser(id: user.uid, number: user.phoneNumber);
                                      Navigator.pushReplacement(context,
                                          CupertinoPageRoute(builder: (_)=> const MainScreen()));
                                    }
                                  }else{
                                    _createUser(id: user.uid, number: user.phoneNumber);
                                    Navigator.pushReplacement(context,
                                        CupertinoPageRoute(builder: (_)=> const LandingPage()));
                                  }
                                });
                              }else{
                                // ignore: use_build_context_synchronously
                                Utils.flushBarErrorMessage("Login Failed", context);
                                if (kDebugMode) {
                                  print('Login Failed');
                                }
                              }
                            }catch(e){
                              if (kDebugMode) {
                                print(e.toString());
                              }
                              error = "invalid otp";
                              Navigator.of(context).pop();
                              Utils.flushBarErrorMessage(e.toString(), context);
                            }
                          },
                          child: const Text('Verify'),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      );
        }).whenComplete(() {
          loading = false;
          notifyListeners();
    });
  }
  Future<void> _createUser({String? id, String? number}) async{
    _userServices.createUserData({
      "id": id,
      "number": number,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      'location': location,
      'firstName': 'name',
      'lastName': '',
      'email': 'email'
    });
    loading = false;
    notifyListeners();
}
 void updateUser({String? id, String? number, context}) async{
    try{
      _userServices.updateUserData({
        "id": id,
        "number": number,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        'location': location,
      });
      loading = false;
      notifyListeners();
    }
    catch(e){
      if (kDebugMode) {
        print('${e.toString()} cant be update');
      }
      Utils.flushBarErrorMessage('address can,t be update', context!);
    }
  }
Future<DocumentSnapshot> getUserData() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid).get();
     documentSnapshot =snapshot;
     notifyListeners();
     return snapshot;
}
}