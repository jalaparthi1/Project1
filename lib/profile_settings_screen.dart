import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isEditingProfile = false; // Track if the profile is being edited

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  // Load saved profile data
  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      fullNameController.text = prefs.getString('fullName') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      mobileController.text = prefs.getString('mobile') ?? '';
    });
  }

  // Save updated profile data
  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('fullName', fullNameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('mobile', mobileController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Updated')),
    );

    // Reload profile data
    loadProfileData();
    setState(() {
      isEditingProfile = false; // Disable editing after saving
    });
  }

  // Change password verification
  void changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Current Password'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get saved password from SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                String savedPassword = prefs.getString('password') ?? '';

                // Verify the current password
                if (currentPasswordController.text == savedPassword) {
                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                    // Update password in SharedPreferences
                    await prefs.setString(
                        'password', newPasswordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password Changed Successfully')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('New passwords do not match')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect current password')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show update profile dialog
  void updateProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditingProfile ? 'Edit Profile' : 'View Profile'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: usernameController,
                      enabled: isEditingProfile,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: fullNameController,
                      enabled: isEditingProfile,
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: emailController,
                      enabled: isEditingProfile,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: mobileController,
                      enabled: isEditingProfile,
                      decoration: InputDecoration(labelText: 'Mobile'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (isEditingProfile) {
                          saveProfileData();
                        } else {
                          setState(() {
                            isEditingProfile = true; // Enable editing
                          });
                        }
                      },
                      child: Text(
                          isEditingProfile ? 'Save Changes' : 'Edit Profile'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Username
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Username: ${usernameController.text}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display Full Name
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Full Name: ${fullNameController.text}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display Email and Mobile (if set)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Email: ${emailController.text.isEmpty ? 'Not Set' : emailController.text}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mobile: ${mobileController.text.isEmpty ? 'Not Set' : mobileController.text}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Update Profile Button
            ElevatedButton(
              onPressed: updateProfile,
              child: Text(isEditingProfile ? 'Save Changes' : 'Edit Profile'),
            ),
            const SizedBox(height: 20),

            // Change Password Button
            ElevatedButton(
              onPressed: changePassword,
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
