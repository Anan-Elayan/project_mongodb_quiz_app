import 'dart:convert';

import 'package:app/constant/constant.dart';
import 'package:app/route/route.dart';
import 'package:http/http.dart' as http;

class QuizBrain {
  List<Map<String, dynamic>> _questionBank = [];
  int _currentQuestionIndex = 0;
  bool isLoading = false;
  String errorMessage = '';
  int? totalRating;
  int? totalQuestions;

  Future<void> fetchQuestions() async {
    try {
      isLoading = true;
      var url = Uri.parse("$apiUrl/questions/get");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _questionBank = data.map((question) {
          return {
            "questionText": question['question'],
            "choices": question['choices'],
            "correctAnswer": question['correctAnswer'],
            "questionRat": question['questionRat'],
          };
        }).toList();
        isLoading = false;
      } else {
        throw Exception("Failed to load questions");
      }
    } catch (e) {
      isLoading = false;
      errorMessage = "Error fetching questions: $e";
      print(errorMessage);
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
    totalQuestions = await routing.getTotalQuestionCount();
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
