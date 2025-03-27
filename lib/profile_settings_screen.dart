import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('darkMode', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile & Settings")),
      body: Column(
        children: [
          ListTile(
            title: Text("Username: John Doe"),
            subtitle: Text("Email: johndoe@example.com"),
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (value) => _toggleTheme(),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Change Password"),
          ),
        ],
      ),
    );
  }
}
