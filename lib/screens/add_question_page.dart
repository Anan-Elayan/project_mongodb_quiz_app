import 'package:app/route/route.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String questionText = "";
  String correctAnswer = "";
  List<String> choices = ["", "", "", ""];
  bool isLoading = false;
  TextEditingController ratingController = TextEditingController();
  List<TextEditingController> choiceControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < choiceControllers.length; i++) {
      choiceControllers[i].addListener(
        () {
          setState(
            () {
              choices[i] = choiceControllers[i].text;
            },
          );
        },
      );
    }
  }

  Future<void> submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(
        () {
          isLoading = true;
        },
      );

      if (correctAnswer.isEmpty || !choices.contains(correctAnswer)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select the correct answer."),
            backgroundColor: Colors.red,
          ),
        );
        setState(
          () {
            isLoading = false;
          },
        );
        return;
      }

      Routing routing = Routing();
      var response = await routing.addQuestion(questionText, choices,
          correctAnswer, int.parse(ratingController.text));

      setState(() {
        isLoading = false;
      });

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Question added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to add question."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).addQuestion,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).enterTheQuestion,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: S.of(context).yourQuestion,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a question" : null,
                  onSaved: (value) => questionText = value!,
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).enterTheQuestion,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (int i = 0; i < 4; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: choiceControllers[i],
                      decoration: InputDecoration(
                        labelText: "${S.of(context).choices} ${i + 1}",
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Please enter choice ${i + 1}"
                          : null,
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).selectTheCorrectAnswer,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: choices[0],
                            groupValue: correctAnswer,
                            onChanged: (value) {
                              setState(() {
                                correctAnswer = value!;
                              });
                            },
                            title: Text(choices[0]),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RadioListTile<String>(
                            value: choices[1],
                            groupValue: correctAnswer,
                            onChanged: (value) {
                              setState(() {
                                correctAnswer = value!;
                              });
                            },
                            title: Text(choices[1]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: choices[2],
                            groupValue: correctAnswer,
                            onChanged: (value) {
                              setState(() {
                                correctAnswer = value!;
                              });
                            },
                            title: Text(choices[2]),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RadioListTile<String>(
                            value: choices[3],
                            groupValue: correctAnswer,
                            onChanged: (value) {
                              setState(() {
                                correctAnswer = value!;
                              });
                            },
                            title: Text(
                              choices[3],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).selectTheQuestionRating,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: ratingController,
                  decoration: const InputDecoration(
                    labelText: "Question Rating",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the question rating";
                    }
                    if (int.tryParse(value) == null ||
                        int.parse(value) < 1 ||
                        int.parse(value) > 5) {
                      return "Please enter a valid rating between 1 and 5";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ratingController.text = value!;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: submitQuestion,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 40,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                          child: const Text("Submit"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
