import 'package:app/screens/login_screen.dart';
import 'package:app/screens/register_screen.dart';
import 'package:flutter/material.dart';

const String url = 'http://10.0.2.2:3000';

class SplashScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  final Locale locale; // Receive the current locale
  const SplashScreen(
      {super.key, required this.setLocale, required this.locale});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Locale _selectedLocale = const Locale('en'); // Default locale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)], // Blue gradient
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<Locale>(
                  value: const Locale('en'),
                  groupValue: _selectedLocale,
                  onChanged: (Locale? value) {
                    setState(() {
                      _selectedLocale = value!;
                    });
                    widget.setLocale(
                        _selectedLocale); // Update locale immediately
                  },
                  activeColor: Colors.white, // Set selected color to white
                ),
                const Text('English', style: TextStyle(color: Colors.white)),
                Radio<Locale>(
                  value: const Locale('ar'),
                  groupValue: _selectedLocale,
                  onChanged: (Locale? value) {
                    setState(() {
                      _selectedLocale = value!;
                    });
                    widget.setLocale(
                        _selectedLocale); // Update locale immediately
                  },
                  activeColor: Colors.white, // Set selected color to white
                ),
                const Text('العربية', style: TextStyle(color: Colors.white)),
              ],
            ),

            const SizedBox(height: 40),

            // Login Button
            ElevatedButton(
              onPressed: () {
                widget.setLocale(_selectedLocale); // Set selected locale
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      setLocale: widget.setLocale,
                      locale: _selectedLocale, // Pass the selected locale
                    ),
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
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Color(0xFF0083B0),
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Register Button
            OutlinedButton(
              onPressed: () {
                widget.setLocale(_selectedLocale); // Set selected locale
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterScreen(
                            setLocale: widget.setLocale,
                            locale: _selectedLocale, // Use selected locale here
                          )),
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
              child: const Text(
                "Register",
                style: TextStyle(
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
