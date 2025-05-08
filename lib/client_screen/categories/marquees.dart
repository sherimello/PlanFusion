import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/categories/booking_form.dart';

class MarqueeScreen extends StatefulWidget {
  const MarqueeScreen({super.key});

  @override
  MarqueeScreenState createState() => MarqueeScreenState();
}

class MarqueeScreenState extends State<MarqueeScreen> {
  TextEditingController searchController = TextEditingController();

  final List<String> marqueeNames = [
    "Marquee A",
    "Marquee B",
    "Marquee C",
    "Marquee D",
    "Marquee E",
  ];

  final List<List<String>> marqueeImages = [
    ['assets/marquee1.jpg', 'assets/marquee2.jpg', 'assets/marquee3.jpg'],
    ['assets/marquee1.jpg', 'assets/marquee2.jpg', 'assets/marquee3.jpg'],
    ['assets/marquee1.jpg', 'assets/marquee2.jpg', 'assets/marquee3.jpg'],
    ['assets/marquee1.jpg', 'assets/marquee2.jpg', 'assets/marquee3.jpg'],
    ['assets/marquee1.jpg', 'assets/marquee2.jpg', 'assets/marquee3.jpg'],
  ];

  final List<String> marqueeDescriptions = [
    "Perfect for grand weddings and events. Spacious, elegant, and luxurious for your big day.",
    "Luxury venue with beautiful decor. Celebrate your event with style and grace.",
    "Spacious marquee for large gatherings. Ideal for corporate and large social events.",
    "Elegant venue for classy events. A perfect place for weddings and upscale gatherings.",
    "Vintage-themed marquee for traditional celebrations. Perfect for themed or classic weddings."
  ];

  void filterMarquees(String query) {
    setState(() {
      marqueeNames.retainWhere((name) => name.toLowerCase().contains(query.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Marquee Booking",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4, // Adding subtle elevation to the app bar
        titleSpacing: 0, // Aligning title to the left
        shadowColor: const Color(0xFFDFC2BF), // Subtle shadow for depth
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Subtle background color
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 5, // Apply elevation to the search bar by wrapping it in Material
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
                  onChanged: filterMarquees,
                  decoration: InputDecoration(
                    hintText: "Search Marquees...",
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
                stream: FirebaseFirestore.instance
                    .collection('vendor_services')
                    .where("category", isEqualTo: "Marquee")
                    .snapshots(),
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
                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio:
                      MediaQuery.of(context).size.aspectRatio * 1.2,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var vendor = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingFormScreen(
                                marqueeName: vendor["productName"],
                                marqueeDescription: vendor["description"],
                                marqueeImages: [vendor["imageUrl"]],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 8, // Strong shadow for cards
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      vendor['imageUrl'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 180,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    vendor["productName"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "PKR ${vendor["price"]}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "PKR ${int.parse(vendor["price"]) - int.parse(vendor["discount"])}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black, // Price color changed to black
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
