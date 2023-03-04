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
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../util/util.dart';

class DecisionPdf extends StatefulWidget {
  const DecisionPdf({
    required this.pPR,
    required this.nom,
    required this.lieuFonction,
    required this.grade,
    required this.annee,
    required this.nbrJour,
    required this.dateDebutConge,
    Key? key,
  }) : super(key: key);

  final String pPR;
  final String nom;
  final String lieuFonction;
  final String grade;
  final String annee;
  final String nbrJour;
  final String dateDebutConge;

  @override
  // ignore: no_logic_in_create_state
  State<DecisionPdf> createState() => _DecisionPdfState(
      pPR,
      nom,
      lieuFonction,
      grade,
      annee,
      nbrJour,
      dateDebutConge
  );
}

class _DecisionPdfState extends State<DecisionPdf> {
  PrintingInfo? printingInfo;

  _DecisionPdfState(
      this.pPR,
      this.nom,
      this.lieuFonction,
      this.grade,
      this.annee,
      this.nbrJour,
      this.dateDebutConge,
      );

  final String pPR;
  final String nom;
  final String lieuFonction;
  final String grade;
  final String annee;
  final String nbrJour;
  final String dateDebutConge;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Decision PDF"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: (format) => generatPdf(
          format,
          widget.pPR,
          widget.nom,
          widget.lieuFonction,
          widget.grade,
          widget.annee,
          widget.nbrJour,
          widget.dateDebutConge,
        ),
      ),
    );
  }
}


