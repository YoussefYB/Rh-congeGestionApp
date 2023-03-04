
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
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:gestion_rh_application/Components/my_textField.dart";
import 'package:gestion_rh_application/pages/Login.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

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


  final emailController = TextEditingController();

  @override
  void dispose() {
    subscription.cancel();
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try{
      await FirebaseAuth.instance.
          sendPasswordResetEmail(email: emailController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text('Password Reset link sent ! Check your email'),
        );
      },);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });

    }on FirebaseAuthException catch (e) {
      //print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      },);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
       const  Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
              'Enter your email and we will send you a password reset link',
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 10,),

        //Email textField
        MyTextField(
          controller: emailController,
          hintText: 'email',
          obscureText: false,
          fillColor: Colors.black12,
        ),
          const SizedBox(height: 10,),

        MaterialButton(
            onPressed: passwordReset,
          color: Colors.blue[200],
          child: const Text('Reset Password'),
        )
      ],
      ),
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
