import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class AccountSetupScreen extends StatefulWidget {
  @override
  AccountSetupScreenState createState() => AccountSetupScreenState();
}

class AccountSetupScreenState extends State<AccountSetupScreen> {
  final TextEditingController firstAndLastName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> savedDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('First and Last Name', firstAndLastName.text);
    await prefs.setString('username', username.text);
    await prefs.setString('password', password.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account Made')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Your Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstAndLastName,
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(), alignLabelWithHint: true,),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: username,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder(), alignLabelWithHint: true,),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), alignLabelWithHint: true,),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: savedDetails, 
              child: const Text('Enter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Login Now'),
            ),
          ],
        ),
      ),
    );
  }
}
