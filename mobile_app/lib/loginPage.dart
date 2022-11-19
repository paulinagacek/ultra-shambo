import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/homeModel.dart';
import 'package:mobile_app/widgets/textFieldWidget.dart';
import 'package:mobile_app/widgets/waveWidget.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<HomeModel>(context);

    return Scaffold(
      backgroundColor: Global.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height - 300,
            color: Global.greenDark,
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 2.5,
              color: Global.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ultra shamboo',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextFieldWidget(
                  hintText: 'Email',
                  obscureText: false,
                  prefixIconData: Icons.mail_outline,
                  suffixIconData: model.isValid ? Icons.check : null,
                  onChanged: (value) {
                    model.isValidEmail(value);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextFieldWidget(
                      hintText: 'Password',
                      obscureText: model.isVisible ? false : true,
                      prefixIconData: Icons.lock_outline,
                      suffixIconData: model.isVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Global.greenDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                ButtonWidget(
                  title: 'Login',
                  hasBorder: false,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ButtonWidget(
                  title: 'Sign Up',
                  hasBorder: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
