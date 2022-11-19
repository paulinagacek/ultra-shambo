import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/routes/CustomPageRoute.dart';
import 'package:mobile_app/views/loginPage.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/homeModel.dart';
import 'package:mobile_app/widgets/textFieldWidget.dart';
import 'package:mobile_app/widgets/waveWidget.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
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
            duration: const Duration(milliseconds: 500),
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
              children: const <Widget>[
                Text(
                  'Create new account in',
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
              children: const <Widget>[
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
                const SizedBox(
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
                  ],
                ),
                const SizedBox(
                  height: 35.0,
                ),
                ButtonWidget(
                  title: 'Create account',
                  hasBorder: false,
                  onPressed: () {
                    debugPrint('Create accout click');
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ButtonWidget(
                  title: 'I already have an account',
                  hasBorder: true,
                  onPressed: () {
                    debugPrint('Have account click');
                    Navigator.of(context)
                        .push(CustomPageRoute(child: LoginPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
