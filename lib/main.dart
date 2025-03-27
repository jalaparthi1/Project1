import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? storedUser = prefs.getString('username');
  final String? storedPass = prefs.getString('password');
  runApp(MyApp(loggedIn: storedUser != null && storedPass != null));
}

class MyApp extends StatelessWidget {
  final bool loggedIn; 
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: loggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
