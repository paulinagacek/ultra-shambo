import 'package:flutter/material.dart';
import 'package:mobile_app/loginModel.dart';
import 'package:mobile_app/views/homePage.dart';
import 'package:mobile_app/views/loginPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        // home: HomePage(),
      ),
    );
  }
}
