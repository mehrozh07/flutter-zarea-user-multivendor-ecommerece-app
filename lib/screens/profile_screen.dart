import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/auth_provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/screens/map_screen.dart';
import 'package:zarea_user/screens/welcome_screen.dart';
import 'package:zarea_user/utils/error_message.dart';

import '../widgets/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  static const id = "profile-screen";

  const ProfileScreen({super.key});
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProviders>(context);
    var locationData = Provider.of<LocationProvider>(context);
    var user = FirebaseAuth.instance.currentUser;
    auth.getUserData();
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('My Profile',
              style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
        ),
        body:  Container(
          color: Colors.white,
          child:  ListView(
            children:[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.3,
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).primaryColor,
                            child:  const Text("N",
                              style: TextStyle(
                              fontSize: 50,
                                color: Colors.white,
                            ),),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                    Text(
                                    '${auth.documentSnapshot?['firstName']} ${auth.documentSnapshot?['lastName']}',
                                  style:const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  IconButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>const EditProfile()));
                                      },
                                      icon: const Icon(Icons.edit, color: Colors.white,))
                                ],
                              ),

                               Text('${auth.documentSnapshot?['email']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),),
                              Text('${user?.phoneNumber}',
                                style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                       Container(
                         height: 60,
                         width: double.infinity,
                         color: Colors.white,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             const Icon(Icons.location_on, color: Colors.redAccent,),
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Text('${auth.documentSnapshot?['location']}',
                                 maxLines: 2,
                                 style: const TextStyle(
                                   overflow: TextOverflow.ellipsis,
                                   fontSize: 13,
                                 ),),
                                 Text('${auth.documentSnapshot?['address']}',maxLines: 2,
                                   style: const TextStyle(
                                     overflow: TextOverflow.ellipsis,
                                     fontSize: 12,
                                   ),)
                               ],
                             ),
                             TextButton(
                                 style: TextButton.styleFrom(
                                   backgroundColor: Colors.white,
                                   shape: const RoundedRectangleBorder(
                                     side: BorderSide(color: Colors.redAccent)
                                   ),
                                 ),
                                 onPressed: (){
                                   locationData.getCurrentPosition(context).then((value){
                                     if(value != null){
                                       Navigator.push(context, MaterialPageRoute(builder: (_)=> const MapScreen()));
                                     }else{
                                       Utils.flushBarErrorMessage('permission not allows', context);
                                     }
                                   });
                                 },
                                 child: const Text('Change', style: TextStyle(color: Colors.redAccent),))
                           ],
                         ),
                       ),
                    ],
                  ),
                ),
              ),
              const ListTile(
                title: Text('Orders'),
                leading: Icon(Icons.shopping_bag_outlined),
              ),
              const ListTile(
                title: Text('My Rating And Reviews'),
                leading: Icon(Icons.comment),
              ),
              const ListTile(
                title: Text('Notifications'),
                leading: Icon(Icons.notification_important),
              ),
               ListTile(
                onTap: (){
                  FirebaseAuth.instance.signOut().then((value){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const WelcomeScreen()));
                  });
                },
                title: Text('Logout'),
                leading: Icon(Icons.logout),
              ),
            ],
          ),
        ));
  }
}
