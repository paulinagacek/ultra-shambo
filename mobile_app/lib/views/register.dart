import 'package:flutter/material.dart';
import 'package:mobile_app/loginModel.dart';
import 'package:mobile_app/routes/CustomPageRoute.dart';
import 'package:mobile_app/views/loginPage.dart';
import 'package:mobile_app/views/pairingPage.dart';
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

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  bool selected = false;

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
            height: selected ? size.height : size.height - 300,
            color: Global.greenDark,
          ),
          AnimatedPositioned(
            duration: selected
                ? const Duration(milliseconds: 2000)
                : const Duration(milliseconds: 300),
            curve: Curves.easeOutQuad,
            top: selected
                ? size.height
                : keyboardOpen
                    ? -size.height / 3.2
                    : 0.0,
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
                    visible: !selected,
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
                        controller: _password,
                        onSaved: (String value) {
                          _password.text = value;
                        },
                        onTapIcon: () {
                          model.isVisible = !model.isVisible;
                          model.notifyListeners();
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Form cannot be empty";
                          }
                          if (value.length < 8) {
                            return "Password is too short";
                          }
                        },
                        visible: !selected,
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
                        controller: _confirmpassword,
                        onSaved: (String value) {
                          _confirmpassword.text = value;
                        },
                        onTapIcon: () {
                          model.isRepeatedVisible = !model.isRepeatedVisible;
                          model.notifyListeners();
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Form cannot be empty";
                          }
                          if (value.length < 8) {
                            return "Password is too short";
                          }
                          if (_password.text!=_confirmpassword.text) {
                            return "Provided passwords are not the same";
                          }
                        },
                        visible: !selected,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ButtonWidget(
                    title: 'Create account',
                    hasBorder: false,
                    visible: !selected,
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      // send to API
                      setState(() {
                        FocusManager.instance.primaryFocus?.unfocus();
                        selected = true;
                      });
                      // if everything ok
                      Navigator.of(context)
                            .pushReplacement(CustomPageRoute(child: const PairingPage()));
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ButtonWidget(
                    title: 'I already have an account',
                    hasBorder: true,
                    visible: !selected,
                    onPressed: () {
                      debugPrint('Have account click');
                      Navigator.of(context)
                          .pushReplacement(CustomPageRoute(child: const LoginPage()));
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
