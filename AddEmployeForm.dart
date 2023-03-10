
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
import 'package:flutter/material.dart';
import 'package:gestion_rh_application/Components/my_button.dart';

import '../Components/my_textFieldKeyWordRequired.dart';

class AddEmployeForm extends StatefulWidget {
  const AddEmployeForm({Key? key}) : super(key: key);

  @override
  State<AddEmployeForm> createState() => _AddEmployeFormState();
}

class _AddEmployeFormState extends State<AddEmployeForm> {

  final pprController = TextEditingController();
  final nomCompleController = TextEditingController();
  final lieuFonctionController = TextEditingController();
  final gardeController = TextEditingController();
  final nbrJourCongeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text("Ajouter un employ??"),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
      ),
      
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            child: Column(
              children: [
                MyTextFieldKeyWordRequired(
                  controller: pprController,
                  hintText: 'PPR',
                  obscureText: false,
                  keyWord: TextInputType.number,
                  fillColor: Colors.red.shade200,
                ),

                const SizedBox(height: 20),
                MyTextFieldKeyWordRequired(
                  controller: nomCompleController,
                  hintText: 'Nom compl??',
                  obscureText: false,
                  fillColor: Colors.red.shade200,
                ),

                const SizedBox(height: 20),
                MyTextFieldKeyWordRequired(
                  controller: lieuFonctionController,
                  hintText: 'En Fonction',
                  obscureText: false,
                  fillColor: Colors.red.shade200,
                ),

                const SizedBox(height: 20),
                MyTextFieldKeyWordRequired(
                  controller: gardeController,
                  hintText: 'Grade',
                  obscureText: false,
                  fillColor: Colors.red.shade200,
                ),

                const SizedBox(height: 20),
                MyTextFieldKeyWordRequired(
                  controller: nbrJourCongeController,
                  hintText: 'Nombre de jours de cong??',
                  obscureText: false,
                  keyWord: TextInputType.datetime,
                  fillColor: Colors.red.shade200,
                ),
                const SizedBox(height: 40),
                ElevatedButton(onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Attendre"
                      ),
                      backgroundColor: Colors.yellow,
                    ),
                  );
                  try{
                    if (pprController.text.isNotEmpty &&
                        nomCompleController.text.isNotEmpty &&
                        lieuFonctionController.text.isNotEmpty &&
                        gardeController.text.isNotEmpty &&
                        nbrJourCongeController.text.isNotEmpty) {

                      // V??rifier si le PPR existe d??j?? dans la base de donn??es
                      final existingDocs = await FirebaseFirestore.instance
                          .collection('employe')
                          .where('PPR', isEqualTo: pprController.text)
                          .get();

                      if (existingDocs.docs.isNotEmpty) {
                        // Afficher un message d'erreur si le PPR existe d??j??
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text('PPR d??j?? existant'),
                                  content: const Text('Un employ?? avec ce PPR existe d??j?? dans la base de donn??es'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK')
                                    )
                                  ]
                              );
                            }
                        );
                      }else{
                        FirebaseFirestore.instance.collection('employe').add({
                          'PPR': pprController.text,
                          'NomCompl??': nomCompleController.text,
                          'Grade': gardeController.text,
                          'lieuFonction': lieuFonctionController.text,
                          'nbrJourConge': int.parse(nbrJourCongeController.text),
                        });
                        // afficher une boite de dialogue pour informer l'utilisateur que l'employ?? a ??t?? ajout?? avec succ??s
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Employ?? ajout?? avec succ??s'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'))
                                ],
                              );
                            });

                        // r??initialiser les valeurs des textfields
                        pprController.clear();
                        nomCompleController.clear();
                        lieuFonctionController.clear();
                        gardeController.clear();
                        nbrJourCongeController.clear();
                      }
                    }
                  }catch(e){
                    // Afficher un message d'erreur
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors de l''ajout des '
                            ' informations'
                            '${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }


                },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black54,
                    onPrimary: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Ajouter un nouveau employ??"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
