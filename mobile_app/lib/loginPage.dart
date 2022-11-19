import 'package:flutter/material.dart';
import 'package:mobile_app/buttonWidget.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/textFieldWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Global.white,
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextFieldWidget(
                  hintText: 'Email',
                  obscureText: false,
                  prefixIconData: Icons.mail_outline_rounded,
                  suffixIconData: Icons.one_k,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        hintText: 'Password',
                        obscureText: false,
                        prefixIconData: Icons.lock_outline_rounded,
                        suffixIconData: Icons.one_k,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Forgot password?",
                        style: TextStyle(color: Global.greenDark),
                      ),
                    ]),
                const SizedBox(
                  height: 20.0,
                ),
                ButtonWidget(title: 'Login', hasBorder: false),
                const SizedBox(
                  height: 10.0,
                ),
                ButtonWidget(title: 'Sign up', hasBorder: true),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            )));
  }
}
