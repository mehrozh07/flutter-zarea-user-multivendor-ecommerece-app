import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/auth_provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/screens/home_page.dart';

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
              TextFormField(
                maxLength: 10,
                onChanged: (value){
                  phone = value;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 6, right: 0, top: 0, bottom: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.blueGrey.shade100,
                  filled: true,
                  counter: const Offstage(),
                  hintText: "Phone",
                  prefixText: "+92 "
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
                              String number = "+92$phone";
                              auth?.verifyPhone(
                                context: context,
                                number: number,
                              ).then((value) {
                                countryController.clear();
                                auth.loading = false;
                              });
                           },
                    child: const Text("Verify Phone Number",
                      style: TextStyle(color: Colors.white),)),
                   )
            ],
          ),
        ),
      ),
    );
  }
}