import 'package:flutter/material.dart';
import 'home.dart';
import 'package:untitled5/client_screen/ai_budget_tracking.dart';
import 'chat.dart';
import 'cart.dart';
import 'profile.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int selectedIndex = 0;

  // Example cart data
  final List<Map<String, dynamic>> cart = [
    {"name": "Product 1", "price": 25.0, "quantity": 2},
    {"name": "Product 2", "price": 15.5, "quantity": 1},
  ];

  // List of screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      AIBudgetTracking(),
      const ChatScreen(),
      CartScreen(cart: cart),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex], // Show the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFEFC8C5), // Elegant pink color
        unselectedItemColor: const Color(0xFF5A4B4B), // Dark color for unselected items
        backgroundColor: const Color(0xFFEFC8C5), // Pink background color for the bottom nav
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
