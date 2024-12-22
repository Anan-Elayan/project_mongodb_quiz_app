import 'dart:convert';

import 'package:app/constant/constant.dart';
import 'package:app/route/route.dart';
import 'package:app/services/pref.dart';
import 'package:http/http.dart' as http;

class QuizBrain {
  List<Map<String, dynamic>> _questionBank = [];
  int _currentQuestionIndex = 0;
  bool isLoading = false;
  String errorMessage = '';
  int? totalRating;
  int? totalQuestions;

  Future<void> fetchQuestions(String teacherId) async {
    try {
      isLoading = true;

      var url = Uri.parse("$apiUrl/questions/getQuestions");
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"teacherId": teacherId}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['questions'] != null) {
          _questionBank = (responseData['questions'] as List).map((question) {
            return {
              "questionText": question['question'],
              "choices": question['choices'],
              "correctAnswer": question['correctAnswer'],
              "questionRat": question['questionRat'],
            };
          }).toList();
        } else {
          _questionBank = [];
          errorMessage = "No questions found for the specified teacher.";
        }
      } else {
        throw Exception("Failed to load questions: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage = "Error fetching questions: $e";
      print(errorMessage);
    } finally {
      isLoading = false;
    }
  }

  String getQuestionText() {
    return _questionBank.isNotEmpty
        ? _questionBank[_currentQuestionIndex]["questionText"]
        : '';
  }

  int? getTotalRating() {
    totalRating = 0;
    for (int i = 0; i < _questionBank.length; i++) {
      if (_questionBank[i]['questionRat'] != null) {
        totalRating = (totalRating! + _questionBank[i]['questionRat']) as int?;
      }
    }
    return totalRating;
  }

  Future<int?> getTotalQuestionsCount() async {
    totalQuestions = 0;
    Routing routing = Routing();
    String teacherId = await getTeacherIdWhenUserLoginFromPref();
    totalQuestions = await routing.getTotalQuestionCount(teacherId);
    print("total rating is ${totalQuestions}");
    return totalQuestions;
  }

  int getQuestionRating() {
    return _questionBank.isNotEmpty &&
            _questionBank[_currentQuestionIndex]["questionRat"] != null
        ? _questionBank[_currentQuestionIndex]["questionRat"]
        : 0;
  }

  List<String> getChoices() {
    return _questionBank.isNotEmpty
        ? List<String>.from(_questionBank[_currentQuestionIndex]["choices"])
        : [];
  }

  String getCorrectAnswer() {
    return _questionBank.isNotEmpty
        ? _questionBank[_currentQuestionIndex]["correctAnswer"]
        : '';
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questionBank.length - 1) {
      _currentQuestionIndex++;
    }
  }

  bool isFinished() {
    return _currentQuestionIndex >= _questionBank.length - 1;
  }

  void reset() {
    _currentQuestionIndex = 0;
  }
}
