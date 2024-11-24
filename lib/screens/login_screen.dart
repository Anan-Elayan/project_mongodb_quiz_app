import 'package:app/screens/admin_panel.dart'; // Import Admin Panel screen
import 'package:app/screens/quiz_page.dart'; // Import Quiz page screen
import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';
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
        String registerAs = response['user']['registerAs'];
        if (registerAs == "User") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(),
            ),
          );
        } else if (registerAs == "Admin") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPanel(),
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
        // If the checkbox is not checked, clear saved data
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
    print("-------${getUserIdFromPref().toString()}");
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
          saveData = true; // Set the checkbox as checked if login data exists
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String emailLabel = S.of(context).email;
    String passwordLabel = S.of(context).password;
    String loginLabel = S.of(context).login;

    return Scaffold(
      appBar: AppBar(
        title: Text(loginLabel),
        backgroundColor: const Color(0xFF00B4DB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutofillGroup(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: emailLabel,
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.email
                    ], // Specify email autofill
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: passwordLabel,
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                    ),
                    autofillHints: const [
                      AutofillHints.password
                    ], // Specify password autofill
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Checkbox(
                        value: saveData,
                        onChanged: (value) {
                          setState(() {
                            saveData = value!;
                          });
                          // Save the checkbox state when changed
                          saveRememberMe(saveData);
                        },
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4DB),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 50,
                ),
              ),
              child: Text(
                loginLabel,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
