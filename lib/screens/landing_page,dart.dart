import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/screens/home_page.dart';
import 'package:zarea_user/screens/map_screen.dart';
import 'package:zarea_user/services/user_services.dart';
import 'package:zarea_user/utils/error_message.dart';

class LandingPage extends StatefulWidget {
  static const id = '/landing-page';
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final LocationProvider _locationProvider = LocationProvider();
  User? user = FirebaseAuth.instance.currentUser;
  String? _location;
  String? _address;
  bool loading = true;

  @override
  void initState() {
    UserServices _userService = UserServices();
    _userService.getUserById(user!.uid).then((value){
      if( value != null){
        if(value.data()!['latitude'] != null){
          getPrefs(value);
        }else{
          _locationProvider.getCurrentPosition(context);
          if(_locationProvider.isPermissionAllowed == true){
            Navigator.popAndPushNamed(context, MapScreen.id);
          }else{
            Utils.flushBarErrorMessage('Permission Not Allowed'.toLowerCase(), context);
          }
        }
      }
    });
    super.initState();
  }
  getPrefs(dbResult) async{
SharedPreferences preference =await SharedPreferences.getInstance();
String? location = preference.getString('location');
  if(location != null){
    preference.setString('address', dbResult.data()['location']);
    preference.setString('location', dbResult.data()['address']);
    if(mounted){
      setState(() {
        _location = dbResult.data()['location'];
        _address = dbResult.data()['address'];
        loading = false;
      });
    }
    Navigator.pushNamed(context, HomeScreen.id);
   }
  Navigator.pushNamed(context, HomeScreen.id);
  }
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Center(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           Padding(padding: const EdgeInsets.all(8),
           child: Text(_location == null? '': _location!),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(_location == null ? 'Delivery Address Not Set' : _address!, style: const TextStyle(
               fontWeight: FontWeight.bold,
             ),),
           ),
           const CircularProgressIndicator(),
           Text(_address == null? 'Please Update Your Delivery Address to find nearest store for you'.toUpperCase(): _address!,
             textAlign: TextAlign.center,
             style: const TextStyle(
                   color: Colors.grey,
           ),
           ),
           SizedBox(
             height: 300,
             child: Image.asset('assets/images/city.png', fit: BoxFit.fill, color: Colors.black26,),
           ),
           Visibility(
             visible: _location != null? true : false,
             child: TextButton(
               style: TextButton.styleFrom(
                   backgroundColor: Theme.of(context).primaryColor
               ),
                 onPressed: (){
                 Navigator.pushReplacementNamed(context, HomeScreen.id);
                 },
                 child:  Text('confirm your location',
                   style: GoogleFonts.lato(textStyle: const TextStyle(
                     color: Colors.white,
                   ))),
             ),
           ),
           Expanded(
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 TextButton(
                   style: TextButton.styleFrom(
                     backgroundColor: Theme.of(context).primaryColor
                   ),
                   onPressed: (){
                     locationProvider.getCurrentPosition(context);
                     if(locationProvider.selectedAddress != null){
                       Navigator.pushReplacementNamed(context, MapScreen.id);
                     }else{
                       Utils.flushBarErrorMessage('permission not allowed', context);
                     }
                   },
                   child:  Text(_location != null? 'please update location' :'confirm your location',
                       style: GoogleFonts.lato(textStyle: const TextStyle(
                         color: Colors.white,
                       ))),
                 ),
               ],
             ),
           ),
         ],
       ),
      ),
    );
  }
}
