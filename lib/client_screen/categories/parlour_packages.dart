import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product.dart'; // Import your product screen

class ParlourPackagesScreen extends StatefulWidget {
  const ParlourPackagesScreen({super.key});

  @override
  _ParlourPackagesScreenState createState() => _ParlourPackagesScreenState();
}

class _ParlourPackagesScreenState extends State<ParlourPackagesScreen> {
  TextEditingController searchController = TextEditingController();

  // Parlour packages list
  final List<String> packageNames = [
    "Bridal Makeup Package",
    "Party Makeup Package",
    "Facial & Skin Care Package",
    "Hair Styling & Treatment",
    "Manicure & Pedicure Package",
    "Full Body Massage"
  ];

  final List<String> packageDescriptions = [
    "Complete bridal makeup and hairstyling for your big day.",
    "Glamorous makeup for parties and events.",
    "Premium facials and skin care services.",
    "Expert haircuts, styling, and treatments.",
    "Relaxing manicure and pedicure services.",
    "Therapeutic full body massage for relaxation."
  ];

  final List<String> packageImages =
  List.generate(6, (index) => 'assets/beauty.jpg'); // Replace with actual images

  // Original prices and discount percentages
  final List<String> originalPrices =
  List.generate(6, (index) => "PKR ${(index + 1) * 5000}");
  final List<double> discounts = [0.2, 0.3, 0.15, 0.25, 0.3, 0.2]; // Discounts for each package

  // Filtered packages list
  late List<String> filteredPackageNames;
  late List<String> filteredPackageDescriptions;
  late List<String> filteredPackageImages;
  late List<String> filteredOriginalPrices;
  late List<String> filteredDiscountPrices;

  @override
  void initState() {
    super.initState();
    // Filtered list ko initialize kiya gaya
    filteredPackageNames = List.from(packageNames);
    filteredPackageDescriptions = List.from(packageDescriptions);
    filteredPackageImages = List.from(packageImages);
    filteredOriginalPrices = List.from(originalPrices);
    filteredDiscountPrices = List.generate(
      6,
          (index) =>
      "PKR ${((1 - discounts[index]) * (index + 1) * 5000).toStringAsFixed(0)}",
    );
  }

  // Function jo parlour packages ko search query ke mutabiq filter karega
  void filterPackages(String query) {
    setState(() {
      filteredPackageNames = packageNames
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList()
          .cast<String>(); // Ensure List<String>
      filteredPackageDescriptions = packageDescriptions
          .where((description) =>
          description.toLowerCase().contains(query.toLowerCase()))
          .toList()
          .cast<String>(); // Ensure List<String>
      filteredPackageImages = packageImages
          .where((image) => image.toLowerCase().contains(query.toLowerCase()))
          .toList()
          .cast<String>(); // Ensure List<String>
      filteredOriginalPrices = originalPrices
          .where((price) => price.toLowerCase().contains(query.toLowerCase()))
          .toList()
          .cast<String>(); // Ensure List<String>
      filteredDiscountPrices = filteredOriginalPrices
          .map((price) =>
      "PKR ${((1 - discounts[originalPrices.indexOf(price)]) * int.parse(price.split(' ')[1])).toStringAsFixed(0)}")
          .toList()
          .cast<String>(); // Ensure List<String>
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsiveness
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parlour Packages",
          style: TextStyle(
            fontFamily: 'Serif', // Elegant font
            fontSize: 24, // Slightly larger font
            fontWeight: FontWeight.bold, // Bold text for emphasis
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        centerTitle: true,
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF), // Subtle shadow
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
                  onChanged: filterPackages, // Filter function
                  decoration: InputDecoration(
                    hintText: "Search Parlour Packages...",
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
                    .where("category", isEqualTo: "Beauty")
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
                      crossAxisCount: 2,
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
