import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/auth_provider.dart';
import 'package:zarea_user/auth_providers/coupen_provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/auth_providers/store_provider.dart';
import 'package:zarea_user/bottomBar/main_screen.dart';
import 'package:zarea_user/screens/cart_screen.dart';
import 'package:zarea_user/screens/home_page.dart';
import 'package:zarea_user/screens/landing_page,dart.dart';
import 'package:zarea_user/screens/login_screen.dart';
import 'package:zarea_user/screens/map_screen.dart';
import 'package:zarea_user/screens/product_detail.dart';
import 'package:zarea_user/screens/product_list_screen.dart';
import 'package:zarea_user/screens/profile_screen.dart';
import 'package:zarea_user/screens/vendor_screen.dart';
import 'package:zarea_user/screens/welcome_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'auth_providers/cart_provider.dart';
import 'auth_providers/order_provider.dart';

Map<int, Color> color = {
  50:  const Color.fromRGBO(41, 152, 214, .1),
  100: const Color.fromRGBO(41, 152, 214, .2),
  200: const Color.fromRGBO(41, 152, 214, .3),
  300: const Color.fromRGBO(41, 152, 214, .4),
  400: const Color.fromRGBO(41, 152, 214, .5),
  500: const Color.fromRGBO(41, 152, 214, .6),
  600: const Color.fromRGBO(41, 152, 214, .7),
  700: const Color.fromRGBO(41, 152, 214, .8),
  800: const Color.fromRGBO(41, 152, 214,.9),
  900: const Color.fromRGBO(41, 152, 214, 1),
};
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthProviders()),
        ChangeNotifierProvider(create: (_)=> LocationProvider()),
        ChangeNotifierProvider(create: (_)=> StoreProvider()),
        ChangeNotifierProvider(create: (_)=> CartProvider()),
        ChangeNotifierProvider(create: (_)=> CouponProvider()),
        ChangeNotifierProvider(create: (_)=> OrderProvider()),
      ],
      child: const MyApp(),
    ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    initialization();
  }
  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size (375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zarea',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: MaterialColor(0xff299AD6, color),
            primaryColor: const Color(0xff299AD6),
            fontFamily: 'Lato',
            // iconTheme: const IconThemeData(color: Colors.white),
          ),
          initialRoute: FirebaseAuth.instance.currentUser != null ? MainScreen.id : WelcomeScreen.id,
          routes: {
            // SplashScreen.id: (context)=> const SplashScreen(),
            HomeScreen.id :(context)=> const HomeScreen(),
            WelcomeScreen.id : (context)=> const WelcomeScreen(),
            MapScreen.id: (context)=> const MapScreen(),
            LoginScreen.id: (context)=> const LoginScreen(),
            LandingPage.id: (context)=>const LandingPage(),
            MainScreen.id: (context)=> const MainScreen(),
            VendorScreen.id: (context)=> const VendorScreen(),
            ProductListScreen.id: (context)=> const ProductListScreen(),
            ProductDetail.id: (context)=> const ProductDetail(),
            CartScreen.id: (context)=> const CartScreen(),
            ProfileScreen.id: (context) => const ProfileScreen(),
          },
          builder: EasyLoading.init(),
        );
      },

    );
  }
}