import 'package:flutter/material.dart';

class ManageNotificationsScreen extends StatelessWidget {
  const ManageNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        title: const Text(
          "Manage Notifications",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notifications List",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // This can be dynamic based on the notifications available
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFFFFE9E7), // Solid color with no transparency
                    elevation: 2, // Reduced elevation to avoid shadow blur
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications, color: Color(0xFFEFC8C5)),
                      title: Text(
                        "Notification #$index",
                        style: const TextStyle(
                          color: Colors.black, // Black color for better visibility
                          fontFamily: 'Serif',
                        ),
                      ),
                      subtitle: const Text(
                        "This is a notification detail",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Serif',
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Color(0xFFEFC8C5)),
                        onPressed: () {
                          // You can add your delete functionality here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Notification #$index deleted")),
                          );
                        },
                      ),
                    ),
                  );
                },
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
    home: ManageNotificationsScreen(),
  ));
}
