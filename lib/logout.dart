import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  // Logout functionality
  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      // After sign out, navigate to login screen and remove all previous routes
      Navigator.pushReplacementNamed(context, '/login'); // Replacing the current route
    } catch (e) {
      // Handle error and show snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          // Background image
          image: const DecorationImage(
            image: AssetImage('assets/b8.jpg'), // Reusing the background image
            fit: BoxFit.cover,
          ),
          // Gradient overlay for better readability
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.7),
              Colors.white.withOpacity(0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo image
            ClipOval(
              child: Image.asset(
                'assets/logo.jpg', // Assuming this is the logo
                height: screenHeight * 0.15,
                width: screenHeight * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.05), // Space after the logo

            // Confirmation text (now above the logo)
            const Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5A4B4B), // Elegant dark pink
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Space after the message

            // Logout button
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFC8C5), // Soft pink button
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("LOG OUT"),
            ),
            SizedBox(height: screenHeight * 0.02), // Space after logout button

            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Color(0xFF5A4B4B), // Subtle text color
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
