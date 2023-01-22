import 'package:flutter/material.dart';
import 'package:zarea_user/screens/all_stores.dart';
import 'package:zarea_user/screens/top_pick_store.dart';
import 'package:zarea_user/widgets/image_slider.dart';
import 'package:zarea_user/widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {

  static const String id = 'Home-Screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              const MyAppBar(),
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SliderWidget(),
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
