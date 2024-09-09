import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rice_application/Screens/Authentication/Email/forgot_emailPassword.dart';
import 'package:rice_application/Screens/Authentication/Email/login-email.dart';
import 'package:rice_application/Screens/Authentication/Email/signup-email.dart';
import 'package:rice_application/Screens/Authentication/phone_authentication.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/sellerHomescreen.dart';
import 'package:rice_application/Screens/Home-Screen/home_screen.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/GetStarted/welcome.dart';
import 'package:rice_application/Screens/Splash/splash.dart';
import 'package:rice_application/firebase_options.dart';

Future<void> main() async {
  //Firebase setup..............
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), // Wrap your app
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  //Check current user.......
  User? user = FirebaseAuth.instance.currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //Routes Initializing..............
      routes: {
        Welcome_Screen.id: (context) => const Welcome_Screen(),
        Phone_Authentication.id: (context) => const Phone_Authentication(),
        EmailLogin.id: (context) => const EmailLogin(),
        SignupEmail.id: (context) => const SignupEmail(),
        ForegetEmailpassword.id: (context) => const ForegetEmailpassword(),
        Home_Screen.id: (context) => const Home_Screen(),
        Sellerhomescreen.id: (context) => const Sellerhomescreen(),
      },

      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      home: user == null ? const Splash_Screen() : const Home_Screen(),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
