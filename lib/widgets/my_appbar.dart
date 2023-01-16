import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zarea_user/utils/error_message.dart';
import '../auth_providers/location_provider.dart';
import '../screens/map_screen.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

  final searchC = TextEditingController();
  String? _location = '';
  String? _address = '';
  @override
  void initState() {
    getPref();
    super.initState();
  }
  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     final String? location =  preferences.getString('location');
    final String? address =  preferences.getString('address');
    if(mounted){
      setState((){
        _location = location;
        _address = address;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      floating: true,
      snap: true,
      title: TextButton(
        onPressed: () async{
         await locationData.getCurrentPosition(context);
         if(mounted){
           if(locationData.isPermissionAllowed == true){
             PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
               context,
               settings: const RouteSettings(name: MapScreen.id),
               screen: const MapScreen(),
               withNavBar: false,
               pageTransitionAnimation: PageTransitionAnimation.cupertino,
             );
           }else{
             Utils.flushBarErrorMessage("you can't fix location \n try again".toLowerCase(), context);
           }
         }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:  [
                Flexible(
                  child: Text(_location == null? "Address Not Set": _location!,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ),
                ),
                 Icon(Icons.edit,color: Colors.white,size: 15.sp,),
              ],
            ),
            Flexible(child: Text(_address == null ? 'set delivery Location'.toUpperCase(): _address!,
              style: TextStyle(
              color: Colors.white, fontSize: 12.sp,
            ), overflow: TextOverflow.ellipsis,),),
          ],
        ),

      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.sp),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              showCursor: true,
              controller: searchC,
              decoration:  InputDecoration(
                hintText: "Search Shop",
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,

              ),
            ),
          )),
    );
  }
}
