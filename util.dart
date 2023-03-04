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
  final Uint8List imageDataMoroccoLogo = (await rootBundle.load('assets/moroccologo.png')).buffer.asUint8List();
  //final Uint8List imageDataMinisterLogo = (await rootBundle.load('assets/ministeresantelogo.jpg')).buffer.asUint8List();
  //final Uint8List imageDataDelegationLogo = (await rootBundle.load('assets/delegationPrefectorial.jpg')).buffer.asUint8List();
  //final Uint8List imageDataEntet = (await rootBundle.load('assets/entet.jpg')).buffer.asUint8List();

  doc.addPage(
      pw.MultiPage(
          pageTheme: pageTheme,
          header: (final context) =>
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Image(pw.MemoryImage(imageDataMoroccoLogo), width: 470),
            ),

          /*pw.Row(

            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [

              pw.Expanded(
                child:pw.Column(
              children: [
                pw.Image(pw.MemoryImage(imageDataDelegationLogo), width: 180),
                pw.Text(
                      '\nDS N°       du $formattedDateNow',
                  style: const pw.TextStyle(
                    fontSize: 16,
                  ),
                ),
              ]
          )
              ),
              pw.Image(pw.MemoryImage(imageDataMoroccoLogo), width: 100),
              pw.Image(pw.MemoryImage(imageDataMinisterLogo), width: 200),
              /*pw.Expanded(
                child: pw.Text(
                  'المملكة المغربية',
                  textAlign: pw.TextAlign.right,
                  style: const pw.TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),*/
            ],
          ),*/


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
                'Le Délégué du Ministère de la Santé et la Protection '
                  'Sociale à la Préfecture de'
                  ' Meknès et par Délégation Ministérielle.\n'
                    ' * Vu les dispositions du Dahir du 24 Février 1958 '
                    'N° 1.58.008 article 40 portant réglementation sur les '
                    'congés du personnel des Administrations Publiques, '
                    'comme il a été modifié et complété.\n'
                    ' * Vu les dispositions des lettres Ministérielle '
                    'N° 5708 du 13/03/2020 et N° 10305 du 02/06/2021 '
                    'relatives aux congés administratifs durant '
                    'la pandémie (COVID-19)\n'
                    ' * Vu la demande de congé présente par Mr(Mme) : ${nom}\n'
                    " * Considérant les Droits à congé de l'intéressé(e) au titre de l'année: ${annee}",
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
                text: "   *Au titre de l'année          ",
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
                text: "   *Est accordé à Mr(Mme) ",
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
                text: "   *PPR                                 ",
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
                text: "   *En Fonction                    ",
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
                text: "   *A compter du                 ",
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
                    text: "-L'intérim sera assuré par ",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: "\n                                             "
                        "-En cas de nécessité de service le congé sera suspendu.",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: "\n                                                 "
                        "-L'intéressée doit être joignable durant la période du congé.",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text: "\n                                         "
                        "LE DELEGUE DU MINISTERE DE LA SANTE\n"
                        "                   "
                        "ET LA PROTECTION SOCIALE A LA PREFECTURE DE MEKNES",
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
                text: "   *Mr le chef de SRES",
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: "   *L'intéressé(e)(V.H)",
                style: pw.TextStyle(
                  fontSize: 17,
                  fontWeight: pw.FontWeight.normal,
                  //color: PdfColors.black,
                ),
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: "   *Dossier",
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


