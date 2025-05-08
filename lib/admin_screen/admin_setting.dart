import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        title: const Text(
          "Admin Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
            color: Colors.black, // Black text color for better visibility
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
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text color
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 20),
              _buildSettingItem("Change Password", Icons.lock),
              _buildSettingItem("Manage Users", Icons.people),
              _buildSettingItem("Notifications", Icons.notifications),
              _buildSettingItem("App Theme", Icons.color_lens),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle actions like saving settings
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background for button
                ),
                child: const Text(
                  "Save Settings",
                  style: TextStyle(color: Colors.black), // Black text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Setting Item Widget
  Widget _buildSettingItem(String title, IconData icon) {
    return Card(
      color: const Color(0xFFFFE9E7), // Light pink color for setting items
      elevation: 2, // Reduced elevation to avoid shadow blur
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFEFC8C5)), // Elegant pink color for icons
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Black text for better visibility
            fontFamily: 'Serif',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminSettingsScreen(),
  ));
}
