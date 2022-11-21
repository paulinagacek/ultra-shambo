import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mobile_app/views/register.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/loginModel.dart';
import 'package:mobile_app/widgets/textFieldWidget.dart';
import 'package:mobile_app/widgets/waveWidget.dart';
import 'package:provider/provider.dart';
import '../routes/CustomPageRoute.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<LoginModel>(context);
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
            top: keyboardOpen ? -size.height / 3.2 : 0.0,
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextFieldWidget(
                    hintText: 'Email',
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,
                    suffixIconData: model.isEmailValid ? Icons.check : null,
                    onChanged: (value) {
                      model.isValidEmail(value);
                    },
                    onSaved: (String value) {
                      _email = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Form cannot be empty";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "Input correct email";
                      }
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
                        onTapIcon: () {
                          model.isVisible = !model.isVisible;
                          model.notifyListeners();
                        },
                        suffixIconData: model.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSaved: (String value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () {
                          debugPrint('Forget password click');
                        },
                        style: const ButtonStyle(
                          overlayColor: MaterialStatePropertyAll<Color>(
                              Global.greenDarkTranparent),
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Global.greenDark,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  ButtonWidget(
                    title: 'Login',
                    hasBorder: false,
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      // send to API
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ButtonWidget(
                    title: 'Sign Up',
                    hasBorder: true,
                    onPressed: () {
                      debugPrint('Sign up click');
                      Navigator.of(context)
                          .push(CustomPageRoute(child: RegisterPage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
