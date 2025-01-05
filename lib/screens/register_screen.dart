import 'dart:core';

import 'package:app/route/route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant/custom_text_fields.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _userRole = 'student';
  String? _selectedTeacher;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Routing route = Routing();
  List<Map<String, String>> _teachersList = [];
  bool _isLoadingTeachers = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    try {
      List<Map<String, String>> teachers = await route.getTeachersIdAndName();
      setState(() {
        _teachersList = teachers;
        _isLoadingTeachers = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTeachers = false;
      });
      Fluttertoast.showToast(
        msg: "Error fetching teachers: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String registerAs = _userRole!.trim();
      String? selectedTeacher = _selectedTeacher;

      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
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
      if (registerAs == "student" && selectedTeacher == null) {
        Fluttertoast.showToast(
          msg: "Please select a teacher",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
      try {
        Routing routing = Routing();
        Map<String, dynamic>? response = await routing.register(
          name,
          email,
          password,
          registerAs,
          selectedTeacher ?? "",
        );
        if (response == null) {
          Fluttertoast.showToast(
            msg: "Failed to register. Please try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        Fluttertoast.showToast(
          msg: response['message'] ?? "Unexpected response from server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:
              response['message'] == "User registered successfully!"
                  ? Colors.green
                  : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        if (response['message'] == "User registered successfully!") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
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
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FF), Color(0xFFB2E0F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.app_registration,
                  size: 80,
                  color: Color(0xFF2980B9),
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  txtLabel: "Name",
                  backgroundColor: Colors.white,
                  controller: _nameController,
                  txtPrefixIcon: Icons.person,
                  prefixIconColor: const Color(0xFF2980B9),
                  isVisibleContent: false,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFields(
                  txtLabel: "Email",
                  backgroundColor: Colors.white,
                  controller: _emailController,
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
                  controller: _passwordController,
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
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Register As",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildRadioButton("teacher", "teacher"),
                    ),
                    Expanded(
                      child: _buildRadioButton("student", "student"),
                    ),
                  ],
                ),
                if (_userRole == "student") ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    child: _isLoadingTeachers
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                            value: _selectedTeacher,
                            items: _teachersList.map((teacher) {
                              return DropdownMenuItem(
                                value: teacher['id'],
                                child: Text(teacher['name'] ?? ''),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTeacher = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Select Teacher",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(15),
                            ),
                          ),
                  ),
                ],
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
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
                    "Register",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyBoardType,
  }) {
    return Container(
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
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
          hintText: labelText,
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF2980B9)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String title, String value) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      value: value,
      groupValue: _userRole,
      onChanged: (selectedValue) {
        setState(() {
          _userRole = selectedValue;
          _selectedTeacher = null;
        });
      },
    );
  }
}
