import 'package:app/route/route.dart';
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherQuestionDetails extends StatefulWidget {
  const TeacherQuestionDetails({super.key});

  @override
  State<TeacherQuestionDetails> createState() => _TeacherQuestionDetailsState();
}

class _TeacherQuestionDetailsState extends State<TeacherQuestionDetails> {
  List<dynamic> questions = [];
  Routing routing = Routing();
  String sortOrder = "asc";

  void deleteQuestion(String questionId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this question?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              }, // Confirm
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final deleteSuccess = await routing.deleteQuestion(questionId);
        if (deleteSuccess) {
          setState(() {
            questions.removeWhere((q) => q['_id'] == questionId);
          });
        } else {
          Fluttertoast.showToast(
            msg: "Failed to delete the question.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error deleting question:",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void editQuestion(BuildContext context, dynamic question) {
    TextEditingController questionController =
        TextEditingController(text: question['question']);
    TextEditingController correctAnswerController =
        TextEditingController(text: question['correctAnswer']);
    TextEditingController choicesController =
        TextEditingController(text: question['choices'].join(", "));
    TextEditingController ratingController =
        TextEditingController(text: question['questionRat'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFEAF6FF),
          title: const Text(
            "Edit Question",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: "Question",
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: choicesController,
                  decoration: const InputDecoration(
                    labelText: "Choices (comma-separated)",
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: correctAnswerController,
                  decoration: const InputDecoration(
                    labelText: "Correct Answer",
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: ratingController,
                  decoration: const InputDecoration(
                    labelText: "Answer Rating",
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newQuestion = questionController.text;
                List<String> newChoices = choicesController.text
                    .split(", ")
                    .map((e) => e.trim())
                    .toList();
                String newCorrectAnswer = correctAnswerController.text;
                int newRating = int.tryParse(ratingController.text) ?? 0;
                routing.updateQuestion(question['_id'], newQuestion, newChoices,
                    newCorrectAnswer, newRating);
                setState(() {
                  question['question'] = questionController.text;
                  question['choices'] = choicesController.text.split(", ");
                  question['correctAnswer'] = correctAnswerController.text;
                  question['questionRat'] = ratingController.text;
                });
                Navigator.pop(context);
                if (newQuestion.isEmpty ||
                    newChoices.length != 4 ||
                    newCorrectAnswer.isEmpty) {
                  Fluttertoast.showToast(
                    msg:
                        "Please provide all required fields with valid values.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                } else if (!newChoices.contains(newCorrectAnswer)) {
                  Fluttertoast.showToast(
                    msg: "The correct answer must be one of the choices.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> loadQuestions() async {
    try {
      final String id = await getUserIdFromPref();
      final fetchedQuestions =
          await routing.getQuestionByTeacherId(id, sortOrder);
      print("fetch questions :${fetchedQuestions}");
      setState(() {
        questions = fetchedQuestions;
      });
      return true;
    } catch (e) {
      print("Error loading questions: $e");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          "Teacher Questions Details",
          style: TextStyle(
            fontSize: 19,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FF), Color(0xFFB2E0F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sort Questions by Rating",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              sortOrder = "asc";
                              loadQuestions();
                            });
                          },
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "asc",
                                groupValue: sortOrder,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  setState(() {
                                    sortOrder = value!;
                                    loadQuestions();
                                  });
                                },
                              ),
                              const Text(
                                "Ascending",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              sortOrder = "desc";
                              loadQuestions();
                            });
                          },
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "desc",
                                groupValue: sortOrder,
                                activeColor: Colors.blueAccent,
                                onChanged: (value) {
                                  setState(() {
                                    sortOrder = value!;
                                    loadQuestions();
                                  });
                                },
                              ),
                              const Text(
                                "Descending",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: questions.isEmpty
                  ? const Center(
                      child: Text(
                      "No questions found",
                    ))
                  : ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEAF6FF), Color(0xFFB2E0F7)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Question: ${question['question']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.black),
                                        onPressed: () {
                                          editQuestion(context, question);
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.black),
                                  Text(
                                    "Choices: ${question['choices'].join(", ")}",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Correct Answer: ${question['correctAnswer']}",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Rating: ${question['questionRat']}",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          deleteQuestion(question['_id']);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
