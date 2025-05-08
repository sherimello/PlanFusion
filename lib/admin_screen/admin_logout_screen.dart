import 'package:flutter/material.dart';

class AdminLogoutScreen extends StatelessWidget {
  const AdminLogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEFC8C5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 3,
            )
          ],
          border: Border.all(
            color: const Color(0xFFD7A8A1),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logout Icon inside Circle (Bold and Black)
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Logout Message in Bold and Black
            const Text(
              "LOGOUT",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            // Main Message: "Are you sure you want to logout?"
            const Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5A4B4B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 25),

            // Buttons: Yes and Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel Button
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5A4B4B),
                    side: const BorderSide(
                      color: Color(0xFF5A4B4B),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 15),

                // Logout Button (Yes, Logout)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A4B4B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Yes, Logout",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
