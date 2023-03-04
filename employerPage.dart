
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

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestion_rh_application/form_pages/AddEmployeForm.dart';
import 'package:gestion_rh_application/form_pages/MiseAjourDesJoursConge.dart';
import 'package:gestion_rh_application/form_pages/historiqueDecisionForm.dart';

import '../form_pages/EditEmployerForm.dart';

class EmployerPage extends StatefulWidget {
  const EmployerPage({Key? key}) : super(key: key);

  @override
  State<EmployerPage> createState() => _EmployerPageState();
}

class _EmployerPageState extends State<EmployerPage> {

  final employerPPRSearcheController = TextEditingController();
  var employeDataText =
      "Entrer le PPR d'un employé s'il existe,si non ajouter un nouveu employé";
  String pprData = "";

  bool isLoading = false;// Add this variable to track loading state
  bool enableEditButton = false;//Add this variable to disable the edit button



  Future<DocumentSnapshot<Map<String, dynamic>>?> getEmployeByPPR(String ppr)
  async {
    final employeQuerySnapshot =
    await FirebaseFirestore.instance.collection('employe')
        .where('PPR', isEqualTo: ppr).get();
    if (employeQuerySnapshot.docs.isEmpty) {
      return null;
    }
    final employeDocSnapshot = employeQuerySnapshot.docs.first;
    return employeDocSnapshot;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text("Employé"),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
      ),

      body:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 100, 20,0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: employerPPRSearcheController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),),
                        fillColor: Colors.black12,
                        filled: true,
                        hintText: "Entrer le PPR",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ),

                  //search Button

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // Show loading indicator
                        });
                        // Code pour le bouton Chercher
                        final ppr = employerPPRSearcheController.text;
                        final employeDocSnapshot = await getEmployeByPPR(ppr);
                        setState(() {
                          isLoading = false; // Hide loading indicator
                        });
                        if (employeDocSnapshot == null) {

                          enableEditButton = false;
                          employeDataText = "Entrer le PPR d'un employé "
                              "s'il existe, si non ajouter un nouveu employé";

                          // Aucun employé trouvé avec ce numéro de PPR
                          Fluttertoast.showToast(
                            msg: "Aucun employé trouvé avec ce numéro de PPR \n\n"
                                "          Ajouter un Employé !!\n"
                                "Or that's cant be a connection Error,"
                                " Check your Internet",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 20.0,
                          );
                          return;
                        }
                        // Récupérez les données de l'employé à partir du DocumentSnapshot
                        final employeData = employeDocSnapshot.data();
                        // Faites quelque chose avec les données de l'employé
                        print(employeData!);
                        var pPR = employeData['PPR'];
                        var nom = employeData['NomComplé'];
                        var lieuFonction = employeData['lieuFonction'];
                        var grade = employeData['Grade'];
                        var nbrJConge = employeData['nbrJourConge'];

                        employeDataText = "PPR : $pPR\n"
                            "NomComplé : $nom\n"
                            "En Fonction : $lieuFonction\n"
                            "Grade : $grade\n"
                            "Nombre de jours de congés : $nbrJConge";
                        enableEditButton = true;
                        pprData = pPR;
                      },
                      //child: Text('Chercher'),
                      icon: const Icon(Icons.search),
                      label: const Text(
                        "cherche",
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.blue[400]),
                      ),
                    ),
                  ),
                  // Show loading indicator
                ],
              ),

              if (isLoading) const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                      const AddEmployeForm())
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[400])
                ),
                child: const Text("Ajouter un employé"),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                      const MiseAjourDesJoursConge())
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[400])
                ),
                child: const Text("Mise à jour des jours de congés"),
              ),


              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Text(
                      employeDataText,
                      style:const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Visibility(
                        visible: enableEditButton,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)
                              => EdiEmployeForm(ppr : pprData)),
                            );
                          },
                          child: const Text("Modifier"),
                        )
                    ),
                    const SizedBox(height: 20,),
                    Visibility(
                        visible: enableEditButton,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)
                              => HistoriqueDecision(ppr : pprData)),
                            );
                          },
                          child: const Text("Voir historique de decision"),
                        )
                    )
                  ],
                ),

              )
            ],
          ),
        ),
      )

    );
  }
}

