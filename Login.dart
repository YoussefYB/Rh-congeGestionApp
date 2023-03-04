
/*
 * MIT License with Additional Conditions
 *
 * Copyright (c) 2023.   Youssef Belahmar
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 1. Attribution: Any use of this software must include attribution to the original author(s) and copyright holder(s) in all copies or substantial portions of the software.
 * 2. Non-liability: The software is provided "as is" without warranty of any kind, either express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and non infringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.
 * 3. Non-commercial use: The software may not be used for commercial purposes, including without limitation the sale of the software, its derivatives, or its components.
 *
 *
 */

import "dart:async";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:gestion_rh_application/Components/my_button.dart";
import "package:gestion_rh_application/Components/my_textField.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";

import "ForgotPasswordPage.dart";


class Login extends StatefulWidget{
  static const String routeName= '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //check for internet connection
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState(){
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().
      onConnectivityChanged.listen((ConnectivityResult result) async{
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if( !isDeviceConnected && isAlertSet == false){
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      },
      );

  @override
  void dispose(){
    subscription.cancel();
    super.dispose();
  }

  //text editing controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  //sign user in methode
  void signUserIn() async{
    // show loading circle
    showDialog(
      context: context,
      builder: (context){
     return const Center(
        child: CircularProgressIndicator(),
     );
    },);
    //try sing in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    //pop the loading circle
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    }on FirebaseAuthException catch (e){
      //pop loading circle
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      //wrong Email
      if(e.code == 'user-not-found'){
        //show error to user
        wrongEmailMessage();
      }
      //wrong Password
      else if(e.code == 'wrong-password'){
        //show error to user
        wrongPasswordMessage();
      }
    }



  }
  //wrong email message popup
  void wrongEmailMessage(){
    showDialog(context: context, builder: (context){
      return const AlertDialog(
        title: Text('Incorrect Email'),
      );
    },);
  }
  //wrong password message
  void wrongPasswordMessage(){
    showDialog(context: context, builder: (context){
      return const AlertDialog(
        title: Text('Incorrect password'),
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body:SafeArea(
       child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const SizedBox(height: 50,),
            //logo
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(height: 25),
            //Welcome text
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            //RH text
            const Text(
              'Gestion RH',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            //username textField
            const SizedBox(height: 25),
            MyTextField(
              controller: emailController,
              hintText: 'email',
              obscureText: false,
              fillColor: Colors.black26,
            ),
            //password textField
            const SizedBox(height: 15),
            MyTextField(
              controller: passwordController,
              hintText: 'password',
              obscureText: true,
              fillColor: Colors.black26,
            ),
            //forgot password?
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                return const ForgotPasswordPage();
              },),);},
              child: Padding(padding:
              const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Forgot password?',
                          style: TextStyle(color: Colors.black87),
                        )
                      ]
                  )
              ),
            ),
            //sing in button
            const SizedBox(height: 15),
            MyButton(
              onTap: signUserIn,
            )
        ],)
       )
      )
    );
  }


  //showDialogBox() function
  showDialogBox() => showCupertinoDialog(context: context,
    builder: (BuildContext context ) => CupertinoAlertDialog(
    title: const Text("Pas de connection"),
    content: const Text("S'il vous plait, verifier votre connection internet"),
    actions: <Widget>[
      TextButton(
          onPressed: () async {
            Navigator.pop(context, 'cancel');
            setState(() {
              isAlertSet = false;
            });
            isDeviceConnected = await InternetConnectionChecker().hasConnection;
            if( !isDeviceConnected){
              showDialogBox();
              setState(() {
                isAlertSet = true;
              });
            }
          },
          child: const Text('OK'))
    ],
  ),);
}
