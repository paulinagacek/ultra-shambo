import 'dart:convert';

import 'package:http/http.dart' as http;

class AzureConnection {
  Future<bool> logUser(String email, String password) async {
    final response = await http
        .get(Uri.parse('https://shamboo-backend.azure-api.net/tableService/logUser?email=$email&password=$password'));
    print(response.body);
    return response.statusCode == 200;
  }
}

// class Album {
//   final int userId;
//   final int id;
//   final String title;
//
//   const Album({
//     required this.userId,
//     required this.id,
//     required this.title,
//   });
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }