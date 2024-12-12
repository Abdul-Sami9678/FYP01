import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:rice_application/Screens/Authentication/Email/forgot_emailPassword.dart';
import 'package:rice_application/Screens/Authentication/Email/login-email.dart';
import 'package:rice_application/Screens/Authentication/Email/signup-email.dart';
import 'package:rice_application/Screens/Authentication/phone_authentication.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Provider/cart_provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets/buyer_address.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/chat_provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/sellerHomescreen.dart';
import 'package:rice_application/Screens/Home-Screen/home_screen.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/GetStarted/welcome.dart';
import 'package:rice_application/Screens/Splash/splash.dart';
import 'package:rice_application/firebase_options.dart';

Future<void> main() async {
  // Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set Stripe publishable key (Test Mode)
  Stripe.publishableKey =
      'pk_test_51Q72aWGr9UhAIQLONS2w69MXRfQ6WPt8y71eznEVaBAZqMI7HF3l44ZXk3qvbY6TzVVrLYen4XC0dhwlICL1XUym0066Kj7Ay7'; // Replace with your Stripe test key

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Check current user
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(), // Provide CartProvider
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(), // Provide ChatProvider
        ),
      ],
      child: GetMaterialApp(
        // Routes Initializing
        routes: {
          Welcome_Screen.id: (context) => const Welcome_Screen(),
          Phone_Authentication.id: (context) => const Phone_Authentication(),
          EmailLogin.id: (context) => const EmailLogin(),
          SignupEmail.id: (context) => const SignupEmail(),
          ForegetEmailpassword.id: (context) => const ForegetEmailpassword(),
          HomeScreen.id: (context) => const HomeScreen(),
          Sellerhomescreen.id: (context) => const Sellerhomescreen(),
          BuyerAddress.id: (context) => const BuyerAddress(),
        },
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: DevicePreview.appBuilder,
        home: user == null ? const Splash_Screen() : const HomeScreen(),
      ),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
