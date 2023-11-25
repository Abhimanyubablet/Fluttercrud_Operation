import 'dart:async';

import 'package:flutter/material.dart';


import 'SplashServices.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashServices splashScreen=SplashServices(); //
  @override

  void initState() {
    super.initState();

    splashScreen.isLogin(context);

  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        color: Colors.blue,
        child: Center(
          child: Text("Firebase",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 34,color: Colors.white)),
        ),
      ),
    );
  }
}
