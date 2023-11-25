import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey =GlobalKey<FormState>();
  final emailController =TextEditingController();
  final passwordController =TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Customize padding
          child: Form(
            key: formKey,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Enter Your Email"
                  ),
                  validator: (value){
                    if(value!.isEmpty ||!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value!))
                    {
                      return  "Please Enter Correct Email";
                    }
                    else{
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Enter Your Password"
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field cannot be empty";
                    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]).{6,}$').hasMatch(value!)) {
                      return "Please Enter a Strong Password";
                    } else {
                      return null; // Validation passed
                    }
                  },
                ),

                SizedBox(height:10,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Form validation passed, perform registration
                              await Firebase.initializeApp(); // Add this line
                              try {
                                UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString(),
                                );

                                print("User created: ${userCredential.user?.uid}");
                                // Print a successful registration message
                                print("Registration successful!");

                                // Show a toast message
                                Fluttertoast.showToast( msg:"Regestration successful ",backgroundColor: Colors.blueGrey,timeInSecForIosWeb: 5);

                                Navigator.pushNamed(context,'dashboard' );

                              } catch (e) {
                                print("Error during sign up: $e");

                                // Handle the error, show a message, etc.
                              }
                            }



                          },
                          child: const Text("Click button for sign up"),
                        ),
                      ),


                      SizedBox(width: 20,),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            style: ButtonStyle(
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "login");
                              ElevatedButton.styleFrom(
                                primary: Colors.blue, // Button color
                                onPrimary: Colors.white, // Text color
                                padding: const EdgeInsets.all(16.0), // Padding around the button content
                              );
                            }, child: const Text("Login")),
                      ),
                    ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
