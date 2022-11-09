import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/auth_provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'Login-Screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countryController = TextEditingController();

    bool validPhoneNumber = false;
    bool loading = false;

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }
String phone = '';
  @override
  Widget build(BuildContext context) {
        final auth = Provider.of<AuthProviders?>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: countryController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixText: '+92',
                          prefixStyle: TextStyle(color: Colors.black)
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                          onChanged: (value){
                            phone = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                               onPressed: () async{
                                    if (kDebugMode) {
                                print(locationData.selectedAddress.featureName);
                              }
                              setState((){
                                auth?.loading = true;
                                auth?.screen='MapScreen';
                                auth?.latitude = locationData.latitude;
                                auth?.longitude = locationData.longitude;
                                auth?.address = locationData.selectedAddress.addressLine;

                              });
                              String number = countryController.text+phone;
                              auth?.verifyPhone(
                                context: context,
                                number: number,

                              ).then((value) {
                                countryController.clear();
                                auth.loading = false;
                              });
                           },
                    child: const Text("Send the code", style: TextStyle(color: Colors.black87),)),
                   )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:zarea/auth_providers/location_provider.dart';
// import '../auth_providers/auth_provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   static const String id = 'login-screen';
//    const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final phoneNumberC = TextEditingController();
//   bool validPhoneNumber = false;
//   String? error = '';
//   bool loading = false;
//
//
// @override
//   void initState() {
//   phoneNumberC.text = "+91";
//   super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProviders?>(context);
//     final locationData = Provider.of<LocationProvider>(context);
//     return
//       Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 Color(0xFFb440fe),
//                 Color(0xFF7488ea),
//               ])),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                         )),
//                     Padding(
//                       padding: EdgeInsets.only(left: 90.w),
//                       child: Text(
//                         "Sign Up",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.aguafinaScript(
//                             color: Colors.white, fontSize: 20.sp),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 Visibility(
//                   visible: auth?.error == "INVALID OTP" ? true : false,
//                   child: Text(
//                     "${auth!.error}> TRY AGAIN",
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 20.w, left: 20.w),
//                   child: TextFormField(
//                     controller: phoneNumberC,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       prefixText: 'Pakistan +92',
//                       prefixStyle:
//                       TextStyle(color: Colors.white, fontSize: 20.sp),
//                       label: Text(
//                         'Enter 10 digit number',
//                         style:
//                         TextStyle(color: Colors.white, fontSize: 20.sp),
//                       ),
//                       labelStyle: const TextStyle(color: Colors.white),
//                     ),
//                     autofocus: true,
//                     maxLength: 10,
//                     onChanged: (value) {
//                       if (value.length == 10) {
//                         setState(() {
//                           validPhoneNumber = true;
//                         });
//                       } else {
//                         setState(() {
//                           validPhoneNumber = false;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(right: 20.w, left: 20.w),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: AbsorbPointer(
//                           absorbing: validPhoneNumber ? false : true,
//                           child: TextButton(
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.white, backgroundColor: validPhoneNumber
//                                   ? Colors.purpleAccent.shade200
//                                   : Colors.grey,
//                             ),
//                             onPressed: () {
//                               if (kDebugMode) {
//                                 print(locationData.selectedAddress.featureName);
//                               }
//                               setState((){
//                                 auth.loading = true;
//                                 auth.screen='MapScreen';
//                                 auth.latitude = locationData.latitude;
//                                 auth.longitude = locationData.longitude;
//                                 auth.address = locationData.selectedAddress.addressLine;
//
//                               });
//                               String number = "+92${phoneNumberC.text}";
//                               auth.verifyPhone(
//                                 context: context,
//                                 number: number,
//
//                               ).then((value) {
//                                 phoneNumberC.clear();
//                                 auth.loading = false;
//                               });
//                             },
//                             child: auth.error == null ? const CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             )
//                                 :Text(validPhoneNumber
//                                 ? "SEND OTP"
//                                 : "ENTER PHONE NUMBER TO CONTINUE"),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }