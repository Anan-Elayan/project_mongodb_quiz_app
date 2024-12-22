import 'package:app/route/route.dart';
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Quiz {
  List<Map<String, dynamic>> _questionBank = [];
  int _currentQuestionIndex = 0;
  bool isLoading = false;
  String errorMessage = '';
  int? totalRating;
  int? totalQuestions;

  List<Map<String, dynamic>> get questionBank => _questionBank;
  int get currentQuestionIndex => _currentQuestionIndex;

  void updateQuestionBank(
    int index,
    String selectedChoiceText,
    bool isCorrect,
  ) {
    if (index < _questionBank.length) {
      _questionBank[index]["selectedChoiceText"] = selectedChoiceText;
      _questionBank[index]["isCorrect"] = isCorrect;
    }
  }

  Future<void> loadQuestions(String teacherId) async {
    Routing routing = Routing();
    try {
      List<Map<String, dynamic>> questions = await routing.fetchQuestions(
        teacherId,
      );

      if (questions.isNotEmpty) {
        _questionBank = questions;
      } else {
        Fluttertoast.showToast(
          msg: "No questions found for teacher",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error loading questions:",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

  Future<bool> submitTestResult({
    required String studentId,
    required String teacherId,
    required int mark,
  }) async {
    Routing routing = Routing();
    List<Map<String, dynamic>> questions = _questionBank.map((question) {
      return {
        "questionId": question["questionId"],
        "answer": question["selectedChoiceText"] ?? '',
        "isCorrect": question["isCorrect"] ?? false,
        "rating": question["questionRat"],
      };
    }).toList();
    return await routing.insertTestResult(
      studentId: studentId,
      teacherId: teacherId,
      questions: questions,
      totalScore: mark,
    );
  }

  Future<int?> getTotalQuestionsCount() async {
    totalQuestions = 0;
    Routing routing = Routing();
    String teacherId = await getTeacherIdWhenUserLoginFromPref();
    totalQuestions = await routing.getTotalQuestionCount(teacherId);
    print("total questionCount is ${totalQuestions}");
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
