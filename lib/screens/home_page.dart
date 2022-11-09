import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/screens/all_stores.dart';
import 'package:zarea_user/screens/top_pick_store.dart';
import 'package:zarea_user/widgets/image_slider.dart';
import 'package:zarea_user/widgets/my_appbar.dart';

import '../auth_providers/auth_provider.dart';
import '../auth_providers/location_provider.dart';

class HomeScreen extends StatefulWidget {

  static const String id = 'Home-Screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProviders>(context);
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: NestedScrollView(

          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              const MyAppBar(),
            ];
          },
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: SliderWidget(),
              ),
              Container(
                color: Colors.white70,
                child: const TopPickedStore(),
              ),
              const NearestStore(),
            ],

          )),
      // appBar:  const PreferredSize(
      //     preferredSize: Size.fromHeight(112),
      //     child: MyAppBar(),
      // ),
    );
  }
}
