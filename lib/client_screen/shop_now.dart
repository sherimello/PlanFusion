// shop_now_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/categories/booking_details.dart';


class BookNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  const BookNowScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ListTile(
            title: Text("Cash on Delivery (COD)"),
            leading: Icon(Icons.payment),
          ),
          const Divider(),
          ListTile(
            title: const Text("Credit/Debit Card"),
            leading: const Icon(Icons.credit_card),
            onTap: () {
              // Add functionality for Credit/Debit Card if needed
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("JazzCash"),
            leading: const Icon(Icons.money),
            onTap: () {
              // Add functionality for JazzCash if needed
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("EasyPaisa"),
            leading: const Icon(Icons.money),
            onTap: () {
              // Add functionality for EasyPaisa if needed
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Bank Transfer"),
            leading: const Icon(Icons.account_balance),
            onTap: () {
              // Add functionality for Bank Transfer if needed
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingDetailsScreen(marqueeName: "Marquee Name"), // Update with actual marquee name
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Book Now"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
