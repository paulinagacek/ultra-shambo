import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({Key key}) : super(key: key);

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Global.greenDark,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'You have to do',
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
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'one more thing',
                    style: TextStyle(
                      color: Global.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 60.0, left: 60.0, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:  <Widget>[
                  ButtonWidget(
                    title: 'Pair with <?>',
                    hasBorder: true,
                    onPressed: () {
                      // send to API
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ));
  }
}
