import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/homeModel.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function onChanged;

  TextFieldWidget({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);

    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: Global.greenDark,
      style: TextStyle(
        color: Global.greenDark,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Global.greenDark),
        focusColor: Global.greenDark,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Global.greenDark),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Global.greenDark,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: Global.greenDark,
          ),
        ),
      ),
    );
  }
}

