import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../route/route.dart';
import '../services/pref.dart';

class ShowStudentsDetails extends StatefulWidget {
  const ShowStudentsDetails({super.key});

  @override
  State<ShowStudentsDetails> createState() => _ShowStudentsDetailsState();
}

class _ShowStudentsDetailsState extends State<ShowStudentsDetails> {
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> studentsTestResult = [];
  bool isLoading = true;
  String studentId = '';
  String totalScore = 'N/A';
  String answer = 'N/A';
  String isCorrect = 'N/A';
  String rating = 'N/A';
  String questionText = 'N/A';
  Routing routing = Routing();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      String teacherId = await getUserIdFromPref();
      if (teacherId.isNotEmpty) {
        List<Map<String, dynamic>> fetchedStudents =
            await routing.getStudentsByTeacherId(teacherId);
        setState(() {
          students = fetchedStudents;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "No teacher ID found in shared preferences.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error fetching students: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> handleStudentSelection(String studentId) async {
    try {
      String teacherId = await getUserIdFromPref();
      print(
          "Fetching test results for studentId: $studentId and teacherId: $teacherId");

      List<Map<String, dynamic>>? list =
          await routing.fetchTestResultsForEachStudent(
        studentId: studentId,
        teacherId: teacherId,
      );
      print("Fetched test results: $list");

      // Prepare the values for updating state
      List<Map<String, dynamic>> fetchedTestResults = list ?? [];
      String fetchedTotalScore = fetchedTestResults.isNotEmpty
          ? fetchedTestResults[0]['totalScore']?.toString() ?? 'N/A'
          : "He did not take the exam.";

      String fetchedQuestionText = 'N/A';
      String fetchedAnswer = 'N/A';
      String fetchedIsCorrect = 'N/A';
      String fetchedRating = 'N/A';

      if (fetchedTestResults.isNotEmpty &&
          fetchedTestResults[0]['questions'] != null &&
          fetchedTestResults[0]['questions'] is List &&
          fetchedTestResults[0]['questions'].isNotEmpty) {
        Map<String, dynamic> firstQuestion =
            fetchedTestResults[0]['questions'][0];
        fetchedQuestionText = await routing
            .getQuestionTextById(firstQuestion['questionId'].toString());
        print("fetch is ${fetchedQuestionText}");
        fetchedAnswer = firstQuestion['answer']?.toString() ?? 'No Answer';
        fetchedIsCorrect =
            firstQuestion['isCorrect']?.toString() ?? 'No correctness';
        fetchedRating = firstQuestion['rating']?.toString() ?? 'No rating';
      }

      // Update state
      setState(() {
        studentsTestResult = fetchedTestResults;
        totalScore = fetchedTotalScore;
        questionText = fetchedQuestionText;
        answer = fetchedAnswer;
        isCorrect = fetchedIsCorrect;
        rating = fetchedRating;
      });
    } catch (e) {
      print("error : ${e.toString()}");
      Fluttertoast.showToast(
        msg: "Error fetching test results: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<String> getSubmittedQuestionsText(String questionId) async {
    print("Fetching question text for questionId: $questionId");
    String fetchedQuestionText = await routing.getQuestionTextById(questionId);
    print("Fetched question text: $fetchedQuestionText");
    return fetchedQuestionText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2980B9),
        title: const Text("Students Details"),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(
                  child: Text(
                    "No students found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          studentId = student['_id'];
                        });
                        await handleStudentSelection(studentId);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                          ),
                          builder: (context) => SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: _buildBottomSheet(student),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              student['name'][0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            student['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            student['email'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildBottomSheet(Map<String, dynamic> student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2980B9), Color(0xFF6DD5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Student Details',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person,
              label: 'Name',
              value: student['name'],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: student['email'],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.star,
              label: 'Total Score',
              value: totalScore,
            ),
            const SizedBox(height: 16),
            Text(
              'Questions',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...studentsTestResult.isNotEmpty &&
                    studentsTestResult[0]['questions'] != null
                ? (studentsTestResult[0]['questions'] as List).isNotEmpty
                    ? studentsTestResult[0]['questions']
                        .map<Widget>((question) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                icon: Icons.text_format_sharp,
                                label: 'Question',
                                value: questionText,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                icon: Icons.question_answer,
                                label: 'Answer',
                                value:
                                    question['answer'] ?? 'No answer provided',
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                icon: Icons.check_circle_outline,
                                label: 'Is Correct',
                                value: question['isCorrect'].toString(),
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                icon: Icons.star_rate,
                                label: 'Rating',
                                value: question['rating'].toString(),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    : [
                        const Center(
                          child: Text(
                            'No questions available.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        )
                      ]
                : [
                    const Center(
                      child: Text(
                        'No data available.',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )
                  ],
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                maxLines: 10, // Adjust as necessary
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
