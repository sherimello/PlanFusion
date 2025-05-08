import 'package:flutter/material.dart';
import 'signup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to SignUpScreen after a delay of 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    });

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
            // Logo image at the top
            ClipOval(
              child: Image.asset(
                'assets/logo.jpg', // Assuming this is the logo
                height: screenHeight * 0.15,
                width: screenHeight * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.05), // Space after the logo

            // PlanFusion text
            const Text(
              'PlanFusion',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4B3832), // Champagne-like text color
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Space between PlanFusion and AI Driven text

            // AI Driven Budget Wedding App text below PlanFusion
            const Text(
              'AI Driven Budget Wedding App',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4B3832), // Champagne-like text color
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
