import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'vendor_management_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';

class ServiceProviderMain extends StatefulWidget {
  const ServiceProviderMain({super.key});

  @override
  ServiceProviderMainState createState() => ServiceProviderMainState();
}

class ServiceProviderMainState extends State<ServiceProviderMain> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const VendorManagementScreen(),
    const ChatScreen(), // New chat screen
    const ServiceProviderProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: const Color(0xFFEFC8C5),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center_outlined),
                activeIcon: Icon(Icons.business_center),
                label: 'Vendor',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                activeIcon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
