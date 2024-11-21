import 'package:app/route/route.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String questionText = "";
  String correctAnswer = ""; // Correct answer field
  List<String> choices = ["", "", "", ""]; // List to hold the 4 choices
  bool isLoading = false;

  // Method to submit question to the backend
  Future<void> submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      // Ensure the correct answer is selected
      if (correctAnswer.isEmpty || !choices.contains(correctAnswer)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select the correct answer."),
          backgroundColor: Colors.red,
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }

      Routing routing = Routing();
      var response =
          await routing.addQuestion(questionText, choices, correctAnswer);

      setState(() {
        isLoading = false;
      });

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Question added successfully!"),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to add question."),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Add Question", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Section
              Text("Enter the Question:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Your question", border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a question" : null,
                onSaved: (value) => questionText = value!,
              ),
              const SizedBox(height: 20),

              // Answer Choices Section
              Text("Enter the answer choices:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Choice ${i + 1}",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter choice ${i + 1}" : null,
                    onSaved: (value) => choices[i] = value!,
                  ),
                ),
              const SizedBox(height: 20),

              // Correct Answer Dropdown Section
              Text("Select the correct answer:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: correctAnswer.isEmpty ? null : correctAnswer,
                hint: Text("Select correct answer"),
                items: choices.map((choice) {
                  return DropdownMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    correctAnswer = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Submit Button Section
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: submitQuestion,
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                          textStyle: TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
