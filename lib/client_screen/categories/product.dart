import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/cart.dart';

class ProductScreen extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String productImage;
  final String productPrice;

  const ProductScreen({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.productPrice,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 0;
  bool isFavorite = false;
  List<String> wishlist = [];

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;

      if (isFavorite) {
        wishlist.add(widget.productName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.productName} added to wishlist!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.grey[800], // Dark background for theme
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Undo action (if desired)
                setState(() {
                  isFavorite = !isFavorite;
                  wishlist.remove(widget.productName);
                });
              },
              textColor: Colors.white, // Text color for undo action
            ),
          ),
        );
      } else {
        wishlist.remove(widget.productName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.productName} removed from wishlist!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.grey[800], // Dark background for theme
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void updateQuantity(int change) {
    setState(() {
      quantity += change;
      if (quantity < 0) quantity = 0;
      if (quantity > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$quantity of ${widget.productName} in cart!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.grey[800], // Dark background for theme
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void addToCart() {
    if (quantity > 0) {
      List<Map<String, dynamic>> cart = [
        {
          'name': 'Product 1',
          'price': 1000.0,
          'quantity': 2,
          'image': 'assets/photo.jpg',
        },
        {
          'name': 'Product 2',
          'price': 1500.0,
          'quantity': 1,
          'image': 'assets/photo.jpg',
        },
      ];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(cart: cart),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a quantity before adding to cart.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey, // Dark grey background for theme
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
            textColor: Colors.white, // Text color for action
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        titleSpacing: 0,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Subtle background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.productImage,
                  fit: BoxFit.fitWidth,
                  width: screenWidth * 0.9, // 90% of screen width
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              // Price and Description container should also match image width
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: screenWidth * 0.9, // Match image width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productPrice, // Just the price, no "PKR"
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black, // Price color updated to black
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: isFavorite ? Colors.red : Colors.black, // Icon color updated to black
                              ),
                              onPressed: toggleFavorite,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat, color: Colors.black), // Icon color updated to black
                              onPressed: () {
                                // Handle chat action
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Description:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.productDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => updateQuantity(-1),
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => updateQuantity(1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.black), // Set text color to black
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
