import 'package:app/screens/admin_panel.dart'; // Import Admin Panel screen
import 'package:app/screens/quiz_page.dart'; // Import Quiz page screen
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';
import '../route/route.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  final Locale locale;

  const LoginScreen({super.key, required this.setLocale, required this.locale});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              builder: (context) => QuizPage(
                setLocale: widget.setLocale,
                locale: widget.locale,
              ),
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
                ],
              ),
            ),
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
