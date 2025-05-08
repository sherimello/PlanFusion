import 'package:flutter/material.dart';

class ActivityLogScreen extends StatelessWidget {
  // Removed the const constructor
  ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5), // Same as profile screen
        title: const Text(
          "Activity Logs",
          style: TextStyle(
            color: Colors.black, // App bar text color to black
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif', // Consistent font style
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Icon color
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF), // Light shadow for the app bar
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Consistent background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar for filtering logs
              _buildSearchBar(),
              const SizedBox(height: 20),
              // Activity logs list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activityLogs.length,
                itemBuilder: (context, index) {
                  return _buildActivityItem(
                    activityLogs[index]['description']!,
                    activityLogs[index]['timestamp']!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search Activity Logs',
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white, // Consistent with the profile screen text field
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  // Activity log item widget
  Widget _buildActivityItem(String description, String timestamp) {
    return Card(
      color: const Color(0xFFEFC8C5), // Consistent card color
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black), // Consistent text color
            ),
            Text(
              timestamp,
              style: const TextStyle(fontSize: 12, color: Colors.grey), // Timestamp styling
            ),
          ],
        ),
      ),
    );
  }

  // Sample activity logs
  final List<Map<String, String>> activityLogs = [
    {"description": "User John booked a service.", "timestamp": "2 hours ago"},
    {"description": "Feedback received from User Emily.", "timestamp": "5 hours ago"},
    {"description": "Admin updated service details.", "timestamp": "1 day ago"},
    {"description": "User Mark canceled a booking.", "timestamp": "3 days ago"},
    // Add more logs as needed
  ];
}
