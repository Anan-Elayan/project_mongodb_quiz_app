import 'package:app/screens/login_screen.dart';
import 'package:app/screens/register_screen.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_pin,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 40),

            // Language Selection Radio Buttons
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Radio<Locale>(
            //       value: const Locale('en'),
            //       groupValue: _selectedLocale,
            //       onChanged: (Locale? value) {
            //         setState(() {
            //           _selectedLocale = value!;
            //         });
            //         widget.setLocale(
            //             _selectedLocale); // Update locale immediately
            //       },
            //       activeColor: Colors.white, // Set selected color to white
            //     ),
            //     const Text('English', style: TextStyle(color: Colors.white)),
            //     Radio<Locale>(
            //       value: const Locale('ar'),
            //       groupValue: _selectedLocale,
            //       onChanged: (Locale? value) {
            //         setState(() {
            //           _selectedLocale = value!;
            //         });
            //         widget.setLocale(
            //             _selectedLocale); // Update locale immediately
            //       },
            //       activeColor: Colors.white, // Set selected color to white
            //     ),
            //     const Text('العربية', style: TextStyle(color: Colors.white)),
            //   ],
            // ),
            const Text(
              "Palestinians Questions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Cairo',
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                S.of(context).login,
                style: const TextStyle(
                  color: Color(0xFF0083B0),
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Register Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                side: const BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                S.of(context).register,
                style: const TextStyle(
                  color: Colors.white,
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
