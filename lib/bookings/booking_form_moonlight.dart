import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingFormMoonlight extends StatefulWidget {
  @override
  State<BookingFormMoonlight> createState() => _BookingFormMoonlightState();
}

class _BookingFormMoonlightState extends State<BookingFormMoonlight> {
  final _formKey = GlobalKey<FormState>();

  String customerName = '';
  int guestCount = 0;
  int expectedBudget = 0;
  String? selectedHall;
  int hallPrice = 0;
  String? selectedMenu;
  int menuPricePerHead = 0;
  String menuDetails = '';
  int totalCost = 0;
  bool _isLoading =
  false; // To show loading indicator during Firebase operation

  final List<Map<String, dynamic>> halls = [
    {'name': 'Grande Hall', 'price': 220000},
    {'name': 'Luxury Hall', 'price': 300000},
  ];

  final List<Map<String, dynamic>> menus = [
    {
      'name': 'Menu 1 - PKR 2200/head',
      'price': 2200,
      'details': 'Includes Cold Drink, Pasta'
    },
    {
      'name': 'Standard Menu - PKR 3200/head',
      'price': 3200,
      'details': 'Includes Chinese Cuisine'
    },
    {
      'name': 'Premium Menu - PKR 4500/head',
      'price': 4500,
      'details': 'BBQ + Continental + Drinks'
    },
    {
      'name': 'Royal Menu - PKR 6000/head',
      'price': 6000,
      'details': 'Seafood, Mocktails, Dessert Variety'
    },
  ];

  void _calculateTotal() {
    // Changed to private
    setState(() {
      // Ensure UI updates if totalCost is displayed directly (though not in this example)
      if (selectedHall != null && selectedMenu != null && guestCount > 0) {
        totalCost = hallPrice + (menuPricePerHead * guestCount);
      } else {
        totalCost = 0;
      }
    });
  }

  Future<void> _saveOrderToFirestore() async {
    if (totalCost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('Please complete selections to calculate total cost.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> bookingData = {
        'customerName': customerName,
        'guestCount': guestCount,
        'expectedBudget': expectedBudget,
        'selectedHall': selectedHall,
        'hallPrice': hallPrice,
        'selectedMenu': selectedMenu,
        'menuPricePerHead': menuPricePerHead,
        'menuDetails': menuDetails,
        'totalCost': totalCost,
        'bookingDate': FieldValue.serverTimestamp(), // Timestamp of booking
        'status': 'pending', // Initial status
        // 'userId': FirebaseAuth.instance.currentUser?.uid, // If you have auth
      };

      // Add a new document with a generated ID to the 'user_bookings' subcollection
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc('moonlight')
          .collection("Orders")
          .doc(
          FirebaseFirestore.instance.collection('vendor_services').doc().id)
          .set(bookingData);
      // DocumentReference docRef = await grandeurUserBookings.add(bookingData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking placed successfully!')),
        );
        // Optionally, clear the form or navigate away
        _formKey.currentState?.reset();
        setState(() {
          customerName = '';
          guestCount = 0;
          expectedBudget = 0;
          selectedHall = null;
          hallPrice = 0;
          selectedMenu = null;
          menuPricePerHead = 0;
          menuDetails = '';
          totalCost = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place booking: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _checkBudgetAndBook() {
    // Changed to private
    _calculateTotal(); // Calculate total first

    if (totalCost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('Please make all selections to calculate total cost.')),
      );
      return;
    }

    if (totalCost > expectedBudget) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Budget Exceeded'),
          content: Text(
              'Total Cost: PKR $totalCost\nYour expected budget is PKR $expectedBudget.\n\nDo you still want to proceed with the booking?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close budget dialog
                  _saveOrderToFirestore(); // Proceed to save
                },
                child: const Text('Book Anyway')),
          ],
        ),
      );
    } else {
      // If budget is met, directly try to save
      _saveOrderToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grandeur Booking Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Customer Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
                onChanged: (val) => setState(() =>
                customerName = val), // Use setState for direct assignment
              ),
              // Number of Guests
              TextFormField(
                decoration:
                const InputDecoration(labelText: 'Number of Guests'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter number of guests';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Enter a valid number of guests';
                  }
                  return null;
                },
                onChanged: (val) => setState(() {
                  guestCount = int.tryParse(val) ?? 0;
                  _calculateTotal(); // Recalculate on change
                }),
              ),
              // Expected Budget
              TextFormField(
                decoration:
                const InputDecoration(labelText: 'Expected Budget (PKR)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your budget';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Enter a valid budget amount';
                  }
                  return null;
                },
                onChanged: (val) =>
                    setState(() => expectedBudget = int.tryParse(val) ?? 0),
              ),

              const SizedBox(height: 20),

              // Hall Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Select Hall', border: OutlineInputBorder()),
                value: selectedHall,
                // Ensure value is set for the dropdown
                items: halls.map((hall) {
                  return DropdownMenuItem<String>(
                    value: hall['name'],
                    child: Text('${hall['name']} - PKR ${hall['price']}'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedHall = val;
                      hallPrice =
                      halls.firstWhere((h) => h['name'] == val)['price'];
                      _calculateTotal(); // Recalculate on change
                    });
                  }
                },
                validator: (value) =>
                value == null ? 'Please select a hall' : null,
              ),

              const SizedBox(height: 20),

              // Menu Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Select Menu', border: OutlineInputBorder()),
                value: selectedMenu,
                // Ensure value is set
                items: menus.map((menu) {
                  return DropdownMenuItem<String>(
                    value: menu['name'],
                    child: Text(menu['name']),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedMenu = val;
                      var selected = menus.firstWhere((m) => m['name'] == val);
                      menuPricePerHead = selected['price'];
                      menuDetails = selected['details'];
                      _calculateTotal(); // Recalculate on change
                    });
                  }
                },
                validator: (value) =>
                value == null ? 'Please select a menu' : null,
              ),

              if (menuDetails.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text('Menu Details: $menuDetails',
                    style: Theme.of(context).textTheme.bodySmall),
              ],

              const SizedBox(height: 20),
              // Display Total Cost (optional)
              if (totalCost > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Estimated Total Cost: PKR $totalCost',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),

              const SizedBox(height: 20), // Adjusted spacing

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  // Disable button when loading
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!
                        .save(); // Good practice to call save
                    _checkBudgetAndBook();
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15)),
                child: _isLoading
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ))
                    : const Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}