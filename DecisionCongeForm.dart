
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
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:gestion_rh_application/Components/my_textField.dart';
import 'package:gestion_rh_application/Components/my_textFieldBoard.dart';
import 'package:intl/intl.dart';

import '../pdf/DecisionPdfPage.dart';

class DemandCongerForm extends StatefulWidget {
  const DemandCongerForm({Key? key}) : super(key: key);

  @override
  State<DemandCongerForm> createState() => _DemandCongerFormState();
}

class _DemandCongerFormState extends State<DemandCongerForm> {

  //text editing controllers
  final pprController = TextEditingController();
  final anneeController = TextEditingController();
  final nbrDeJoursController = TextEditingController();
  final startDateController = TextEditingController();
  final nombreDeJourFerierEtweekend = TextEditingController();



  // Récupération de la référence à la collection "employes" dans Firebase
  final CollectionReference employes =
  FirebaseFirestore.instance.collection('employe');


  //Récuperation des donnés de l'employer par sont PPR
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
        title: const Text('Decision de congé'),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //the Form
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Form(
              child: Column(
                children: [
                  MyTextFieldKeyWord(
                    controller: pprController,
                    hintText: 'PPR',
                    obscureText: false,
                    fillColor: Colors.black12,
                    keyWord: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  MyTextFieldKeyWord(
                    controller: anneeController,
                    hintText: 'Année',
                    obscureText: false,
                    fillColor: Colors.black12,
                    keyWord: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  MyTextFieldKeyWord(
                    controller: nbrDeJoursController,
                    hintText: 'Nombre de jours',
                    obscureText: false,
                    fillColor: Colors.black12,
                    keyWord: TextInputType.datetime,
                  ),
                  const SizedBox(height: 15),
                  MyTextFieldKeyWord(
                    controller: nombreDeJourFerierEtweekend,
                    hintText: 'Nombre de jours Ferier et weekends',
                    obscureText: false,
                    fillColor: Colors.black12,
                    keyWord: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: startDateController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),),
                          fillColor: Colors.black12,
                          filled: true,
                          icon: Icon (Icons.calendar_today_rounded),
                          labelText: "A compter du",
                          hintText: "JJ/MM/AAAA"
                        ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if( pickedDate != null){
                          startDateController.text = DateFormat('dd/MM/yyyy')
                              .format(pickedDate);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 45),
                    ElevatedButton(
                      onPressed: () async {
                        // Afficher un message de conficamation

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Ne toucher rien , il faut just attendre"
                            ),
                            backgroundColor: Colors.yellow,
                          ),
                        );
                        try {
                          if(
                          pprController.text.isNotEmpty&&
                              anneeController.text.isNotEmpty&&
                              nbrDeJoursController.text.isNotEmpty&&
                              nbrDeJoursController.text.isNotEmpty&&
                              nombreDeJourFerierEtweekend.text.isNotEmpty
                          ) {
                            // Code pour la recherche des données de l'employe
                            final ppr = pprController.text;
                            final employeDocSnapshot = await
                            getEmployeByPPR(ppr);
                            if (employeDocSnapshot == null) {
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
                            final employeData = employeDocSnapshot.data()!;
                            // Faites quelque chose avec les données de l'employé
                            //print(employeData!);
                            var pPR = employeData['PPR'];
                            var nom = employeData['NomComplé'];
                            var lieuFonction = employeData['lieuFonction'];
                            var grade = employeData['Grade'];
                            var nbrJConge = employeData['nbrJourConge'];



                            // Fin du Code pour la recherche des données de l'employe

                            if(int.parse(nbrDeJoursController.text) != null && int.parse(nombreDeJourFerierEtweekend.text) != null){
                              if (nbrJConge >= int.parse(nbrDeJoursController.text)) {
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



                                  //L'ajout d'une decision a la base de donné
                                  if (int.parse(anneeController.text) == null) {

                                    Fluttertoast.showToast(
                                      msg: "Entrer une année valide",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 20.0,
                                    );
                                  } else {

                                    int daysToAdd =
                                    int.parse(nbrDeJoursController.text) +
                                        int.parse(nombreDeJourFerierEtweekend.text);
                                    DateFormat format = DateFormat("dd/MM/yyyy");
                                    DateTime startDate =
                                    format.parse(startDateController.text);
                                    Timestamp startTimestamp =
                                    Timestamp.fromDate(startDate);

                                    DateTime finDate =
                                    startDate.add(Duration(days: daysToAdd));// ajouter les jours à la DateTime
                                    Timestamp finTimestamp =
                                    Timestamp.fromDate(finDate);


                                    try {
                                      Timestamp currentTimestamp = Timestamp.now();
                                      FirebaseFirestore.
                                      instance.collection('decisionConge').add({
                                        'PPR': pprController.text,
                                        'Année': int.parse(anneeController.text),
                                        'nbrJour':int.parse(nbrDeJoursController.text),
                                        'dateDebut': startTimestamp,
                                        'dateFin' :finTimestamp,
                                        'dateNow':currentTimestamp,
                                      });

                                      try {
                                        await documentReference.update({
                                          'nbrJourConge': (nbrJConge -
                                              int.parse(nbrDeJoursController.text)),
                                        });
                                        // Afficher un message de conficamation

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Le nombre des joures de l'employe a bien été debiter de ${nbrDeJoursController.text} jpurs"
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        // Afficher un message d'erreur
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Erreur lors de la mise à jour des'
                                                    ' informations de l\'employé: '
                                                    '${e.toString()}'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }


                                    } catch (e) {
                                      // Afficher un message d'erreur
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Erreur lors de l'ajout"
                                              " de la decision de congé:"
                                              " ${e.toString()}"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }

                                    //La Rédaction Du Docoment PDF

                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                        DecisionPdf(
                                          pPR: pPR,
                                          nom: nom,
                                          lieuFonction: lieuFonction,
                                          grade: grade,
                                          annee: anneeController.text,
                                          nbrJour: nbrDeJoursController.text,
                                          dateDebutConge: startDateController.text,

                                        ),
                                        )
                                    );

                                    //La Fin de la Rédaction Du Docoment PDF
                                  }
                                  //Fin de l'ajout d'une decision a la base de donné
                                }

                              }else{
                                // Afficher un message d'erreur
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "La decision ne peut pas etre rediger"
                                          " car le nombre des jour demander"
                                          " est superieur au nombres de jours"
                                          " de congé de l'employer qui est "
                                          ": $nbrJConge ",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }


                          }else{
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Tous les champs sont obligatoires'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'))
                                    ],
                                  );
                                });
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
                      child: const Text(
                        "Rédigé la Desision",
                        style: TextStyle(fontSize: 20),
                      )
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}


