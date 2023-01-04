import 'package:flutter/material.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/waveWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double fullPercent = 36;

  @override
  Widget build(BuildContext context) {
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
                yOffset: fullPercent > 35
                    ? size.height / (6.0 * (fullPercent / 100) + 0.3)
                    : size.height / 2.5,
                color: Global.greenDark,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Your shamboo is full in',
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
              padding: EdgeInsets.only(top: size.height * 0.5 + 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    '36%',
                    style: TextStyle(
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
