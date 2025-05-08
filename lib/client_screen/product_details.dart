// product_details.dart
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int index;  // Add this

  const ProductDetailsScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: Center(
        child: Text("Details of Product $index"),
      ),
    );
  }
}
