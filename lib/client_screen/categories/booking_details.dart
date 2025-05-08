import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/home.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String marqueeName;

  const BookingDetailsScreen({super.key, required this.marqueeName});

  @override
  BookingDetailsScreenState createState() => BookingDetailsScreenState();
}

class BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Form",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        titleSpacing: 0,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      backgroundColor: const Color(0xFFFFF5F4), // Light background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  "Booking for ${widget.marqueeName}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Name Input Field
              _buildTextField(
                controller: _nameController,
                label: 'Your Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              // Contact Number Input Field
              _buildTextField(
                controller: _contactController,
                label: 'Contact Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),

              // Event Date Input Field
              _buildTextField(
                controller: _dateController,
                label: 'Event Date',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event date';
                  }
                  return null;
                },
              ),

              // Number of Guests Input Field
              _buildTextField(
                controller: _guestsController,
                label: 'Number of Guests',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of guests';
                  }
                  return null;
                },
              ),

              const Spacer(),
              // Submit Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isSubmitted = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Your form has been submitted")),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigate to HomeScreen after submission
                          );
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Submit Booking",
                      style: TextStyle(color: Colors.black), // Black text for contrast
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Thank You Message after Submission
              if (_isSubmitted) const Column(
                children: [
                  Text(
                    "Thank you for your submission!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom method to build text fields with consistent style
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEFC8C5)), // Elegant pink when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black26),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
