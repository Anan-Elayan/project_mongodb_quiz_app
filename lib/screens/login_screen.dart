import 'package:app/screens/quiz_page.dart'; // Import Quiz page screen
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
  bool saveData = false;

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in both email and password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    Routing routing = Routing();
    var response = await routing.login(email, password);

    if (response != null) {
      Fluttertoast.showToast(
        msg: response['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (response['message'] == "Login successful") {
        print(response);
        String registerAs = response['user']['role'];
        if (registerAs == "student") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(),
            ),
          );
        } else if (registerAs == "teacher") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherPanel(),
            ),
          );
        }
      }
      if (saveData) {
        String userId = await routing.getUserId(
            emailController.text, passwordController.text);
        if (userId != 0) {
          saveUserId(userId);
        } else {
          print(userId);
        }

        isLogin(true);
        saveEmail(emailController.text);
        savePassword(passwordController.text);
      } else {
        isLogin(false);
        saveEmail('');
        savePassword('');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLoginInfo();
    print("-------\${getUserIdFromPref().toString()}");
  }

  Future<void> _loadSavedLoginInfo() async {
    bool? isLoggedIn = await getLoginStatus();
    if (isLoggedIn == true) {
      String? savedEmail = await getEmail();
      String? savedPassword = await getPassword();

      if (savedEmail != null && savedPassword != null) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        setState(() {
          saveData = true;
        });
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
        centerTitle: true,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.login,
                    size: 80,
                    color: Color(0xFF2980B9),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email, color: Color(0xFF2980B9)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF2980B9)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: saveData,
                        onChanged: (value) {
                          setState(() {
                            saveData = value!;
                          });
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
    );
  }
}
