import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/categories/booking_details.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CartScreen({super.key, required this.cart});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  double get totalAmount {
    return widget.cart.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Cart",
          style: TextStyle(fontFamily: 'Serif'),
        ),
        backgroundColor: const Color(0xFFEFC8C5),
        centerTitle: true,
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      body: widget.cart.isEmpty
          ? const Center(
        child: Text(
          "Your cart is empty!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEFC8C5),
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  var item = widget.cart[index];
                  return Card(
                    color: const Color(0xFFFFF5F4),
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.black.withOpacity(0.1),
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image'] ?? 'assets/photo.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item['name'] ?? 'Unknown Product',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4A4A),
                        ),
                      ),
                      subtitle: Text(
                        "Price: PKR ${item['price'] ?? 0} x ${item['quantity'] ?? 1}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E7F7F),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_shopping_cart),
                        color: const Color(0xFFEFC8C5),
                        onPressed: () => removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Color(0xFFEFC8C5), thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4A4A),
                    ),
                  ),
                  Text(
                    "PKR $totalAmount",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C4A4A),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const BookingDetailsScreen(marqueeName: "Your Booking"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFC8C5),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFF5F4),
    );
  }
}
