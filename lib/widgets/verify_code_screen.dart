import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({required this.verificationId,super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading=false;
  final phonenumberController=TextEditingController();
  final auth= FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Verify"),
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
                hintText: "6 digit code",
              ),
            ),
            SizedBox(height: 70,),

            Container(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: () async {
                  final credential=PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: phonenumberController.text.toString()
                  );

                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.pushNamed(context,"dashboard");
                  }catch (e) {
                      toastMessage(e.toString());
                  }

                },
                child: Text("Verify code"),
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
