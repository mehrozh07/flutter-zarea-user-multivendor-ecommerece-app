import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/services/user_services.dart';
import 'package:zarea_user/utils/error_message.dart';
import '../screens/home_page.dart';
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
   BuildContext? context;
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
      Utils.flushBarErrorMessage(e.code, context!);
      notifyListeners();
    }

    codeSent(String? verId, int? resendToken) async{
      verificationId = verId!;
      //open dialogue to enter recieved OTP SMS
      smsOtpDialogue(context! , number!, );
    }

    try{
      auth.verifyPhoneNumber(
          phoneNumber: number!,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: (String verid){
            verificationId = verid;
          }
      );

    }catch(e){
      debugPrint(e.toString());
      Utils.flushBarErrorMessage(e.toString(), context!);
      loading=false;
      notifyListeners();
    }
  }

  Future<Future> smsOtpDialogue(BuildContext context, String number, ) async{
    return showDialog(context: context,
        builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Enter SMS Code'),
        content: SizedBox(
          height: 80,
          child: Column(
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter valid otp",
                  ),
                  onChanged: (value) {
                    smsOTP = value;
                  },
                ),
              ]),
        ),
        contentPadding: const EdgeInsets.all(10),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
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
                      Navigator.pushReplacementNamed(context, LandingPage.id);
                       }else{
                         if (kDebugMode) {
                           print("${locationProvider.selectedAddress.featureName} : ${locationProvider.selectedAddress.addressLine}");
                         }
                         updateUser(id: user.uid, number: user.phoneNumber);
                         Navigator.pushReplacementNamed(context, HomeScreen.id);
                       }
                     }else{
                       _createUser(id: user.uid, number: user.phoneNumber);
                       Navigator.pushReplacementNamed(context, LandingPage.id);
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
                 // Utils.flushBarErrorMessage("Invalid OTP", context);
                 // error = "Invalid OTP".toUpperCase();
                 Navigator.of(context).pop();
               }
              },
              child: const Text('VERIFY'),
            ),
          )
        ],
      );
        }).whenComplete(() {
          loading = false;
          notifyListeners();
    });
  }
  void _createUser({String? id, String? number}) async{
    _userServices.createUserData({
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
 void updateUser({String? id, String? number,}) async{
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

}