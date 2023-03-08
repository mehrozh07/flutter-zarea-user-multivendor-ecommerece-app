import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/screens/map_screen.dart';
import 'package:zarea_user/screens/on_boarding.dart';
import 'package:zarea_user/utils/error_message.dart';

import '../auth_providers/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String errorMessage = '';
  bool loading = false;
  String? error = '';

  @override
  Widget build(BuildContext context) {
    // final defaultPinTheme = PinTheme(
    //   width: 56,
    //   height: 56,
    //   textStyle: const TextStyle(
    //       fontSize: 20,
    //       color: Color.fromRGBO(30, 60, 87, 1),
    //       fontWeight: FontWeight.w600),
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    // );
    //
    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    //   borderRadius: BorderRadius.circular(8),
    // );
    //
    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: Color.fromRGBO(234, 239, 243, 1),
    //   ),
    // );
    final auth = Provider.of<AuthProviders>(context);
    bool validPhoneNumber = false;
    var phoneNumberC = TextEditingController();
    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter myState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
              ),
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).primaryColor.withOpacity(0.2),
            ])),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black54,
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 90.w),
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 20.sp),
                            ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Visibility(
                    visible: auth.error == "INVALID OTP" ? true : false,
                    child: Text("${auth.error}-TRY AGAIN",
                      style: const TextStyle(color: Colors.pinkAccent),),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black54, fontSize: 18),
                    controller: phoneNumberC,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                      border: const OutlineInputBorder(),
                      prefixText: '+92 ',
                      prefixStyle:
                          TextStyle(color: Colors.black54, fontSize: 20.sp),
                      label: Text(
                        'Enter 10 digit number',
                        style:
                            TextStyle(color: Colors.black54, fontSize: 20.sp),
                      ),
                      labelStyle: const TextStyle(color: Colors.black54),
                    ),
                    autofocus: true,
                    maxLength: 10,
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          validPhoneNumber = true;
                        });
                      } else {
                        setState(() {
                          validPhoneNumber = false;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: validPhoneNumber ? false : true,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: validPhoneNumber
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              myState((){
                                auth.loading = true;
                              });
                              String number = "+92${phoneNumberC.text}";
                              auth.verifyPhone(context: context, number: number,).then((value) {
                                phoneNumberC.clear();
                                setState(() {
                                  auth.loading = true;
                                });
                              });
                              debugPrint(phoneNumberC.text);
                            },
                            child: auth.loading?  const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                            )
                                :Text(validPhoneNumber
                                ? "SEND OTP"
                                : "ENTER PHONE NUMBER TO CONTINUE",
                              style: const TextStyle(color: Colors.black54),),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ).whenComplete((){
        setState((){
          loading = false;
          phoneNumberC.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Positioned(
                right: 0.0,
                top: 10.0,
                child: TextButton(
                  onPressed: () {},
                  child:  Text(
                    "SKIP",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )),
            Column(
              children: [
                const Expanded(child: OnBoarding()),
                Text(
                  "Read to Order From your Nearest Shop",
                  style: GoogleFonts.alegreyaSans(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async{
                      setState((){
                        locationData.loading = true;
                      });
                      await locationData.getCurrentPosition(context);
                      if (locationData.isPermissionAllowed == true) {
                        Navigator.push(context, CupertinoPageRoute(builder: (_)=> const MapScreen()));
                        setState((){
                          locationData.loading = false;
                        });
                      }
                      else {
                        setState((){
                          locationData.loading = false;
                        });
                        if (kDebugMode) {
                          print("Permission Not Allowed");
                        }
                        Utils.flushBarErrorMessage("Permission Not Allowed".toLowerCase(), context);
                      }
                    },
                    child:locationData.loading? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ) :Text(
                      'Set Delivery Location'.toUpperCase(),
                    )),
                SizedBox(
                  height: 20.h,
                ),
                Wrap(
                  children: [
                    Text(
                      "already a customer? ",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: MediaQuery.textScaleFactorOf(context)*16,
                        )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState((){
                          auth.screen = "Login";
                        });
                        showBottomSheet(context);
                        debugPrint('pressed');
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: MediaQuery.textScaleFactorOf(context)*16,
                          )
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
