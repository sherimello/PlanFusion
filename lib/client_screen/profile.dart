import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget buildSectionTile(String title, IconData icon, Function onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFEFC8C5)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6C4A4A),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9E7F7F)),
      onTap: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEFC8C5),
        centerTitle: true,
        elevation: 4,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEFC8C5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile picture
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.person, size: 50, color: Color(0xFF6C4A4A)),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PlanFusion",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF6C4A4A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "planfusion@example.com",
                        style: TextStyle(color: Color(0xFF6C4A4A), fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Account Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4A4A),
                ),
              ),
            ),
            buildSectionTile(
              "My Orders",
              Icons.shopping_bag,
                  () => {}, // Handle navigation
            ),
            buildSectionTile(
              "Wishlist",
              Icons.favorite,
                  () => {}, // Handle navigation
            ),
            buildSectionTile(
              "Vouchers",
              Icons.card_giftcard,
                  () => {}, // Handle navigation
            ),

            // Settings Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4A4A),
                ),
              ),
            ),
            buildSectionTile(
              "Account Settings",
              Icons.settings,
                  () => {}, // Handle navigation
            ),
            buildSectionTile(
              "Payment Methods",
              Icons.credit_card,
                  () => {}, // Handle navigation
            ),
            buildSectionTile(
              "Address Book",
              Icons.location_on,
                  () => {}, // Handle navigation
            ),

            // Support Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Support",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C4A4A),
                ),
              ),
            ),
            buildSectionTile(
              "Help Center",
              Icons.help_outline,
                  () => {}, // Handle navigation
            ),
            buildSectionTile(
              "Contact Us",
              Icons.phone,
                  () => {}, // Handle navigation
            ),
            buildSectionTile(
              "Privacy Policy",
              Icons.privacy_tip,
                  () => {}, // Handle navigation
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFC8C5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/logout'); // Navigate to logout screen
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFF5F4),
    );
  }
}
