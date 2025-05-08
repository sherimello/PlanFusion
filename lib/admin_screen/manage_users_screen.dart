import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, String>> users = List.generate(
    10,
    (index) => {
      'name': 'User ${index + 1}',
      'email': 'user${index + 1}@example.com',
    },
  );

  void _addOrEditUser({var user, int? index}) {
    final TextEditingController nameController =
        TextEditingController(text: user != null ? user['name'] : '');
    final TextEditingController emailController =
        TextEditingController(text: user != null ? user['email'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final String email = emailController.text.trim();
                if (name.isNotEmpty && email.isNotEmpty) {
                  setState(() {
                    if (user == null) {
                      // Add new user
                      users.add({'name': name, 'email': email});
                    } else {
                      // Edit existing user
                      users[index!] = {'name': name, 'email': email};
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  users.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5),
        // Elegant pink background
        title: const Text(
          "Manage Users",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif', // Elegant font
            color: Colors.black, // Text color for the app bar
          ),
        ),
        centerTitle: true,
        // Center the title for a balanced look
        elevation: 4,
        // Slight shadow for depth
        shadowColor: const Color(0xFFDFC2BF), // Subtle shadow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User List",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Dark text for better contrast
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No vendors found'));
                }
                return Expanded(
                  child: users.isEmpty
                      ? const Center(child: Text("No users available."))
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // final user = users[index];
                            var user = snapshot.data!.docs[index];

                            return _buildUserCard(user, index);
                          },
                        ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addOrEditUser(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFC8C5),
                // Light pink background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Add New User",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor:
          const Color(0xFFFFF5F4), // Light, subtle background color
    );
  }

  Widget _buildUserCard(var user, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFFFE9E7),
      // Light pink card background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.pink),
                  onPressed: () => _addOrEditUser(user: user, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
