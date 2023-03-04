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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_rh_application/form_pages/DemadeAttSalaireForm.dart';

import '../Components/square.dart';
import '../form_pages/DecisionCongeForm.dart';
import '../form_pages/historiqueDecisionForm.dart';
import '../form_pages/historiqueDecisionPerMoisEtAnné.dart';

class DecisionCongePage extends StatefulWidget {
  const DecisionCongePage({Key? key}) : super(key: key);

  @override
  State<DecisionCongePage> createState() => _DecisionCongePageState();
}

class _DecisionCongePageState extends State<DecisionCongePage> {

  final List dataList = [
    "Ajouter Decision de congé",
    "Historique de decisions par mois"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text("Decision"),
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

      //body

      body: Padding(
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
                        const DemandCongerForm()),
                      );
                    }
                  }
                  break;
                  case 1 : {
                    if (kDebugMode) {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoriqueDecisionParMoisEtAnnee()),
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
    );
  }
}
