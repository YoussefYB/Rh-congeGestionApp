
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
 * 2. Non-liability: The software is provided "as is" without warranty of any kind, either express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.
 * 3. Non-commercial use: The software may not be used for commercial purposes, including without limitation the sale of the software, its derivatives, or its components.
 *
 *
 */

import 'package:flutter/material.dart';

import '../Components/my_textField.dart';

class DemandeAttSalaireForm extends StatefulWidget {
  const DemandeAttSalaireForm({Key? key}) : super(key: key);

  @override
  State<DemandeAttSalaireForm> createState() => _DemandeAttSalaireFormState();
}

class _DemandeAttSalaireFormState extends State<DemandeAttSalaireForm> {

  //text editing controllers
  final nomController = TextEditingController();
  final preNomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Demande attestation de salaire'),
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
                  MyTextField(controller: nomController, hintText: 'Nom', obscureText: false, fillColor: Colors.black12),
                  const SizedBox(height: 15),
                  MyTextField(controller: preNomController, hintText: 'Pr??nom', obscureText: false, fillColor: Colors.black12),
                  const SizedBox(height: 15),
                ],
              )
          ),
        ),
      ),
    );
  }
}
