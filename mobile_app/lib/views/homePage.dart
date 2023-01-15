import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_app/connection/azure_connection.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/waveWidget.dart';

class HomePage extends StatefulWidget {
  final String deviceId;
  final String email;
  final String password;

  const HomePage({Key key,  this.email, this.password, this.deviceId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _distance = 50;
  double _fillPercentage = 0;
  Timer timer;
  var azure = AzureConnection();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => updateDistance());
    updateDistance();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateDistance() async {
    var distance = await azure.getLastRead(widget.email, widget.password, widget.deviceId);
    setState(() {
      _distance = distance;
      _fillPercentage = max(0, 100 - _distance / 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        'Your shamboo (${widget.deviceId}) is full in';
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
              padding: EdgeInsets.only(top: size.height * 0.5 + 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _distance.toString(),
                    style: const TextStyle(
                      color: Global.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
