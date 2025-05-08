import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        title: const Text(
          "Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
            color: Colors.black, // Black color for better visibility
          ),
        ),
        centerTitle: true,
        elevation: 0, // Removed shadow to prevent blur
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Subtle background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User Feedbacks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Changed to black
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 20),
              _buildFeedbackItem("User John", "Excellent service, very satisfied!"),
              _buildFeedbackItem("User Emily", "The service could be faster."),
              _buildFeedbackItem("User Michael", "Great experience, highly recommended."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle actions such as deleting feedback or responding to users
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background for button
                ),
                child: const Text(
                  "Manage Feedback",
                  style: TextStyle(color: Colors.black), // Black text for the button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Feedback Item Widget
  Widget _buildFeedbackItem(String userName, String feedback) {
    return Card(
      color: const Color(0xFFFFE9E7), // Subtle pink color for feedback cards
      elevation: 2, // Reduced elevation to avoid shadow blur
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black for better readability
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feedback,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // Changed to black for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FeedbackScreen(),
  ));
}
