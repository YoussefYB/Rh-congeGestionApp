
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

import 'package:flutter/material.dart';
import 'package:gestion_rh_application/pages/Login.dart';
import 'package:gestion_rh_application/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:gestion_rh_application/pages/HomePage.dart';
import 'package:gestion_rh_application/pages/ProfilePage.dart';
import 'package:gestion_rh_application/pages/dashboardPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "sresRH",
      //initialRoute: HomePage.routeName,
      routes: {
        Login.routeName: (context) => const Login(),
        HomePage.routeName: (context) => const HomePage(),
        DashboardPage.routeName: (context) => const DashboardPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
        },
      home: const AuthPage()
    );
  }
}
