
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
import 'package:gestion_rh_application/Components/my_textFieldKeyWordRequired.dart';

import '../Components/my_textFieldBoard.dart';

class MiseAjourDesJoursConge extends StatefulWidget {
  const MiseAjourDesJoursConge({Key? key}) : super(key: key);

  @override
  State<MiseAjourDesJoursConge> createState() => _MiseAjourDesJoursCongeState();
}

class _MiseAjourDesJoursCongeState extends State<MiseAjourDesJoursConge> {

  final nbrJoursController = TextEditingController();
  bool isLoading = false;



  //cette fonction inisialise le nombre des jours
  Future<void> initJoursNbr(int newConge) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('employe').get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;


     // Définir isLoading à true
    setState(() {
      isLoading = true;
    });

    for (DocumentSnapshot document in documents) {
      await document.reference.update({'nbrJourConge': newConge});

      // Attendre quelques secondes pour que l'utilisateur voie le message de confirmation
      await Future.delayed(const Duration(seconds: 0));
    }

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Le nombre de jours de congés pour tous les employés a été réinitialisé en $newConge jours.'),
        backgroundColor: Colors.green,
      ),
    );


    // Définir isLoading à false
    setState(() {
      isLoading = false;
    });
  }



  //cette fonction ajoute a nombre de jours
  Future<void> cumuleJoursNbr(int newConge) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('employe').get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;

    // Définir isLoading à true
    setState(() {
      isLoading = true;
    });

    for (DocumentSnapshot document in documents) {
      int oldJoursNbr = document.get('nbrJourConge');
      int newJoursNbr = oldJoursNbr + newConge;
      await document.reference.update({'nbrJourConge': newJoursNbr});

      // Attendre quelques secondes pour que l'utilisateur voie le message de confirmation
      await Future.delayed(const Duration(seconds: 0));
    }

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Le nombre de jours de congés pour tous les employés a été additionné par $newConge jours.'),
        backgroundColor: Colors.green,
      ),
    );


    // Définir isLoading à false
    setState(() {
      isLoading = false;
    });

  }

  //cette fonction annule le cumule
  Future<void> annulCumuleJoursNbr(int newConge) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('employe').get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;



    // Définir isLoading à true
    setState(() {
      isLoading = true;
    });

    for (DocumentSnapshot document in documents) {
      int oldJoursNbr = document.get('nbrJourConge');
      if(oldJoursNbr > newConge){
        int newJoursNbr = newConge;
        await document.reference.update({'nbrJourConge': newJoursNbr});
      }
      // Attendre quelques secondes pour que l'utilisateur voie le message de confirmation
      await Future.delayed(const Duration(seconds: 0));
    }

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Le nombre de jours de congés pour tous les employés dont ils ont un cumule a été rénisialiser à $newConge jours.'),
        backgroundColor: Colors.green,
      ),
    );


    // Définir isLoading à false
    setState(() {
      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: const Text("Mise à jour des jours des congés"),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 78, 28, 30),
          child: Column(
            children: [
              MyTextFieldKeyWord(
                  controller: nbrJoursController,
                  hintText: "Entrer le nombre '22' de Jours",
                  obscureText: false,
              ),
              const SizedBox(height: 78,),


              //button qui renisialise le nombre des jours de congés pour tous les employés
              ElevatedButton(
                onPressed: (){
                  showDialog(context: context,
                      builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: Text(
                          "Vous étes sur de vouloir rénisialiser le nombre de jours de congés de tous les employés en "
                              "${nbrJoursController
                              .text} jours ?? !!!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Fermer la boîte de dialogue
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try{
                            // Fermer la boîte de dialogue
                            Navigator.of(context).pop();

                            // Vérification si la valeur saisie est un nombre valide
                            final String input = nbrJoursController.text;
                            if (input == null || input.isEmpty) {
                              // La valeur saisie est vide
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Veuillez saisir un nombre valide.'),
                                ),
                              );
                              return;
                            }
                            final int newConges = int.parse(input);
                            if (newConges == null || newConges <= 0) {
                              // La valeur saisie n'est pas un nombre valide ou est négative
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Veuillez saisir un nombre positif.'),
                                ),
                              );
                              return;
                            }

                            // Réinitialisation du nombre de jours de congés pour tous les employés

                              await initJoursNbr(newConges);


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
                          },
                          child: const Text('Confirmer'),
                        ),
                      ],
                    );
                  },
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[400])
                ),
                child: const Text(
                  "Rénisialiser le nombre des jours",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20,),

              //button qui cumule le nombre des jours de congés pour tous les employés
              ElevatedButton(
                onPressed: () {
                  showDialog(context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: Text(
                            "Vous étes sur de vouloir ajouter ${nbrJoursController.text} au nombre de jours de congés de tous les employés ?? !!!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Fermer la boîte de dialogue
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try{
                                // Fermer la boîte de dialogue
                                Navigator.of(context).pop();

                                // Vérification si la valeur saisie est un nombre valide
                                final String input = nbrJoursController.text;
                                if (input == null || input.isEmpty) {
                                  // La valeur saisie est vide
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Veuillez saisir un nombre valide.'),
                                    ),
                                  );
                                  return;
                                }
                                final int newConges = int.parse(input);
                                if (newConges == null || newConges <= 0) {
                                  // La valeur saisie n'est pas un nombre valide ou est négative
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Veuillez saisir un nombre positif.'),
                                    ),
                                  );
                                  return;
                                }

                                // Réinitialisation du nombre de jours de congés pour tous les employés

                                await cumuleJoursNbr(newConges);


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
                            },
                            child: const Text('Confirmer'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[400])
                ),
                child: const Text(
                  "Cumuler les Jours",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20,),


              //button qui annule le cumule
              ElevatedButton(
                onPressed: () {
                  showDialog(context: context,
                      builder: (BuildContext context)
                  {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: Text(
                          "Vous étes sur de vouloir annulé le cumule nombre de jours de congés de tous les employés en l'est rinisialisant à"
                              "${nbrJoursController
                              .text} jours ?? !!!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Fermer la boîte de dialogue
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              // Fermer la boîte de dialogue
                              Navigator.of(context).pop();

                              // Vérification si la valeur saisie est un nombre valide
                              final String input = nbrJoursController.text;
                              if (input == null || input.isEmpty) {
                                // La valeur saisie est vide
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Veuillez saisir un nombre valide.'),
                                  ),
                                );
                                return;
                              }
                              final int newConges = int.parse(input);
                              if (newConges == null || newConges <= 0) {
                                // La valeur saisie n'est pas un nombre valide ou est négative
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Veuillez saisir un nombre positif.'),
                                  ),
                                );
                                return;
                              }

                              // Réinitialisation du nombre de jours de congés pour tous les employés

                              await annulCumuleJoursNbr(newConges);
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
                          },
                          child: const Text('Confirmer'),
                        ),
                      ],
                    );
                  }
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[400])
                ),
                child: const Text(
                  "Anuller le cumule",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20,),


              Visibility(
                visible: isLoading,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            ],
          ),
        ),
      )

    );
  }
}
