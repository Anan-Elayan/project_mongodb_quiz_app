import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../screens/splash_screen.dart';

const String apiUrl = 'http://192.168.88.5:3000';
//10.0.2.2
void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).areYouSure),
        actions: <Widget>[
          TextButton(
            child: Text(S.of(context).no),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(S.of(context).yes),
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
