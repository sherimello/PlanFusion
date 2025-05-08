import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class DressesScreen extends StatefulWidget {
  const DressesScreen({super.key});

  @override
  DressesScreenState createState() => DressesScreenState();
}

class DressesScreenState extends State<DressesScreen> {
  TextEditingController searchController = TextEditingController();

  final List<String> dressNames = [
    "Wedding Gown",
    "Evening Dress",
    "Cocktail Dress",
    "Party Dress",
    "Casual Dress",
    "Maxi Dress"
  ];

  final List<String> dressDescriptions = [
    "Elegant gown for your special day.",
    "Perfect for evening events and parties.",
    "Stylish cocktail dress for formal gatherings.",
    "Fun and vibrant dress for party nights.",
    "Comfortable and casual dress for daily wear.",
    "Flowy maxi dress for a relaxed look."
  ];

  final List<String> dressImages = List.generate(6, (index) => 'assets/dress.jpg');

  final List<String> originalPrices = List.generate(6, (index) => "PKR ${index * 1500 + 5000}");
  final List<double> discounts = [0.3, 0.5, 0.7, 0.3, 0.5, 0.7];

  late List<String> filteredDressNames;
  late List<String> filteredDressDescriptions;
  late List<String> filteredDressImages;
  late List<String> filteredOriginalPrices;
  late List<String> filteredDiscountPrices;

  @override
  void initState() {
    super.initState();

    filteredDressNames = List.from(dressNames);
    filteredDressDescriptions = List.from(dressDescriptions);
    filteredDressImages = List.from(dressImages);
    filteredOriginalPrices = List.from(originalPrices);
    filteredDiscountPrices = List.generate(
      6,
          (index) => "PKR ${((1 - discounts[index]) * (index * 1500 + 5000)).toStringAsFixed(0)}",
    );
  }

  void filterDresses(String query) {
    setState(() {
      filteredDressNames = dressNames
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredDressDescriptions = dressDescriptions
          .where((description) => description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dresses",
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
                  onChanged: filterDresses,
                  decoration: InputDecoration(
                    hintText: "Search Dresses...",
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
                    .where("category", isEqualTo: "Dress")
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
                              builder: (context) => ProductScreen(
                                productName: vendor["productName"],
                                productDescription: vendor["description"],
                                productImage: vendor["imageUrl"],
                                productPrice:
                                "PKR ${int.parse(vendor["price"]) - int.parse(vendor["discount"])}",
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