import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text("Favorite products will appear here."),
      ),
    );
  }
}
