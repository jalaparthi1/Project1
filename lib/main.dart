import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: AuthCheck(), // Load authentication check screen first
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool? loggedIn;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedUser = prefs.getString('username');
    final String? storedPass = prefs.getString('password');

    setState(() {
      loggedIn = (storedUser != null && storedPass != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return loggedIn! ? HomeScreen() : LoginScreen();
  }
}
