import 'package:app/route/route.dart';
import 'package:app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';

class RegisterScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  final Locale locale;
  const RegisterScreen(
      {super.key, required this.setLocale, required this.locale});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _userRole = 'User';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String registerAs = _userRole!.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        registerAs.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
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
    var response = await routing.register(
      name,
      email,
      password,
      registerAs,
    );
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
    }
    if (response != null &&
        response['message'] == "User created successfully") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            setLocale: widget.setLocale,
            locale: widget.locale,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String nameLabel = S.of(context).name;
    String emailLabel = S.of(context).email;
    String passwordLabel = S.of(context).password;
    String registerAsLabel = S.of(context).registerAs;
    String adminLabel = S.of(context).admin;
    String userLabel = S.of(context).user;
    String registerButtonLabel = S.of(context).register;

    return Scaffold(
      appBar: AppBar(
        title: Text(registerButtonLabel),
        backgroundColor: const Color(0xFF0083B0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: nameLabel,
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
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
              ),
              const SizedBox(height: 30),
              Text(
                registerAsLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              RadioListTile<String>(
                title: Text(
                  adminLabel,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: 'Admin',
                groupValue: _userRole,
                onChanged: (value) {
                  setState(() {
                    _userRole = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  userLabel,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: 'User',
                groupValue: _userRole,
                onChanged: (value) {
                  setState(() {
                    _userRole = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0083B0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                ),
                child: Text(
                  registerButtonLabel,
                  style: const TextStyle(
                    fontSize: 18,
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
