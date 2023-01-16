import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_app/connection/azure_connection.dart';
import 'package:mobile_app/globals.dart';
import 'package:mobile_app/widgets/buttonWidget.dart';
import 'package:flutter/services.dart';

import '../routes/CustomPageRoute.dart';
import '../widgets/alertDialog.dart';
import '../widgets/textFieldWidget.dart';
import 'homePage.dart';

class PairingPage extends StatefulWidget {
  final String email;
  final String password;

  const PairingPage({Key key, this.email, this.password}) : super(key: key);

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

    bool result = true;
    if (attempt == maxAttempts) {
      disconnect = false;
      result = false;
    }
    print("Connected :)");
    if (disconnect) {
      int attempt = 0;

      await platform.invokeMethod('disconnect');
      while (attempt < maxAttempts &&
        await platform.invokeMethod('isConnected')) {
        print("Waiting for disconnect");
        sleep(const Duration(milliseconds: 250));
        attempt++;
      }
      print("Disonnected :)");
    }
    return result;
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
  String deviceId = "";
  var azure = AzureConnection();

  final GlobalKey<FormState> _formKeyWifi = GlobalKey<FormState>();

  void onPairButtonPress() async {

    if (!_formKeyWifi.currentState.validate()) {
      return;
    }

    if (deviceId != "") {
      pairDevice();
      return;
    }
    _formKeyWifi.currentState.save();
    print("wifi: " + wifiSsid + " " + wifiPassword);

    if(! await azure.isWifiOn()) {
      print("No wifi");
      showAlertDialog(context, "Wifi disabled",
          "Please enable wifi");
      return;
    }
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
      return;
    }
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


    exchangeDataWithEsp(wifiSsid, wifiPassword,
      (data) async {
        deviceId = String.fromCharCodes(data).trim();
        print(deviceId);

        const platform = MethodChannel(
            'samples.flutter.dev/wificonnect');
        await platform.invokeMethod('disconnect');
        var attempt = 0;
        while (attempt < 40 &&
            await platform.invokeMethod('isConnected')) {
          print("Waiting for disconnect");
          sleep(const Duration(milliseconds: 250));
          attempt++;
        }
        print("Disonnected :)");
        pairDevice();
      }
    );
  }

  void pairDevice() async {
    if(! await azure.checkInternetConnection()) {
      await connectToWifi(
          wifiSsid, wifiPassword,
          disconnect: false);
    }
    if(! await azure.checkInternetConnection()) {
      print("No internet");
      showAlertDialog(context, "Internet error",
          "Check your internet connection.");
      return;
    }
    bool paired = await azure.pairDevice(widget.email, widget.password, deviceId);
    if (!paired) {
      print("Error while pairing");
      showAlertDialog(context, "Pairing error",
          "Pls try again");
      return;
    }
    Navigator.of(context).pushReplacement(
        CustomPageRoute(
            child: HomePage(
                email: widget.email,
                password: widget.password,
                deviceId: deviceId)));
  }

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
                          // suffixIconData: Icons.visibility_off,
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
                        onPressed: onPairButtonPress
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
