
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestion_rh_application/pages/DemandePage.dart';
//import 'package:gestion_rh_ application/Components/square.dart';
import 'package:gestion_rh_application/pages/ProfilePage.dart';
//import 'package:gestion_rh_application/pages/dashboardPage.dart';
import 'package:gestion_rh_application/pages/employerPage.dart';
//import 'package:google_nav_bar/google_nav_bar.dart';

import '../Components/square.dart';

class HomePage extends StatefulWidget {
  static const String routeName= '/home';


  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //singOut User
  void signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  final user = FirebaseAuth.instance.currentUser;

  final List dataList = [
    "Les decisions",
    "Employés",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //appBar

      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text("Acueil"),
        centerTitle: true,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, ProfilePage.routeName);
              },
              icon:const Icon(Icons.person),
              color: Colors.greenAccent.shade700
          ),
          IconButton(
              onPressed: (){
                showDialog(context: context, builder:(BuildContext context){
                  return AlertDialog(
                    title: Text('${user?.email!}'),
                    content: const Text('êtes-vous sûr de vouloir vous déconnecter ?'),
                      actions: [
                        TextButton(onPressed: (){
                          signOutUser();
                          Navigator.of(context).pop();
                        },
                            child: const Text('OK')),
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        },
                            child: const Text('Annulé')),
                      ]
                  );
                },
                );
              },
              icon: const Icon(Icons.logout),
              color: Colors.greenAccent.shade700
          ),
        ],
      ),

      //Body

      body:
      Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                // Code à exécuter lorsqu'un élément est tapé
                switch (index){
                  case 0 : {
                    if (kDebugMode) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                        const DemandePage()),
                      );
                    }
                  }
                  break;
                  case 1 : {
                    if (kDebugMode) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                        const EmployerPage()
                        ),
                      );
                    }
                  }
                }
              },
              child: MySquare(child: dataList[index]),
            );
          },
        ),
      ),

      //bodyEnd



      //bottom

      /*bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.greenAccent,
            tabBackgroundColor: Colors.blueAccent,
            gap: 7,
            padding: const EdgeInsets.all(16),
            tabs:[
              const GButton(
                icon: Icons.home,
                text:'Home',
                //onPressed: () {
                 // Navigator.pushNamed(context, HomePage.routeName);
                //},
              ),
              GButton(
                icon: Icons.apps,
                text: 'Tableau de bord',
                onPressed: () {
                  Navigator.pushNamed(context, DashboardPage.routeName);
                },
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                onPressed: () {
                  Navigator.pushNamed(context, ProfilePage.routeName);
                  //print( ProfilePage.routeName);
                },
              ),
            ],
          ),
        ),
      ),*/
    );
  }
}

