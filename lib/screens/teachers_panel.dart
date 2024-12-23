import 'package:app/screens/settings_screen.dart';
import 'package:app/screens/show_students_details.dart';
import 'package:app/screens/teacher_questions_details.dart';
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../route/route.dart';
import 'add_question_page.dart';

class TeacherPanel extends StatefulWidget {
  @override
  _TeacherPanelState createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  int totalStudents = 0;
  int totalQuestions = 0;
  Routing routing = Routing();
  bool isQuizClosed = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchAnalyticsData();
      getTotalQuestionsCount();
      checkQuizStatus();
    });
  }

  Future<void> toggleQuizStatus() async {
    try {
      String id = await getUserIdFromPref();
      List fetchedQuestions = await routing.getQuestionByTeacherId(id);

      // Check if all `closeQuiz` are false
      bool allCloseQuizFalse =
          fetchedQuestions.every((q) => q['closeQuiz'] == false);

      // Update the local state optimistically
      setState(() {
        isQuizClosed = !allCloseQuizFalse; // Toggle the button state
      });

      // Update the `closeQuiz` value based on the current state
      List<Map> updatedQuestions = fetchedQuestions.map((q) {
        return {
          ...q,
          'closeQuiz': allCloseQuizFalse ? true : false, // Toggle closeQuiz
        };
      }).toList();
      setState(() {});

      // Send the updated questions to the backend
      await routing.updateQuestionsWhenCloseQuiz(id, updatedQuestions);
      setState(() {});

      print("Updated Questions: $updatedQuestions");
    } catch (e) {
      print("Error toggling quiz status: $e");

      // Revert the state in case of an error
      setState(() {
        isQuizClosed = !isQuizClosed; // Revert to the previous state
      });
    }
  }

  Future<void> checkQuizStatus() async {
    String id = await getUserIdFromPref();
    List fetchedQuestions = await routing.getQuestionByTeacherId(id);

    // Determine the initial state based on the fetched questions
    bool allCloseQuizFalse =
        fetchedQuestions.every((q) => q['closeQuiz'] == false);

    setState(() {
      isQuizClosed = !allCloseQuizFalse; // If all are false, quiz is open
    });
  }

  Future<void> getTotalQuestionsCount() async {
    String id = await getUserIdFromPref();
    print('id is ${id}');
    int count = await routing.getNumberOfQuestionByTeacher(id);
    setState(() {
      totalQuestions = count;
    });
  }

  void fetchAnalyticsData() {
    getUserIdFromPref().then((userId) {
      if (userId.isEmpty) {
        print("No user ID found. Cannot fetch analytics.");
        return;
      }
      routing.getAnalytics(userId).then((data) {
        if (data != null) {
          setState(() {
            totalStudents = data['totalStudents'] ?? 0;
          });
        } else {
          print("Failed to fetch analytics.");
        }
      }).catchError((e) {
        print("Error fetching analytics: $e");
      });
    }).catchError((e) {
      print("Error fetching user ID from preferences: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Teacher Panel",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2980B9),
        elevation: 5,
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
              color: Colors.white,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            showLogoutConfirmationDialog(context);
          },
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
        child: totalStudents == ''
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Analytics Overview',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2980B9),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShowStudentsDetails(),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Students',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "$totalStudents",
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TeacherQuestionDetails()),
                          );

                          if (result == true) {
                            getTotalQuestionsCount();
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.question_answer_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'My Questions',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "$totalQuestions",
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, size: 24),
                          label: const Text(
                            'Add Question',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 6,
                            backgroundColor: const Color(0xFF2980B9),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddQuestionScreen()),
                            );
                            if (result == true) {
                              getTotalQuestionsCount();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton.icon(
                          icon: isQuizClosed
                              ? Icon(Icons.lock_open_outlined, size: 24)
                              : Icon(Icons.close, size: 24),
                          label: Text(
                            isQuizClosed ? 'Open Quiz' : 'Close Quiz',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 6,
                            backgroundColor: const Color(0xFF2980B9),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: toggleQuizStatus,
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
