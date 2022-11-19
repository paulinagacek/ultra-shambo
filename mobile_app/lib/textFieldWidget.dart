import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  // final Function onChanged;

  TextFieldWidget({
    required this.hintText,
    required this.prefixIconData,
    required this.suffixIconData,
    required this.obscureText,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.blue, fontSize: 14),
      cursorColor: Colors.blue,
      // onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Colors.blue,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: UnderlineInputBorder(
            // when not focused
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          suffixIconData,
          color: Colors.blue,
          size: 18,
        ),
        labelStyle: TextStyle(color: Colors.blue),
        focusColor: Colors.blue,
      ),
    );
  }
}
