import 'package:app/services/networking.dart';
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      if (response != null) {
        List<Map<String, String>> teachers = [];
        for (int i = 0; i < response.length; i++) {
          Map<String, dynamic> item = response[i];
          teachers.add({
            "id": item["_id"] ?? "",
            "name": item["name"] ?? "",
          });
        }
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

  Future<Map<String, dynamic>?> getAnalytics(String id) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/analytics");
      print("id = ${id}");
      Map<String, dynamic> body = {"teacher_id": id};
      var response = await networkingHelper.postData(body);
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
    String teacherId,
  ) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/add");
      Map<String, dynamic> body = {
        "question": questionText,
        "choices": choices,
        "correctAnswer": correctAnswer,
        "questionRat": questionRating,
        "teacherId": teacherId,
      };
      var response = await networkingHelper.postData(body);
      return response;
    } catch (e) {
      print("Error adding question: $e");
      return null;
    }
  }

  Future<int> getTotalQuestionCount(String teacherId) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/getQuestionCount");
      Map<String, dynamic> body = {
        "teacherId": teacherId,
      };
      var response = await networkingHelper.postData(body);
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
      Map<String, dynamic> body = {"id": userId};
      var response = await networkingHelper.postData(body);
      if (response != null) {
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
      return response != null;
    } catch (e) {
      return false;
    }
  }

  //----------------------------------------------------------------------------
  Future<List<dynamic>> getQuestionByTeacherId(
      String teacherId, String sortOrder) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/getQuestionsByTeacherId");
      Map<String, dynamic> body = {
        "teacherId": teacherId,
        "sortOrder": sortOrder, // Pass sortOrder here
      };
      final response = await networkingHelper.postData(body);
      if (response is List) {
        return response;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print("Exception in fetching questions: ${e.toString()}");
      return [];
    }
  }

  Future<bool> deleteQuestion(String questionId) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/deleteQuestionById");
      Map<String, dynamic> body = {
        "questionId": questionId,
      };
      final response = await networkingHelper.deleteData(body);
      print(response);
      if (response != null) {
        print("response return after delete question ${response}");
        Fluttertoast.showToast(
          msg: "Question deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else {
        print("in else ");
        return false;
      }
    } catch (e) {
      print("Exception in fetching questions: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateQuestion(
    String questionId,
    String question,
    List<String> choices,
    String correctAnswer,
    int questionRating,
  ) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/updateQuestion");
      Map<String, dynamic> body = {
        "questionId": questionId,
        "question": question,
        "choices": choices,
        "correctAnswer": correctAnswer,
        "questionRat": questionRating,
      };
      final response = await networkingHelper.postData(body);
      if (response != null &&
          response['message'] == 'Question updated successfully') {
        Fluttertoast.showToast(
          msg: "Question updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update question",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<int> getNumberOfQuestionByTeacher(String teacherId) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/getQuestionCount");
      Map<String, dynamic> body = {
        "teacherId": teacherId,
      };
      var response = await networkingHelper.postData(body);
      if (response != null && response.containsKey('totalQuestions')) {
        return response['totalQuestions'];
      } else {
        return 0;
      }
    } catch (e) {
      print("error");
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsByTeacherId(
    String teacherId,
  ) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/users/getStudentsByTeacherId");
      Map<String, dynamic> body = {
        "teacher_id": teacherId,
      };
      var response = await networkingHelper.postData(body);
      if (response != null && response['students'] != null) {
        return List<Map<String, dynamic>>.from(response['students']);
      } else {
        print("Invalid response format or null response");
        return [];
      }
    } catch (e) {
      print(
          "Some issues occurred while getting students by teacher ID. ${e.toString()}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsForUsers(
      String teacherId) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/getQuestions");
      Map<String, dynamic> body = {"teacherId": teacherId};

      // Make a POST request to fetch questions
      var response = await networkingHelper.postData(body);

      if (response != null && response['questions'] != null) {
        // Parse the questions from the response
        List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(
          response['questions'].map((question) => {
                "questionId": question['_id'],
                "questionText": question['question'],
                "choices": question['choices'],
                "correctAnswer": question['correctAnswer'],
                "questionRat": question['questionRat'],
                "closeQuiz": question['closeQuiz'],
              }),
        );
        return questions;
      } else {
        print("No questions found or invalid response format.");
        return [];
      }
    } catch (e) {
      print("Error fetching questions: ${e.toString()}");
      return [];
    }
  }

  Future<bool> insertTestResult({
    required String studentId,
    required String teacherId,
    required List<Map<String, dynamic>> questions,
    required int totalScore,
  }) async {
    try {
      // Debugging: Log the `questions` array
      print("Preparing to send test result...");
      print("Questions: $questions");
      for (var question in questions) {
        if (question['questionId'] == null || question['answer'] == null) {
          print("Error: Missing required fields in question: $question");
          return false;
        }
      }
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/test_results/addTestResult");
      Map<String, dynamic> body = {
        "studentId": studentId,
        "teacherId": teacherId,
        "questions": questions,
        "totalScore": totalScore,
      };
      var response = await networkingHelper.postData(body);
      if (response != null &&
          response['message'] == 'Test result added successfully') {
        print("Test result inserted successfully.");
        return true;
      } else {
        print("Failed to insert test result. Response: ${response.toString()}");
        return false;
      }
    } catch (e) {
      print("Error inserting test result: ${e.toString()}");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchTestResultsByTeacherId({
    required String teacherId,
  }) async {
    try {
      NetworkingHelper networkingHelper = NetworkingHelper(
        "$apiUrl/test_results/getTestResultsByTeacherId",
      );
      Map<String, dynamic> body = {
        "teacherId": teacherId,
      };
      var response = await networkingHelper.postData(body);
      if (response != null &&
          response['message'] == 'Test results fetched successfully' &&
          response['testResults'] != null) {
        print("Test results fetched successfully.");
        print("Test results fetched successfully. ${response['testResult']}");
        return List<Map<String, dynamic>>.from(response['testResults']);
      } else {
        print("Failed to fetch test results. Response: ${response.toString()}");
        return null;
      }
    } catch (e) {
      print("Error fetching test results: ${e.toString()}");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchTestResultsForEachStudent({
    required String studentId,
    required String teacherId,
  }) async {
    try {
      List<Map<String, dynamic>>? allTestResults =
          await fetchTestResultsByTeacherId(teacherId: teacherId);
      if (allTestResults == null || allTestResults.isEmpty) {
        print("No test results found for teacherId: $teacherId");
        return null;
      }
      List<Map<String, dynamic>> filteredResults = allTestResults
          .where((testResult) => testResult['studentId'] == studentId)
          .toList();

      if (filteredResults.isNotEmpty) {
        print("Filtered test results for studentId: $studentId");
        print("list is ${filteredResults}");
      } else {
        print("No test results found for studentId: $studentId");
      }
      return filteredResults;
    } catch (e) {
      print("Error filtering test results: ${e.toString()}");
      return null;
    }
  }

  Future<String> getQuestionTextById(String questionId) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/getQuestionsById");
      Map<String, dynamic> body = {
        "questionId": questionId,
      };
      var response = await networkingHelper.postData(body);
      print("response is :${response}");
      return response['question'];
    } catch (e) {
      print("Some Error");
      return "not return any thing";
    }
  }

  Future<void> updateQuestionsWhenCloseQuiz(
      String teacherId, List<Map<dynamic, dynamic>> updatedQuestions) async {
    try {
      NetworkingHelper networkingHelper =
          NetworkingHelper("$apiUrl/questions/closeQuiz");
      Map<String, dynamic> body = {
        "teacherId": teacherId,
        "questions": updatedQuestions,
      };

      final response = await networkingHelper.postData(body);

      if (response != null && response['message'] != null) {
        Fluttertoast.showToast(
          msg: "Quiz Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        if (response.containsKey('updatedQuestions')) {
          List<Map<String, dynamic>> updatedList =
              List<Map<String, dynamic>>.from(response['updatedQuestions']);
          print("Updated Questions: $updatedList");
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update questions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error updating questions: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "Error updating questions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
