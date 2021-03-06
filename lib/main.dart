import 'package:app_instagram/responsive/mobile_layout_screen.dart';
import 'package:app_instagram/responsive/responsive_layout_screen.dart';
import 'package:app_instagram/responsive/web_layout_screen.dart';
import 'package:app_instagram/screens/login_screen.dart';
import 'package:app_instagram/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyDRzKqgi02yA0O89_uazeBBymOhdW7X5r4',
            appId: '1:336827675620:web:8dbd8cbfa67f5d01834df1',
            messagingSenderId: '336827675620',
            projectId: 'app-instagram-b4942',
            storageBucket: 'app-instagram-b4942.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: primaryColor));
              }

              return const LoginScreen();
            }));
  }
}
