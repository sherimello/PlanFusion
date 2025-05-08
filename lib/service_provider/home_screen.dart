import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Provider Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      backgroundColor: const Color(0xFFFFF5F4),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEFC8C5), Color(0xFFF3D0D1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    // Implement search functionality if needed
                  },
                  decoration: InputDecoration(
                    hintText: "Search services...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFEFC8C5)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('vendor_services').snapshots(),
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

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var vendor = snapshot.data!.docs[index];
                    return ListTile(
                      leading: vendor['imageUrl'] != null
                          ? Image.network(vendor['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                          : Container(width: 50, height: 50, color: Colors.grey),
                      title: Text(vendor['productName']),
                      subtitle: Text(vendor['description']),
                      trailing: Text('\$${vendor['price']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
