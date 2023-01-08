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

import '../routes/CustomPageRoute.dart';
import '../widgets/alertDialog.dart';
import '../widgets/textFieldWidget.dart';
import 'homePage.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({Key key}) : super(key: key);

  @override
  State<PairingPage> createState() => _PairingPageState();
}

Future<bool> connectToWifi(ssid, password, {bool disconnect = false}) async {
  const platform = MethodChannel('samples.flutter.dev/wificonnect');
  int maxAttempts = 40;
  try {
    await platform
        .invokeMethod('connectToWifi', {"SSID": ssid, "password": password});
    int attempt = 0;
    while (attempt < maxAttempts &&
        !(await platform.invokeMethod('isConnected'))) {
      print("Waiting for connection");
      sleep(const Duration(milliseconds: 250));
      attempt++;
    }
    if (attempt == maxAttempts) {
      await platform.invokeMethod('disconnect');
      return false;
    }
    print("Connected :)");
    if (disconnect) {
      await platform.invokeMethod('disconnect');
      while (await platform.invokeMethod('isConnected')) {
        print("Waiting for disconnect");
        sleep(const Duration(milliseconds: 250));
      }
      print("Disonnected :)");
    }
    return true;
  } on PlatformException catch (e) {
    print("Connection error: '${e.message}'.");
  }
  return false;
}

Socket socket;
int port = 8888;

void exchangeDataWithEsp(ssid, password, dataCallback) {
  print("<33333333333 ------------ <3333 ------ <3 <3>");
  Socket.connect("192.168.4.1", port).then((Socket sock) {
    socket = sock;
    socket.listen(createdataHandler(dataCallback),
        onError: null, onDone: doneHandler, cancelOnError: false);
    socket.write("$ssid;$password");
  }).catchError((Object e) {
    print("Unable to connect: $e");
  });
  print("Waiting for deviceId");
}

void Function(Uint8List) createdataHandler(dataCallback) {
  return (data) {
  print("got data");
  dataCallback(data);
  };
}

errorHandler(Object error) {
  print(error);
}

void doneHandler() {
  socket.destroy();
}

class _PairingPageState extends State<PairingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connected = false;
  }

  bool _connected = false;
  String wifiSsid = "";
  String wifiPassword = "";
  final String espSsid = "ESP WIFI";
  final String espPassword = "iotiot420";

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
                  ? const EdgeInsets.only(top: 120.0)
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
                    Visibility(
                      visible: true, //!_connected,
                      child: ButtonWidget(
                        title:
                            !_connected ? 'Pair with ESP' : "Connected to wifi",
                        hasBorder: true,
                        onPressed: () async {
                          if (!_formKeyWifi.currentState.validate()) {
                            return;
                          }
                          _formKeyWifi.currentState.save();
                          print("wifi: " + wifiSsid + " " + wifiPassword);

                          // connect to local wifi
                          bool connectedToLocal = await connectToWifi(
                              wifiSsid, wifiPassword,
                              disconnect: true);
                          if (!connectedToLocal) {
                            // do sth
                            showAlertDialog(context, "Connection error",
                                "Provided ssid or password is incorrect. Try again with correct data.");
                            // Navigator.of(context).push(alert);
                            print("Cannot connect to local wifi");
                          } else {
                            print("Connected to local wifi" + wifiSsid);
                            bool connected =
                                await connectToWifi(espSsid, espPassword);
                            setState(() {
                              _connected = connected;
                            });
                            if (!_connected) {
                              print("Did not connect to esp");
                              return;
                            }

                            exchangeDataWithEsp(wifiSsid, wifiPassword, (data) async {
                              String deviceId = String.fromCharCodes(data).trim();
                              print(deviceId);

                              const platform = MethodChannel('samples.flutter.dev/wificonnect');
                              await platform.invokeMethod('disconnect');

                              // send device to api TODO
                              Navigator.of(context).pushReplacement(
                                  CustomPageRoute(child: const HomePage()));
                            });
                          }
                        },
                      ),
                    )
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
