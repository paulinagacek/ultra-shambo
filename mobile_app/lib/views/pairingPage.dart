import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import '../widgets/textFieldWidget.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({Key key}) : super(key: key);

  @override
  State<PairingPage> createState() => _PairingPageState();
}

Socket socket;
String espSsid = "ESP WIFI";
String espPassword = "iotiot420";
int port = 8888;

Future<bool> connectToespWifi() async {
  const platform = MethodChannel('samples.flutter.dev/wificonnect');
  try {
    await platform.invokeMethod(
        'connectToWifi', {"SSID": espSsid, "password": espPassword});
    while (!(await platform.invokeMethod('isConnected'))) {
      print("Waiting for connection");
      sleep(const Duration(milliseconds: 250));
    }
    print("Connected :)");
    return true;
  } on PlatformException catch (e) {
    print("Connection error: '${e.message}'.");
  }
  return false;
}

void exchangeDataWithEsp() {
  Socket.connect("192.168.4.1", port).then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
        onError: null, onDone: doneHandler, cancelOnError: false);
    socket.write("Redmi Note 11;bananaski");
  }).catchError((Object e) {
    print("Unable to connect: $e");
  });
  //Connect standard in to the socket
}

void dataHandler(data) {
  print("got data");
  print(String.fromCharCodes(data).trim());
}

errorHandler(Object error) {
  print(error);
}

void doneHandler() {
  socket.destroy();
}

class _PairingPageState extends State<PairingPage> {
  bool _connected = false;
  String wifiSsid = "";
  String wifiPassword = "";

  final GlobalKey<FormState> _formKeyWifi = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    bool selected = true;
    return Scaffold(
        backgroundColor: Global.greenDark,
        body: Stack(
          children: <Widget>[
            Container(
              height: keyboardOpen ? 0 : 300,
              child: Padding(
                padding: const EdgeInsets.only(top: 130.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'You have to do\none more thing',
                      style: TextStyle(
                        color: Global.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: keyboardOpen
                  ? const EdgeInsets.only(top: 150.0)
                  : const EdgeInsets.only(top: 350.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'provide your wifi details',
                    style: TextStyle(
                      color: Global.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: keyboardOpen
                  ? const EdgeInsets.all(30)
                  : const EdgeInsets.only(bottom: 100.0, left: 30, right: 30),
              child: Form(
                key: _formKeyWifi,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextFieldWidget(
                      hintText: 'Wifi ssid',
                      obscureText: false,
                      prefixIconData: null,
                      suffixIconData: null,
                      onChanged: (value) {
                        // model.isValidEmail(value);
                      },
                      onSaved: (String value) {
                        wifiSsid = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Form cannot be empty";
                        }
                      },
                      visible: true,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextFieldWidget(
                          hintText: 'Password',
                          obscureText: true,
                          prefixIconData: Icons.lock_outline,
                          onTapIcon: () {
                            // model.isVisible = !model.isVisible;
                            // model.notifyListeners();
                          },
                          suffixIconData: Icons.visibility_off,
                          onSaved: (String value) {
                            wifiPassword = value;
                          },
                          visible: true,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    ButtonWidget(
                      title: !_connected ? 'Pair with ESP' : "Connected",
                      hasBorder: true,
                      onPressed: () async {
                        bool connected = await connectToespWifi();
                        setState(() {
                          _connected = connected;
                        });
                        exchangeDataWithEsp();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 200.0,
            ),
          ],
        ));
  }
}
