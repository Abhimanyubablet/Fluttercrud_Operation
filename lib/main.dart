import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:profile_update_firebase/widgets/dashboard.dart';
import 'package:profile_update_firebase/widgets/login.dart';
import 'package:profile_update_firebase/widgets/login_with_phone.dart';
import 'package:profile_update_firebase/widgets/signup.dart';
import 'package:profile_update_firebase/widgets/splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: 'your-firebase-storage-bucket-url',
          apiKey: 'AIzaSyCnb0DVXegJUkjtWoSx8XiXyZcIh3nyWg4',
          appId: '1:600243686836:android:0ef452a10a1c6b3cee76e1',
          messagingSenderId: '600243686836',
          projectId: 'updateprofileproject'
      )
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "splash",
    routes: {
      'splash': (context) => Splash(),
      'login': (context) => Login(),
      'signup': (context) => Signup(),
      'dashboard': (context) =>DashBoard(),
      "login_with_phone": (context) => LoginWithPhone(),
    },
  ));
}

