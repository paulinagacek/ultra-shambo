import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/loginModel.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function onChanged;
  final Function onSaved;
  final Function validator;
  final Function onTapIcon;

  TextFieldWidget({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context);
    basicValidator(String value) {
      if (value.isEmpty) {
        return "Form cannot be empty";
      }
    }

    return TextFormField(
      validator: validator ?? basicValidator,
      onChanged: onChanged,
      onSaved: onSaved,
      obscureText: obscureText,
      cursorColor: Global.greenDark,
      style: const TextStyle(
        color: Global.greenDark,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Global.greenDark),
        focusColor: Global.greenDark,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Global.greenDark),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Global.greenDark,
        ),
        suffixIcon: GestureDetector(
          onTap: onTapIcon,
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
