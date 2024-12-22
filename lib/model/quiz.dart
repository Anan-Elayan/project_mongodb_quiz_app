import 'package:app/route/route.dart';
import 'package:app/services/pref.dart';

class Quiz {
  List<Map<String, dynamic>> _questionBank = [];
  int _currentQuestionIndex = 0;
  bool isLoading = false;
  String errorMessage = '';
  int? totalRating;
  int? totalQuestions;

  Future<void> loadQuestions(String teacherId) async {
    Routing routing = Routing();
    try {
      List<Map<String, dynamic>> questions =
          await routing.fetchQuestions(teacherId);

      if (questions.isNotEmpty) {
        _questionBank = questions; // Populate the question bank
        print("Questions fetched successfully:");
        for (var question in questions) {
          print("Question: ${question['questionText']}");
        }
      } else {
        print("No questions found for teacher ID: $teacherId");
      }
    } catch (e) {
      print("Error loading questions: ${e.toString()}");
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
