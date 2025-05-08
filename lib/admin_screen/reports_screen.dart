import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        title: const Text(
          "Reports",
          style: TextStyle(
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            color: Colors.black, // Black color for better visibility
          ),
        ),
        centerTitle: true,
        elevation: 0, // Removed shadow to prevent blur
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Subtle background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report Overview",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16, // Spacing between cards
              runSpacing: 16, // Spacing between rows
              children: [
                _buildReportCard("Total Bookings", "123", Icons.book_online),
                _buildReportCard("Total Users", "456", Icons.people),
                _buildReportCard("Total Services", "789", Icons.miscellaneous_services),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Recent Activities",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 10),
            _buildActivityItem("User John booked a service.", "2 hours ago"),
            _buildActivityItem("Feedback received from User Emily.", "5 hours ago"),
          ],
        ),
      ),
    );
  }

  // Report Card Widget
  Widget _buildReportCard(String title, String value, IconData icon) {
    return Card(
      color: const Color(0xFFFFE9E7), // Solid color with no transparency
      elevation: 2, // Reduced elevation to avoid shadow blur
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFFEFC8C5),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
                fontFamily: 'Serif',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Activity Item Widget
  Widget _buildActivityItem(String description, String timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black, // Changed to black
              fontFamily: 'Serif',
            ),
          ),
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black, // Changed to black
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportsScreen(),
  ));
}
