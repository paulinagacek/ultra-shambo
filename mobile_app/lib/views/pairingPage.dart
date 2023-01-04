import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:location/location.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({Key key}) : super(key: key);

  @override
  State<PairingPage> createState() => _PairingPageState();
}

String espSsid = "ESP WIFI";
String espPassword = "iotiot420";
bool connected = false;

void connectToespWifi() async {
  Location location = new Location();
  location.enableBackgroundMode(enable: true);
  print('Ssid: $espSsid, Password: $espPassword');
  var result = await AndroidFlutterWifi.connectToNetwork(espSsid, espPassword);
  if (result) {
    print('\n Mobile connected successfuly!');
  } else {
    print('\nCannot connect :(');
  }
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
                children: <Widget>[
                  ButtonWidget(
                    title: !connected ? 'Pair with ESP' : "Connected",
                    hasBorder: true,
                    onPressed: () {
                      connectToespWifi();
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
