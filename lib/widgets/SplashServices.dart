import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'dashboard.dart';
import 'login.dart';

class SplashServices{

  void isLogin(BuildContext context)
  {

    final auth=FirebaseAuth.instance;

    final user=auth.currentUser;


    if(user!=null){
      Timer(Duration(seconds: 3),(){

        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => DashBoard()
        )
        );

      }
      );

    }

    else{
      Timer(Duration(seconds: 3),(){

        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => Login()
        )
        );

      }
      );

    }


  }
}