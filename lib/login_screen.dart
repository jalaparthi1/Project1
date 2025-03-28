import 'package:flutter/material.dart';
import 'package:project_1/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    savedLoginDetails();
  }

  Future<void> savedLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username.text = prefs.getString('username') ?? '';
      password.text = prefs.getString('password') ?? '';
    });
  }

  Future<void> authorization() async {
    final prefs = await SharedPreferences.getInstance();
    String storedUser = prefs.getString('username') ?? '';
    String storedPass = prefs.getString('password') ?? '';

    if (username.text == storedUser && password.text == storedPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect Username of Password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: username,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: authorization,
                child: const Text("Enter"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSetupScreen()),
                  );
                },
                child: const Text("Make Account"),
              )
            ],
          ),
        ));
  }
}
