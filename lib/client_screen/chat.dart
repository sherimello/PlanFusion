import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(fontFamily: 'Serif'), // Elegant font
        ),
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        centerTitle: true, // Center the title for balance
        elevation: 4, // Slight shadow for depth
        shadowColor: const Color(0xFFDFC2BF), // Subtle shadow color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with gradient background and shadow
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEFC8C5), Color(0xFFFFE9E7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEFC8C5).withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  size: 120,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // "Coming Soon" Text with elegant typography and shadow
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9E7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFEFC8C5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  "Coming Soon",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFC8C5),
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description text with padding for better readability
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "We're working on something exciting for you.\nStay tuned!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFEFC8C5),
                    fontWeight: FontWeight.w500,
                    height: 1.5, // Line height for better readability
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Notify Me Button with elegant styling
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat feature is coming soon!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFFEFC8C5),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFC8C5),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Notify Me',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Subtle background for cohesion
    );
  }
}
