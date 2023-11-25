import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:profile_update_firebase/widgets/verify_code_screen.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
   bool loading=false;
  final phonenumberController=TextEditingController();
 final auth= FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
         title: Text("Login"),
      ),

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),

            TextField(
              controller: phonenumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text("+1 234 4532 123"),
              ),
            ),
            SizedBox(height: 70,),

            Container(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: () {
                 auth.verifyPhoneNumber(
                   phoneNumber: phonenumberController.text,
                     verificationCompleted: (_){

                     },
                     verificationFailed: (e){
                     toastMessage(e.toString());
                     },
                     codeSent: (String verificationId, int? token) {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => VerifyCode(verificationId: verificationId),
                         ),
                       );
                     },

                     codeAutoRetrievalTimeout: (e){
                       toastMessage(e.toString());
                     });
                },
                child: Text("Login"),
              ),
            )


          ],
        ),
      ),

    );
  }

   void toastMessage(String message) {
     Fluttertoast.showToast(
       msg: message,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.red,
       textColor: Colors.white,
       fontSize: 16.0,
     );
   }
}
