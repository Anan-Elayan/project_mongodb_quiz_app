import 'package:app/route/route.dart';
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  int totalQuestions = 0;

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
      setState(() {
        isLoading = true;
      });

      if (correctAnswer.isEmpty || !choices.contains(correctAnswer)) {
        Fluttertoast.showToast(
          msg: "Please select the correct answer.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      Routing routing = Routing();
      String id = await getUserIdFromPref();
      var response = await routing.addQuestion(
        questionText,
        choices,
        correctAnswer,
        int.parse(ratingController.text),
        id,
      );
      setState(() {
        isLoading = false;
      });
      if (response != null) {
        Fluttertoast.showToast(
          msg: "Question added successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(
          msg: "Failed to add question.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
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
        title: const Text(
          "Add Question",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FF), Color(0xFFB2E0F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Question",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Your question",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a question" : null,
                    onSaved: (value) => questionText = value!,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter Choices",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: choiceControllers[i],
                        decoration: InputDecoration(
                          labelText: "Choice ${i + 1}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) => value!.isEmpty
                            ? "Please enter choice ${i + 1}"
                            : null,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select the Correct Answer",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: choices.map((choice) {
                      return RadioListTile<String>(
                        value: choice,
                        groupValue: correctAnswer,
                        onChanged: (value) {
                          setState(() {
                            correctAnswer = value!;
                          });
                        },
                        title:
                            Text(choice.isNotEmpty ? choice : "Enter Choice"),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Question Rating (1 to 5)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ratingController,
                    decoration: InputDecoration(
                      labelText: "Rating",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                              backgroundColor: const Color(0xFF2980B9),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
