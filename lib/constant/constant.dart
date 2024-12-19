import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

const String apiUrl = 'http://192.168.88.7:3000';
//10.0.2.2
void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Are you sure to exit ?"),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}
