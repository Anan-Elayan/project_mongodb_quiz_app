import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

const String apiUrl = 'http://192.168.88.7:3000';
//10.0.2.2

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure you want to exit?"),
        actions: <Widget>[
          TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              removeUserId().then((_) {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }).catchError((e) {
                print("Error during logout: $e");
              });
            },
          ),
        ],
      );
    },
  );
}
