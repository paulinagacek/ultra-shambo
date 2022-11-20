import 'package:flutter/material.dart';
import 'package:mobile_app/loginModel.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/textFieldWidget.dart';
import 'package:mobile_app/widgets/waveWidget.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email;
  String _password;
  String _repeatedPassword;

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
            top: keyboardOpen ? -size.height / 2.6 : 0.0,
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
                        onSaved: (String value) {
                          _password = value;
                        },
                        onTapIcon: () {
                          model.isVisible = !model.isVisible;
                          model.notifyListeners();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        hintText: 'Confirm Password',
                        obscureText: model.isRepeatedVisible ? false : true,
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: model.isRepeatedVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSaved: (String value) {
                          _repeatedPassword = value;
                        },
                        onTapIcon: () {
                          model.isRepeatedVisible = !model.isRepeatedVisible;
                          model.notifyListeners();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ButtonWidget(
                    title: 'Create account',
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
                    title: 'I already have an account',
                    hasBorder: true,
                    onPressed: () {
                      debugPrint('Have account click');
                      Navigator.of(context).pop();
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
