import 'dart:convert';

import 'package:app/constant/constant.dart';
import 'package:http/http.dart' as http;

class QuizBrain {
  List<Map<String, dynamic>> _questionBank = [];
  int _currentQuestionIndex = 0;
  bool isLoading = false;
  String errorMessage = '';

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
