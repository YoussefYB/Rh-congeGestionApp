
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
import 'package:gestion_rh_application/Components/my_textFieldKeyWordValidator.dart';

import '../Components/my_textFieldBoard.dart';
class EdiEmployeForm extends StatefulWidget {

  final String ppr;

  const EdiEmployeForm({Key? key, required this.ppr}) : super(key: key);

  @override
  State<EdiEmployeForm> createState() => _EdiEmployeFormState();
}

class _EdiEmployeFormState extends State<EdiEmployeForm> {

  final nomCompleController = TextEditingController();
  final lieuFonctionController = TextEditingController();
  final gardeController = TextEditingController();
  final nbrJourCongeController = TextEditingController();

  // Récupération de la référence à la collection "employes" dans Firebase
  final CollectionReference employes =
  FirebaseFirestore.instance.collection('employe');

  
  @override
  Widget build(BuildContext context) {

    String ppr = widget.ppr;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text("Modifier les information d'un employé"),
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
                Text(
                  "PPR : $ppr",
                  style:const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextFieldKeyWord(
                  controller: nomCompleController,
                  hintText: 'Nom complé',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextFieldKeyWord(
                  controller: lieuFonctionController,
                  hintText: 'En Fonction',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextFieldKeyWord(
                  controller: gardeController,
                  hintText: 'Grade',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextFieldKeyWordValidator(
                  controller: nbrJourCongeController,
                  hintText: 'Nombre de jours de congé',
                  obscureText: false,
                  keyWord: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nombre de jours de congé';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                      // Récupérer la référence du document à modifier
                      // Recherche de l'ID de l'employé avec le champ "ppr"
                      QuerySnapshot querySnapshot = await employes
                          .where('PPR', isEqualTo: ppr)
                          .limit(1)
                          .get();

                      // Vérifier si l'employé a été trouvé
                      if (querySnapshot.docs.isNotEmpty) {
                        // Récupérer la référence du document à modifier
                        DocumentReference documentReference =
                        employes.doc(querySnapshot.docs.first.id);

                        // Mettre à jour les champs de l'employé
                        try{
                          if (nomCompleController.text.isNotEmpty) {
                            await documentReference.update({
                              'NomComplé': nomCompleController.text,
                            });
                          }

                          if (lieuFonctionController.text.isNotEmpty) {
                            await documentReference.update({
                              'lieuFonction': lieuFonctionController.text,
                            });
                          }

                          if (gardeController.text.isNotEmpty) {
                            await documentReference.update({
                              'Grade': gardeController.text,
                            });
                          }

                          if (nbrJourCongeController.text.isNotEmpty) {
                            await documentReference.update({
                              'nbrJourConge': int.parse(nbrJourCongeController.text),
                            });
                          }
                          // Afficher un message de succès
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Les informations de l\'employé ont'
                                  ' été mises à jour avec succès.'),
                            ),
                          );
                        }catch(e){
                          // Afficher un message d'erreur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur lors de la mise à jour des'
                                  ' informations de l\'employé: '
                                  '${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }


                        // Afficher un message de confirmation
                        /*ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Les informations'
                              ' de''l\'employé ont été mises à jour.')),
                        );*/
                      } else {
                        // Afficher un message d'erreur si l'employé n'a pas été trouvé
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aucun employé '
                              'trouvé avec ce PPR.')),
                        );
                      }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue[400])
                  ),
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
