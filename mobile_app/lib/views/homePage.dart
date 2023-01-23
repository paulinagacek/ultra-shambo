import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app/connection/azure_connection.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/views/loginPage.dart';
import 'package:mobile_app/views/pairingPage.dart';
import 'package:mobile_app/widgets/waveWidget.dart';

import '../routes/CustomPageRoute.dart';
import '../widgets/buttonWidget.dart';

class HomePage extends StatefulWidget {
  final String deviceId;
  final String email;
  final String password;

  const HomePage({Key key, this.email, this.password, this.deviceId})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _distance = 50;
  double _fillPercentage = 75;
  Timer timer;
  var azure = AzureConnection();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => updateDistance());
    updateDistance();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateDistance() async {
    var distance =
        await azure.getLastRead(widget.email, widget.password, widget.deviceId);
    setState(() {
      _distance = distance;
      _fillPercentage = max(0, 100 - _distance / 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = 'Your cesspool is';
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
        backgroundColor: Global.greenDark,
        body: Stack(
          children: <Widget>[
            Container(
              height: size.height - 300,
              color: Global.white,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuad,
              top: keyboardOpen ? -size.height / 3.2 : 0.0,
              child: WaveWidget(
                size: size,
                yOffset: _fillPercentage > 35
                    ? size.height / (6.0 * (_fillPercentage / 100) + 0.3)
                    : size.height / 2.5,
                color: Global.greenDark,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: size.height * 0.5, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    title,
                    style: const TextStyle(
                      color: Global.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.5 + 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${_distance.toStringAsFixed(2)} cm",
                    style: const TextStyle(
                      color: Global.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.5 + 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "away from overflow",
                    style: const TextStyle(
                      color: Global.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: size.height * 0.8, right: 30, left: 30),
              child: ButtonWidget(
                  title: 'Pair again',
                  hasBorder: false,
                  visible: true,
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(CustomPageRoute(
                        child: PairingPage(
                            email: widget.email, password: widget.password)));
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: size.height * 0.9, right: 30, left: 30),
              child: ButtonWidget(
                  title: 'Log out',
                  hasBorder: false,
                  visible: true,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        CustomPageRoute(child: const LoginPage()));
                  }),
            )
          ],
        ));
  }
}
