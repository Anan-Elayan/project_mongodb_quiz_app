import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkingHelper {
  final String url;
  NetworkingHelper(this.url);

  Future<dynamic> postData(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse is List) {
      return decodedResponse;
    } else if (decodedResponse is Map) {
      return decodedResponse as Map<String, dynamic>;
    } else {
      throw Exception('Unexpected response formats');
    }
  }

  Future<Map<String, dynamic>?> updateData(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 404) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getData() async {
    try {
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to load data: ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error during network request: $e");
      throw Exception('Error during network request: $e');
    }
  }

  Future<List<dynamic>?> getDataAsList() async {
    try {
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to load data: ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error during network request: $e");
      throw Exception('Error during network request: $e');
    }
  }

  // String id
// Function to send the DELETE request to the API
  Future<bool> deleteData(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);

    try {
      // Send the DELETE request with the body
      http.Response response = await http.delete(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
