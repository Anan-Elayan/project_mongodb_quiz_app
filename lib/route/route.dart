import 'package:app/services/networking.dart';
import 'package:app/services/pref.dart';

import '../constant/constant.dart';

class Routing {
  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
    String role,
    String selectedTeacher,
  ) async {
    try {
      if (role == 'Teacher') {
        NetworkingHelper networkingHelper =
            NetworkingHelper("$apiUrl/users/register");
        Map<String, dynamic> body = {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        };
        var response = await networkingHelper.postData(body);
        return response;
      } else {
        NetworkingHelper networkingHelper =
            NetworkingHelper("$apiUrl/users/register");
        Map<String, dynamic> body = {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
          "teacher_id": selectedTeacher,
        };
        var response = await networkingHelper.postData(body);
        return response;
      }
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  Future<List<Map<String, String>>> getTeachersIdAndName() async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/getTeachers");
      var response = await networkingHelper.getDataAsList();
      if (response != null && response is List) {
        List<Map<String, String>> teachers = [];
        for (int i = 0; i < response.length; i++) {
          Map<String, dynamic> item = response[i];
          teachers.add({
            "id": item["_id"] ?? "",
            "name": item["name"] ?? "",
          });
        }
        print("response in getTeachers ${response}");
        return teachers;
      } else {
        print("Invalid response format or null response");
        return [];
      }
    } catch (e) {
      print("Error fetching teachers: $e");
      return [];
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
        int totalStudents = response['totalStudents'] ?? 0;
        return {'totalStudents': totalStudents};
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
    int questionRating,
  ) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/add");
      Map<String, dynamic> body = {
        "question": questionText,
        "choices": choices,
        "correctAnswer": correctAnswer,
        "questionRat": questionRating,
      };
      var response = await networkingHelper.postData(body);
      return response;
    } catch (e) {
      print("Error adding question: $e");
      return null;
    }
  }

  Future<int> getTotalQuestionCount() async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/getQuestionCount");
      var response = await networkingHelper.getData();
      if (response != null && response.containsKey('totalQuestions')) {
        return response['totalQuestions'];
      } else {
        print("Invalid response format or null response");
        return 0;
      }
    } catch (e) {
      print("error");
      return 0;
    }
  }

  Future<String> getUserId(String email, String password) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/getUserId");
      Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };
      var response = await networkingHelper.postData(body);
      if (response["message"] == "Login successful") {
        return response["userId"];
      }
    } catch (e) {
      print("Error ->: ${e.toString()}");
    }
    return '';
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      String userId = await getUserIdFromPref();
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/getUserById");
      Map<String, dynamic> body = {
        "id": userId,
      };
      var response = await networkingHelper.postData(body);
      if (response != null) {
        print("response is ${response}");
        print("response user  ${response['user']}");
        return response['user'];
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<bool> updateUserProfile(
      String name, String email, String password) async {
    try {
      String userId = await getUserIdFromPref();
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/updateUserProfile");
      Map<String, dynamic> body = {
        "id": userId,
        "name": name,
        "email": email,
        "password": password,
      };
      var response = await networkingHelper.postData(body);
      if (response != null) {
        print("response is ${response}");
      }
      return true;
    } catch (e) {
      print("error when update profile data ${e.toString()}");
      return false;
    }
  }
}
