import 'package:app/services/networking.dart';

import '../constant/constant.dart';

class Routing {
  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
    String registerAs,
  ) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/register");
      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "password": password,
        "registerAs": registerAs,
      };
      var response = await networkingHelper.postData(body);
      return response;
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/login");
      Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };
      var response = await networkingHelper.postData(body);
      return response;
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAnalytics() async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/analytics");
      var response = await networkingHelper.getData();
      if (response != null) {
        int totalAdmins = response['totalAdmins'] ?? 0;
        int totalUsers = response['totalUsers'] ?? 0;
        return {'totalAdmins': totalAdmins, 'totalUsers': totalUsers};
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching analytics: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> addQuestion(
    String questionText,
    List<String> choices,
    String correctAnswer,
  ) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/add");
      Map<String, dynamic> body = {
        "question": questionText,
        "choices": choices,
        "correctAnswer": correctAnswer,
      };
      var response = await networkingHelper.postData(body);
      return response;
    } catch (e) {
      print("Error adding question: $e");
      return null;
    }
  }
}
