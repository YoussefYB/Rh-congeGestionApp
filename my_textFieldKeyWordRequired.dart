
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

import 'package:flutter/material.dart';

class MyTextFieldKeyWordRequired extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final fillColor;
  final keyWord;

  const MyTextFieldKeyWordRequired({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.fillColor,
    this.keyWord,
  }) : super(key: key);

  @override
  _MyTextFieldKeyWordRequiredState createState() =>
      _MyTextFieldKeyWordRequiredState();
}

class _MyTextFieldKeyWordRequiredState
    extends State<MyTextFieldKeyWordRequired> {
  bool _isFilled = false;

  @override
  void initState() {
    super.initState();
    _isFilled = widget.controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyWord,
        onChanged: (text) {
          setState(() {
            _isFilled = text.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: _isFilled ? Colors.green[100] : widget.fillColor,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          suffixIcon: _isFilled
              ? const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 12,
          )
              : null,
        ),
      ),
    );
  }
}
