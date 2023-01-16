import 'dart:convert';
import 'dart:io';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AzureConnection {
  AzureConnection() {
    AndroidFlutterWifi.init();
  }

  Future<void> enableWifi() async {
    await AndroidFlutterWifi.enableWifi();
  }

  Future<bool> isWifiOn() async{
    return await AndroidFlutterWifi.isWifiEnabled();
  }

  Future<bool> checkInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  Future<bool> logUser(String email, String password) async {
    Response response;
    try {
      response = await http
          .get(Uri.parse('https://shamboo-backend.azure-api.net/tableService/logUser?email=$email&password=$password'));
      print(response.body);
    } catch (e) {
      print(e);
    }
    return response?.statusCode == 200;
  }

  Future<String> getPairedDevice(String email, String password) async {
    Response response;
    try {
      response = await http
          .get(Uri.parse('https://shamboo-backend.azure-api.net/tableService/deviceId?email=$email&password=$password'));
      print(response.body);
    } catch (e) {
      print(e);
    }
    return response?.body ?? "";
  }

  Future<double> getLastRead(String email, String password, String deviceId) async {
    double result = -1;
    try {
      final response = await http
          .get(Uri.parse('https://shamboo-backend.azure-api.net/readBlobApp/getLastAddedBlob?email=$email&password=$password&device_id=$deviceId'));
      print(response.body);
      result = double.parse(response?.body ?? "-1");
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<bool> registerUser(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };
    print(body);
    final jsonString = json.encode(body);
    final uri = Uri.parse('https://shamboo-backend.azure-api.net/tableService/registerUser');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    Response response;
    try {
      response = await http
          .post(uri, headers: headers, body: jsonString);
      print(response.body);
    } catch (e) {
      print(e);
    }
    return response?.statusCode == 201;
  }

  Future<bool> pairDevice(String email, String password, String deviceId) async {
    final body = {
      'email': email,
      'password': password,
      "deviceID": deviceId,
    };
    print(body);
    final jsonString = json.encode(body);
    final uri = Uri.parse('https://shamboo-backend.azure-api.net/tableService/pairdevice');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    Response response;
    try {
      response = await http
          .put(uri, headers: headers, body: jsonString);
      print(response.body);
    } catch (e) {
      print(e);
    }
    return response?.statusCode == 200;
  }
}
