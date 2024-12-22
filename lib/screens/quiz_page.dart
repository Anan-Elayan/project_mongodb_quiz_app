import 'package:app/model/quiz.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constant/constant.dart';
import '../services/pref.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Quiz quiz = Quiz();
  List<Icon> scoreKeeper = [];
  bool isLoading = true;
  int? selectedChoice;
  int mark = 0;
  int totalQuestionsCount = 0;
  int numberQuestion = 1;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    loadQuestionsCount();
    ();
    print(quiz.getQuestionRating());
  }

  Future<void> loadQuestions() async {
    setState(() => isLoading = true); // Set loading state to true
    String teacherId =
        await getTeacherIdWhenUserLoginFromPref(); // Get teacher ID
    await quiz.loadQuestions(teacherId); // Wait for questions to load
    print("Questions loaded for teacher ID: $teacherId"); // Debug log
    setState(() => isLoading = false); // Set loading state to false
  }

  Future<void> loadQuestionsCount() async {
    setState(() => isLoading = true); // Set loading state to true
    int? count =
        await quiz.getTotalQuestionsCount(); // Fetch total questions count
    setState(() {
      totalQuestionsCount = count ?? 0; // Update state variable
      isLoading = false; // Set loading state to false
    });
  }

  void checkAnswer() {
    String correctAnswer = quiz.getCorrectAnswer();
    String selectedChoiceText = quiz.getChoices()[selectedChoice ?? -1];

    setState(() {
      if (quiz.isFinished()) {
        if (selectedChoiceText == correctAnswer) {
          scoreKeeper.add(
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
          mark += quiz.getQuestionRating();
        } else {
          scoreKeeper.add(
            const Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        Alert(
          style: AlertStyle(),
          closeFunction: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          context: context,
          title: 'Finish',
          desc:
              '${"You have reached the end of the quiz."}\nTotal marks: ${mark} / ${quiz.getTotalRating()}',
        ).show();
        quiz.reset();
        scoreKeeper.clear();
        mark = 0;
        numberQuestion = 1;
      } else {
        if (selectedChoiceText == correctAnswer) {
          scoreKeeper.add(
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
          mark += quiz.getQuestionRating();
        } else {
          scoreKeeper.add(
            const Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        quiz.nextQuestion();
        numberQuestion++;
        selectedChoice = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          onPressed: () {
            showLogoutConfirmationDialog(context);
          },
        ),
        backgroundColor: Colors.black12.withOpacity(0.1),
        title: const Text(
          'Quiz App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade900,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "النقاط $mark/${quiz.getTotalRating()!}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "السؤال $numberQuestion من $totalQuestionsCount",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            quiz.getQuestionText(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two choices per row
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 3,
                      ),
                      itemCount: quiz.getChoices().length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedChoice = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedChoice == index
                                  ? Colors.blue.shade600
                                  : Colors.blue.shade300,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: selectedChoice == index
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: RadioListTile<int>(
                              title: Text(
                                quiz.getChoices()[index],
                                style: TextStyle(
                                  color: selectedChoice == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: index,
                              groupValue: selectedChoice,
                              onChanged: (value) {
                                setState(() {
                                  selectedChoice = value;
                                });
                              },
                              activeColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: selectedChoice != null ? checkAnswer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "Submit Answer",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: scoreKeeper),
              ],
            ),
    );
  }
}
