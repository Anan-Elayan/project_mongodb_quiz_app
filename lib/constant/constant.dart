import 'package:app/services/pref.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

const String apiUrl = 'http://192.168.88.3:3000';

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
            onPressed: () async {
              try {
                // Remove stored user data
                await removeUserId();
                await removeTeacherIdWhenUserLogin();

                // Navigate to SplashScreen
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                print("Error during logout: $e");
              }
            },
          ),
        ],
      );
    },
  );
}
