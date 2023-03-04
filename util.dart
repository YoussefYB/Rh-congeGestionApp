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

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';


Future<Uint8List>generatPdf(
    final PdfPageFormat format,
    String pPR,
    String nom,
    String lieuFonction,
    String grade, String annee,
    String nbrJour,
    String dateDebutConge)
async{
  final doc = pw.Document(
    title: 'DECISION',
  );

  final pageTheme = await _myPageTheme(format);

  final now = DateTime.now();
  final formattedDateNow = '${now.day}/${now.month}/${now.year}';

  // Chargement de l'image à partir du dossier assets
  final Uint8List image = (await rootBundle.load('assets/image')).buffer.asUint8List();

  doc.addPage(
      pw.MultiPage(
          pageTheme: pageTheme,
          header: (final context) =>
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Image(pw.MemoryImage(image), width: 470),
              ),



          build: (final context) =>[
            pw.Text(
              '\nDS N°       du $formattedDateNow',
              style: const pw.TextStyle(
                fontSize: 16,
              ),
            ),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Text(
                  'DECISION',
                  style: pw.TextStyle(
                    fontSize: 20,
                    decoration: pw.TextDecoration.underline,
                    fontWeight: pw.FontWeight.bold,

                  ),
                ),
              ),
            ),
            pw.Text(
              "lorem",
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Text(
                  'DECIDE',
                  style: pw.TextStyle(
                    fontSize: 20,
                    decoration: pw.TextDecoration.underline,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: '*Article Unique                    ',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    style: pw.TextStyle(
                      decoration: pw.TextDecoration.none,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                    text: ':Un Congé Administratif de ${nbrJour} Jours ouvrables\n',

                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "            ",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: ':${annee}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "   *Est accord(Mme) ",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: ':${nom}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "   *jjkpk                               ",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: ':${pPR}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "   *Grade                              ",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: ':${grade}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "   *En Fonct                ",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: ':${lieuFonction}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "   *A co du                 ",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: ':${dateDebutConge}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            pw.RichText(
              text: pw.TextSpan(
                text: "\n   NB :                  ",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
                children: [
                  pw.TextSpan(
                    text: "-L'inra as par ",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: "\n                                             "
                        "-En cas de nécice le congé sera suspendu.",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: "\n                                                 "
                        "-L'intnt la période du congé.",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: "\n                                         "
                        "LEE\n"
                        "                   "
                        "E",
                    style: pw.TextStyle(
                      fontSize: 15,
                      decoration: pw.TextDecoration.underline,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: "\n   Ampliations:\n\n",
                style: pw.TextStyle(
                  fontSize: 17,
                  decoration: pw.TextDecoration.underline,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: "   *M",
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: "   *L'in)",
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: "   *Doser",
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
              ),
            )
          ]
      )
  );
  return doc.save();
}

Future<pw.PageTheme>_myPageTheme(PdfPageFormat format)async{
  return const pw.PageTheme(
    margin: pw.EdgeInsets.symmetric(
        horizontal: 1*PdfPageFormat.cm, vertical: 2*PdfPageFormat.cm
    ),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: null,
  );
}

Future<void> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
    )async{
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print("save as file ${file.path}...");
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Document est bien imprimer")));
}

void showSharedToast(final BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Document est bien partager")));
}

