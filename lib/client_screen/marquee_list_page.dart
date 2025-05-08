import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'marquee_card.dart';

// ✅ Updated filter function
List<Map<String, dynamic>> filterMarquees({
  required List<Map<String, dynamic>> marquees,
  required double budget,
}) {
  return marquees.where((marquee) {
    bool isWithinBudget =
        marquee['minPrice'] <= budget && marquee['maxPrice'] >= budget;
    return isWithinBudget;
  }).toList();
}

class MarqueeListPage extends StatefulWidget {
  final double budget;
  const MarqueeListPage({super.key, required this.budget}); // Use super.key

  @override
  State<MarqueeListPage> createState() => _MarqueeListPageState();
}

class _MarqueeListPageState extends State<MarqueeListPage> {
  Stream<QuerySnapshot>? _vendorsStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  @override
  void didUpdateWidget(MarqueeListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.budget != oldWidget.budget) {
      // If budget can change, re-initialize the stream
      _initializeStream();
    }
  }

  void _initializeStream() {
    print("Initializing stream with budget: ${widget.budget}");
    setState(() { // Ensure UI rebuilds with the new stream
      _vendorsStream = FirebaseFirestore.instance
          .collection('vendor_services')
          .where("category", isEqualTo: "Marquee")
      // Assuming 'price' in Firestore is the one to check against budget
      //     .where("price", isLessThanOrEqualTo: widget.budget) // Using isLessThanOrEqualTo
      // .limit(1000) // Consider if limit is needed, or use pagination
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: const Text("Suggested Marquees"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Firestore Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No marquees found within your budget.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Data is directly from Firestore snapshot
          final firestoreMarquees = snapshot.data!.docs;

          return ListView.builder(
            itemCount: firestoreMarquees.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot marqueeDoc = firestoreMarquees[index];
              // Convert QueryDocumentSnapshot to Map<String, dynamic> if MarqueeCard expects that
              // Map<String, dynamic> marqueeData = marqueeDoc.data() as Map<String, dynamic>;
              // Add id if needed: marqueeData['id'] = marqueeDoc.id;

              // Ensure MarqueeCard can handle QueryDocumentSnapshot or adapt the data
              // For example, if MarqueeCard expects a Map:
              Map<String, dynamic> marqueeDataForCard = {
                'name': marqueeDoc.get('productName') ?? 'N/A', // Use your actual field names
                'minPrice': "${int.parse(marqueeDoc.get('price')) - int.parse(marqueeDoc.get('discount'))}" ?? 0, // If you have these in Firestore
                'maxPrice': marqueeDoc.get('price') ?? 0, // If you have these in Firestore
                'price': marqueeDoc.get('price') ?? 0, // The price used for filtering
                'range': "PKR 0 - ${widget.budget}",
                'menu': 'N/A',
                'location': 'N/A',
                'image': marqueeDoc.get('imageUrl') ?? 'assets/placeholder.jpg', // Fallback image
                'route': '/default_route',
                // Add any other fields MarqueeCard needs from Firestore
              };
              return MarqueeCard(marquee: marqueeDataForCard);
            },
          );
        },
      ),
    );
  }
}