import 'package:country_picker/country_picker.dart';
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
    super.initState();
  }
String phone = '';
  var countryCode;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
              flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    visualDensity: const VisualDensity(vertical: 1.5),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      exclude: <String>['KN', 'MF'],
                      favorite: <String>['PK'],
                      showPhoneCode: true,
                      useSafeArea: true,
                      onSelect: (Country country) {
                        setState(() {
                          countryCode = country.phoneCode;
                        });
                        if (kDebugMode) {
                          print('Select country: ${country.countryCode}');
                        }
                      },
                      countryListTheme: CountryListThemeData(
                        borderRadius: BorderRadius.circular(6),
                        inputDecoration: const InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        // Optional. Styles the text in the search field
                        searchTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                  child: countryCode == null? const Text("country Code") : Text(countryCode) ,
                ),
              ),
              const SizedBox(width: 1),
              Expanded(
                flex: 8,
                child: TextFormField(
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
                  ),
                ),
              ),
            ],
          ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
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
                              String number = "+$countryCode$phone";
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