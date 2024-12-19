import 'package:shared_preferences/shared_preferences.dart';

void saveEmail(String email) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString('email', email);
}

void savePassword(String password) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('password', password);
}

void isLogin(bool isLogin) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('isLogin', isLogin);
}

Future<String?> getEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email');
}

Future<String?> getPassword() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('password');
}

Future<bool?> getLoginStatus() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('isLogin');
}

void saveRememberMe(bool value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('rememberMe', value);
}

Future<bool> getRememberMe() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('rememberMe') ?? false;
}

Future<void> saveUserId(String value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString('userId', value);
}

Future<void> removeUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove('userId');
}

Future<String> getUserIdFromPref() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('userId') ?? '';
}
