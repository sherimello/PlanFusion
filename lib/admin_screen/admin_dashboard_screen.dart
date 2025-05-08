import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'manage_users_screen.dart';
import 'manage_services_screen.dart';
import 'reports_screen.dart';
import 'manage_notifications_screen.dart';
import 'feedback_screen.dart';
import 'activity_log_screen.dart';
import 'admin_setting.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: const Color(0xFFEFC8C5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSidebarOption(Icons.people, "Manage Users", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ManageUsersScreen()));
                      }),
                      _buildSidebarOption(
                          Icons.miscellaneous_services, "Manage Services", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ManageServicesScreen()));
                      }),
                      _buildSidebarOption(Icons.bar_chart, "Reports", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportsScreen()));
                      }),
                      _buildSidebarOption(
                          Icons.notifications, "Manage Notifications", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ManageNotificationsScreen()));
                      }),
                      _buildSidebarOption(Icons.feedback, "Feedback", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FeedbackScreen()));
                      }),
                      _buildSidebarOption(Icons.history, "Activity Logs", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityLogScreen()));
                      }),
                      _buildSidebarOption(Icons.settings, "Settings", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminSettingsScreen()));
                      }),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.pink[800]),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[900]),
                  ),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard Overview",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      viewportFraction: 0.3,
                      enlargeCenterPage: true,
                    ),
                    items: [
                      StreamBuilder<AggregateQuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collectionGroup('Orders')
                            // You might add a .where() clause here if you only want to count specific types of orders
                            // e.g., .where('status', isEqualTo: 'confirmed')
                            .count()
                            .get()
                            .asStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.count == 0) {
                            return const Center(
                                child: Text('No vendors found'));
                          }
                          return _buildStatCard(
                              context, "Bookings", snapshot.data!.count.toString(), Icons.book_online);
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('No vendors found'));
                          }
                          return _buildStatCard(
                              context, "Users", snapshot.data!.docs.length.toString(), Icons.people);
                        },
                      ),
                      _buildStatCard(context, "Services", "5",
                          Icons.miscellaneous_services),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Activity Overview",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  _buildUniformCardLayout(
                    "Recent Activity",
                    [
                      _buildActivityItem(
                          "User John booked a service.", "2 hours ago"),
                      _buildActivityItem("Feedback received from User Emily.",
                          "5 hours ago"),
                    ],
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('Orders')
                    // You might add a .where() clause here if you only want to count specific types of orders
                    // e.g., .where('status', isEqualTo: 'confirmed')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No vendors found'));
                      }
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                          var order = snapshot.data!.docs[index];
                          return Text("${order["customerName"]} with a budget of ${order["expectedBudget"]} booked ${order["selectedHall"]}.\n");
                        }),
                      );
                    },
                  ),
                  // _buildUniformCardLayout(
                  //   "Recent Notifications",
                  //   [
                  //     _buildNotificationItem(
                  //         "System maintenance scheduled at 10 PM."),
                  //     _buildNotificationItem(
                  //         "New service added: Catering Deluxe."),
                  //   ],
                  //   width: MediaQuery.of(context).size.width * 0.6,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[800]),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(
                  context); // Navigate out of dashboard (simulate logout)
              // You can also use Navigator.pushReplacementNamed() if you have a login screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink[800]),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      color: const Color(0xFFFFE9E7),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.28,
        height: MediaQuery.of(context).size.height * 0.18,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.pink),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUniformCardLayout(String title, List<Widget> children,
      {required double width}) {
    return Card(
      color: const Color(0xFFFFE9E7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String description, String timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(description,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
            Text(timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "- $message",
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}
