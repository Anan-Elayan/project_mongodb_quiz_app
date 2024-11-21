import 'package:app/quiz_brain.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../generated/l10n.dart';

class QuizPage extends StatefulWidget {
  final Function(Locale) setLocale;
  final Locale locale;

  const QuizPage({Key? key, required this.setLocale, required this.locale})
      : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizBrain quizBrain = QuizBrain();
  List<Icon> scoreKeeper = [];
  bool isLoading = true;
  int? selectedChoice;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    await quizBrain.fetchQuestions();
    setState(() {
      isLoading = false;
    });
  }

  void checkAnswer() {
    String correctAnswer = quizBrain.getCorrectAnswer();
    String selectedChoiceText = quizBrain.getChoices()[selectedChoice ?? -1];

    setState(() {
      if (quizBrain.isFinished()) {
        Alert(
          context: context,
          title: S.of(context).finished_title,
          desc: S.of(context).finished_desc,
        ).show();

        quizBrain.reset();
        scoreKeeper.clear();
      } else {
        if (selectedChoiceText == correctAnswer) {
          scoreKeeper.add(
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
        } else {
          scoreKeeper.add(
            const Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        quizBrain.nextQuestion();
        selectedChoice = null; // Reset the radio button selection
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12.withOpacity(0.1),
        title: Text(
          S.of(context).appName,
          style: const TextStyle(
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        quizBrain.getQuestionText(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                      itemCount: quizBrain.getChoices().length,
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
                                quizBrain.getChoices()[index],
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
                      primary: Colors.blueAccent,
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
