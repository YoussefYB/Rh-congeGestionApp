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

import '../Components/my_textFieldBoard.dart';
import 'package:intl/intl.dart';

import '../Data/DecisionConge.dart';

class HistoriqueDecision extends StatefulWidget {
  final String ppr;

  const HistoriqueDecision({Key? key, required this.ppr}) : super(key: key);

  @override
  State<HistoriqueDecision> createState() => _HistoriqueDecisionState();
}

class _HistoriqueDecisionState extends State<HistoriqueDecision> {

  final _moisController = TextEditingController();
  final _anneeController = TextEditingController();

  // Récupération de la référence à la collection "employes" dans Firebase
  final CollectionReference employes =
  FirebaseFirestore.instance.collection('employe');

  bool isLoading = false;// Add this variable to track loading state


  Future<List<DecisionConge>> _getDecisionsFiltrees(ppr) async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('decisionConge').get();
    final List<DecisionConge> decisionsConge = snapshot.docs.map((doc) => DecisionConge(
      id: doc.id,
      annee: doc['Année'] ?? 0,
      ppr: doc['PPR'] ?? '',
      dateDebut: doc['dateDebut'] ?? Timestamp.now(),
      dateFin: doc['dateFin'] ?? Timestamp.now(),
      dateNow: doc['dateNow'] ?? Timestamp.now(),
      nbrJour: doc['nbrJour'] ?? 0,
    )).toList();

    final int mois = int.tryParse(_moisController.text) ?? 0;
    final int annee = int.tryParse(_anneeController.text) ?? 0;
    final List<DecisionConge> decisionsFiltrees = decisionsConge.where((dec) =>
    dec.dateDebut.toDate().month == mois && dec.dateDebut.toDate().year == annee && dec.ppr == ppr).toList();

    return decisionsFiltrees;
  }


  Future<DocumentSnapshot<Map<String, dynamic>>?> getEmployeByPPR(ppr)
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

    String ppr = widget.ppr;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text("Historique de decisions par mois"),
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              controller: _moisController,
              keyWord: TextInputType.number,
              obscureText: false,
              hintText: 'Saisir le mois (1-12)',
            ),
            const SizedBox(height: 20),
            MyTextFieldKeyWord(
              controller:  _anneeController,
              keyWord: TextInputType.number,
              obscureText: false,
              hintText: 'Saisir l\'année (ex: 2023)',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Rechercher',style: TextStyle(fontSize: 25),),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<DecisionConge>>(
                future: _getDecisionsFiltrees(ppr),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  }else{
                    final List<DecisionConge> decisions = snapshot.data ?? [];
                    return ListView.builder(
                        itemCount: decisions.length,
                        itemBuilder: (context, index) {
                          final DecisionConge decision = decisions[index];
                          return ListTile(
                            title: Text(decision.ppr),
                            subtitle: Text(
                                '${decision.dateDebut.toDate()} - ${decision.dateFin.toDate()}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${decision.nbrJour} jours'),
                                  IconButton(
                                      icon:Icon(Icons.delete),
                                      onPressed: () async {
                                        int nbrJourDecision = decision.nbrJour;

                                        final employeDocSnapshot = await getEmployeByPPR(ppr);

                                        // Récupérez les données de l'employé à partir du DocumentSnapshot
                                        final employeData = employeDocSnapshot!.data();
                                        var nbrJConge = employeData!['nbrJourConge'];
                                        // Recherche de l'ID de l'employé avec le champ "ppr"
                                        QuerySnapshot querySnapshot = await employes
                                            .where('PPR', isEqualTo: ppr)
                                            .limit(1)
                                            .get();

                                        // Récupérer la référence du document à modifier
                                        DocumentReference documentReference =
                                        employes.doc(querySnapshot.docs.first.id);

                                        await documentReference.update({
                                          'nbrJourConge': nbrJConge + nbrJourDecision,
                                        });
                                        // Afficher un message de succès
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Les jours de l\'employé ont'
                                                ' été mises à jour avec succès.'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        try{
                                          final decisionRef = FirebaseFirestore.instance
                                              .collection('decisionConge')
                                              .doc(decision.id);
                                          await decisionRef.delete();
                                          setState(() {});
                                        }catch(e){
                                          // Afficher un message d'erreur
                                          print(e);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  e.toString()),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }

                                        setState(() {});
                                      },
                                  ),
                                ]
                            )
                          );
                        }
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

