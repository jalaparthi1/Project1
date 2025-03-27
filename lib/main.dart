import 'package:flutter/material.dart';
import 'login_screen.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
    );
  }
}
