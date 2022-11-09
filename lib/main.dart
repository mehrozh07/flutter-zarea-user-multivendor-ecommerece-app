import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/auth_provider.dart';
import 'package:zarea_user/auth_providers/location_provider.dart';
import 'package:zarea_user/auth_providers/store_provider.dart';
import 'package:zarea_user/bottomBar/main_screen.dart';
import 'package:zarea_user/screens/home_page.dart';
import 'package:zarea_user/screens/landing_page,dart.dart';
import 'package:zarea_user/screens/login_screen.dart';
import 'package:zarea_user/screens/map_screen.dart';
import 'package:zarea_user/screens/product_detail.dart';
import 'package:zarea_user/screens/product_list_screen.dart';
import 'package:zarea_user/screens/splash_screen.dart';
import 'package:zarea_user/screens/vendor_screen.dart';
import 'package:zarea_user/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent),);
  runApp(
    MultiProvider(
      providers: [
         ChangeNotifierProvider(
           create: (_)=> AuthProviders(),
         ),
        ChangeNotifierProvider(
            create: (_)=> LocationProvider(),
        ),
        ChangeNotifierProvider(create: (_)=> StoreProvider()),
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
  // This widget is the root of your application.
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
            primaryColor: const Color(0xFFFF2400),
            fontFamily: 'Lato',
          ),
          initialRoute: SplashScreen.id,
          routes: {
            SplashScreen.id: (context)=> const SplashScreen(),
            HomeScreen.id :(context)=> const HomeScreen(),
            WelcomeScreen.id : (context)=> const WelcomeScreen(),
            MapScreen.id: (context)=> const MapScreen(),
            LoginScreen.id: (context)=> const LoginScreen(),
            LandingPage.id: (context)=>const LandingPage(),
            MainScreen.id: (context)=> const MainScreen(),
            VendorScreen.id: (context)=> const VendorScreen(),
            ProductListScreen.id: (context)=> const ProductListScreen(),
            ProductDetail.id: (context)=> const ProductDetail(),
          },
          builder: EasyLoading.init(),
        );
      },

    );
  }
}

