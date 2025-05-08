import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'categories/dresses.dart';
import 'categories/parlour_packages.dart';
import 'categories/jewellery.dart';
import 'categories/marquees.dart';
import 'categories/catering.dart';
import 'product_details.dart';
import 'package:untitled5/responsive_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      "icon": Icons.checkroom,
      "title": "Dresses",
      "screen": const DressesScreen()
    },
    {
      "icon": Icons.spa,
      "title": "Beauty",
      "screen": const ParlourPackagesScreen()
    },
    {
      "icon": Icons.diamond,
      "title": "Jewellery",
      "screen": const JewelleryScreen()
    },
    {"icon": Icons.place, "title": "Marquees", "screen": const MarqueeScreen()},
    {
      "icon": Icons.restaurant,
      "title": "Catering",
      "screen": const CateringScreen()
    },
  ];
  Stream<QuerySnapshot>? _vendorsStream; // Declare the stream variable

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _vendorsStream = FirebaseFirestore.instance
        .collection('vendor_services')
        .snapshots();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.dynamicText(context, 6),
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5),
        elevation: 5,
      ),
      body: Container(
        color: const Color(0xFFFFF5F4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context),
              _buildFlashSaleSection(context, isPortrait),
              _buildCategorySection(context),
              _buildRecommendationSection(context, isPortrait),
              SizedBox(height: ResponsiveHelper.dynamicHeight(context, 5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.dynamicWidth(context, 5),
        vertical: ResponsiveHelper.dynamicHeight(context, 2),
      ),
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
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.dynamicText(context, 4),
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFEFC8C5)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.dynamicHeight(context, 1.5),
                horizontal: ResponsiveHelper.dynamicWidth(context, 4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlashSaleSection(BuildContext context, bool isPortrait) {
    return SizedBox(
      height: isPortrait
          ? ResponsiveHelper.dynamicHeight(context, 25)
          : ResponsiveHelper.dynamicHeight(context, 40),
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _buildSaleItem(context, 'assets/sale1.jpg'),
              _buildSaleItem(context, 'assets/sale2.jpg'),
              _buildSaleItem(context, 'assets/sale2.jpg'),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleItem(BuildContext context, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.dynamicWidth(context, 5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.dynamicWidth(context, 5),
            vertical: ResponsiveHelper.dynamicHeight(context, 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: ResponsiveHelper.dynamicText(context, 5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Search by Filter",
                style: TextStyle(
                  fontSize: ResponsiveHelper.dynamicText(context, 4),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.dynamicHeight(context, 18),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              var item = _categories[index];
              return _buildCategoryIcon(
                context,
                item['icon'],
                item['title'],
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['screen']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final size = ResponsiveHelper.dynamicWidth(context, 15);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.dynamicWidth(context, 2)),
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: Color(0xFFEFC8C5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: size * 0.5),
            ),
            SizedBox(height: ResponsiveHelper.dynamicHeight(context, 1)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.dynamicText(context, 3.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(BuildContext context, bool isPortrait) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.dynamicWidth(context, 5),
          vertical: ResponsiveHelper.dynamicHeight(context, 2),
        ),
        child: Text(
          "Recommendations",
          style: TextStyle(
            fontSize: ResponsiveHelper.dynamicText(context, 5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection('vendor_services')
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(child: CircularProgressIndicator());
      //       }
      //       if (snapshot.hasError) {
      //         return Center(child: Text('Error: ${snapshot.error}'));
      //       }
      //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //         return const Center(child: Text('No vendors found'));
      //       }
      //       return GridView.builder(
      //         shrinkWrap: true,
      //         physics: const NeverScrollableScrollPhysics(),
      //         padding: EdgeInsets.symmetric(
      //             horizontal: ResponsiveHelper.dynamicWidth(context, 3)),
      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: ResponsiveHelper.isDesktop(context)
      //               ? 4
      //               : ResponsiveHelper.isTablet(context)
      //                   ? 3
      //                   : 2,
      //           crossAxisSpacing: ResponsiveHelper.dynamicWidth(context, 3),
      //           mainAxisSpacing: ResponsiveHelper.dynamicHeight(context, 2),
      //           childAspectRatio: isPortrait ? 0.75 : 1.25,
      //         ),
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           var vendor = snapshot.data!.docs[index];
      //           return _buildProductCard(context, vendor);
      //         },
      //       );
      //     }),
      StreamBuilder<QuerySnapshot>(
          stream: _vendorsStream, // Use the stream from the state
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

            // Your GridView.builder remains the same
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Be cautious with this if the parent is not scrollable
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.dynamicWidth(context, 3)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isDesktop(context)
                    ? 4
                    : ResponsiveHelper.isTablet(context)
                        ? 3
                        : 2,
                crossAxisSpacing: ResponsiveHelper.dynamicWidth(context, 3),
                mainAxisSpacing: ResponsiveHelper.dynamicHeight(context, 2),
                childAspectRatio: isPortrait ? 0.75 : 1.25,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // It's good practice to cast to QueryDocumentSnapshot or Map<String, dynamic>
                // QueryDocumentSnapshot vendor = snapshot.data!.docs[index];
                // Map<String, dynamic> vendorData = vendor.data() as Map<String, dynamic>;
                var vendorDoc = snapshot.data!.docs[index];
                return _buildProductCard(context, vendorDoc);
              },
            );
          })
    ]);
  }

  Widget _buildProductCard(BuildContext context, QueryDocumentSnapshot vendor) { // Changed type for better safety
    // Access data using vendor.data() and cast, or directly if you're sure of the structure
    // final vendorData = vendor.data() as Map<String, dynamic>? ?? {}; // Safe access

    // Assuming vendor["imageUrl"] and vendor["productName"] exist
    final String imageUrl = vendor.get("imageUrl") ?? 'https://via.placeholder.com/150'; // Provide a fallback
    final String productName = vendor.get("productName") ?? 'Unnamed Product'; // Provide a fallback

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProductDetailsScreen(index: 0)), // Consider passing vendor ID or details
      ),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(ResponsiveHelper.dynamicWidth(context, 2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Add errorBuilder and loadingBuilder for Image.network for better UX
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                  },
                ),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.all(ResponsiveHelper.dynamicWidth(context, 3)),
              child: Text(
                productName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.dynamicText(context, 3.5),
                ),
                maxLines: 2, // Prevent text overflow
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
