import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
<<<<<<< HEAD
import 'account_setup_screen.dart';
import 'budget_savings_screen.dart'; // Correct import for BudgetSavingsScreen
import 'financial_statement_screen.dart';
import 'profile_settings_screen.dart'; // Correct import for ProfileSettingsScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial App',
=======
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
>>>>>>> e277d944428263e36ffbfad8afa4172afa8f9c4e
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
<<<<<<< HEAD
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/account_setup': (context) => AccountSetupScreen(),
        '/budget': (context) =>
            BudgetScreen(), // Correct route for BudgetSavingsScreen
        '/financial_statement': (context) => FinancialStatementScreen(),
        '/profile_setting': (context) =>
            ProfileScreen(), // Correct route for ProfileSettingsScreen
      },
=======
      home: loggedIn ? HomeScreen() : LoginScreen(),
>>>>>>> e277d944428263e36ffbfad8afa4172afa8f9c4e
    );
  }
}
