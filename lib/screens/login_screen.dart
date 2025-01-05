import 'package:app/constant/custom_text_fields.dart';
import 'package:app/screens/quiz_page.dart';
import 'package:app/screens/teachers_panel.dart'; // Import Teacher Panel screen
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../route/route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool saveData = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      Routing routing = Routing();
      var response = await routing.login(email, password);
      if (response != null) {
        if (response['message'] == "Login successful") {
          Fluttertoast.showToast(
            msg: "${response['message']} 😊",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          String userId = response['user']['_id'];
          if (userId.isNotEmpty) {
            await saveUserId(userId);
            if (response['user']['role'] == 'student') {
              String teacherId = response['user']['teacher_id'];
              await saveTeacherIdWhenUserLogin(teacherId);
            }
            if (saveData) {
              await saveEmail(email);
              await savePassword(password);
              await isLogin(true);
            } else {
              await saveEmail('');
              await savePassword('');
              await isLogin(false);
            }
            if (response['user']['role'] == 'student') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QuizPage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TeacherPanel()),
              );
            }
          } else {
            print("Failed to retrieve userId.");
          }
        } else {
          Fluttertoast.showToast(
            msg: "${response['message']} 😒",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        print("some error");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please check the input data in field! ❌",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLoginInfo();
  }

  Future<void> _loadSavedLoginInfo() async {
    bool? isRemembered = await getRememberMe();
    if (isRemembered) {
      setState(() {
        saveData = true;
      });
      String? savedEmail = await getEmail();
      String? savedPassword = await getPassword();
      if (savedEmail != null && savedPassword != null) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
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
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FF), Color(0xFFB2E0F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                // Wrap the form with the Form widget
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.login,
                      size: 80,
                      color: Color(0xFF2980B9),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      txtLabel: "Email",
                      backgroundColor: Colors.white,
                      controller: emailController,
                      txtPrefixIcon: Icons.email,
                      prefixIconColor: const Color(0xFF2980B9),
                      isVisibleContent: false,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Email';
                        } else if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
                            .hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFields(
                      txtLabel: "Password",
                      backgroundColor: Colors.white,
                      controller: passwordController,
                      txtPrefixIcon: Icons.lock,
                      prefixIconColor: const Color(0xFF2980B9),
                      isVisibleContent: true,
                      suffixIconColor: const Color(0xFF2980B9),
                      txtSuffixIcon: Icons.insert_emoticon_rounded,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: saveData,
                          onChanged: (value) async {
                            setState(() {
                              saveData = value!;
                            });
                            await saveRememberMe(saveData);
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        backgroundColor: const Color(0xFF2980B9),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
