import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/categories/catering.dart';
import 'package:untitled5/client_screen/categories/dresses.dart';
import 'package:untitled5/client_screen/categories/jewellery.dart';
import 'package:untitled5/client_screen/categories/marquees.dart';
import 'package:untitled5/client_screen/categories/parlour_packages.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _services = [
    {
      "title": "Catering",
      "description": "Delicious meals for your events",
      "category": "Food",
      "subServices": [
        {"name": "Buffet Setup"},
        {"name": "Custom Menu"},
      ]
    },
    {
      "title": "Rental Dresses",
      "description": "Elegant dresses for rent",
      "category": "Apparel",
      "subServices": [
        {"name": "Wedding Gowns"},
        {"name": "Traditional Dresses"},
      ]
    },
    {
      "title": "Jewellery",
      "description": "Elegant jewelry for your special occasion",
      "category": "Apparel",
      "subServices": [
        {"name": "Necklaces"},
        {"name": "Earrings"},
        {"name": "Bracelets"},
      ]
    },
    {
      "title": "Marquees",
      "description": "Perfect tents for your event",
      "category": "Venue",
      "subServices": [
        {"name": "Outdoor Tents"},
        {"name": "Indoor Setups"},
      ]
    },
    {
      "title": "Beauty & Parlour Packages",
      "description": "Relax and rejuvenate with our beauty packages",
      "category": "Beauty",
      "subServices": [
        {"name": "Makeup Services"},
        {"name": "Hair Styling"},
        {"name": "Skincare Treatments"},
      ]
    },
  ];

  final List<String> _categories = ["All", "Food", "Apparel", "Venue", "Beauty"];
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EAE8), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        title: const Text(
          "Manage Services",
          style: TextStyle(
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2C2C), // Black text color
          ),
        ),
        centerTitle: true,
        elevation: 4, // Slight shadow for depth
        shadowColor: const Color(0xFFDFC2BF), // Subtle shadow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Services",
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFEFC8C5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFEFC8C5)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(fontFamily: 'Serif', fontSize: 18, color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _services
                    .where((service) {
                  return (_selectedCategory == "All" ||
                      service["category"] == _selectedCategory) &&
                      (service["title"]!.toLowerCase().contains(_searchQuery) ||
                          service["description"]!.toLowerCase().contains(_searchQuery));
                })
                    .map((service) {
                  return _buildServiceCard(
                    service["title"]!,
                    service["description"]!,
                    service["category"]!,
                    service["subServices"],
                  );
                })
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddServiceDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                "Add New Service",
                style: TextStyle(
                  fontFamily: 'Serif',
                  color: Color(0xFF2C2C2C), // Black text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String description, String category, List subServices) {
    return GestureDetector(
      onTap: () {
        if(title == "Catering") {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => CateringScreen()));
        }if(title == "Rental Dresses") {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => DressesScreen()));
        }if(title == "Jewellery") {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => JewelleryScreen()));
        }if(title == "Marquees") {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => MarqueeScreen()));
        }if(title == "Beauty & Parlour Packages") {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => ParlourPackagesScreen()));
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFEFC8C5),
            child: Icon(Icons.build, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Serif',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFFEFC8C5)),
            onPressed: () {
              _showSubServicesDialog(subServices, title);
            },
          ),
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    String newServiceTitle = "";
    String newServiceDescription = "";
    String newServiceCategory = "Food";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Service", style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Service Title"),
                onChanged: (value) => newServiceTitle = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Service Description"),
                onChanged: (value) => newServiceDescription = value,
              ),
              DropdownButton<String>(
                value: newServiceCategory,
                items: _categories.where((c) => c != "All").map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    newServiceCategory = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                if (newServiceTitle.isNotEmpty && newServiceDescription.isNotEmpty) {
                  setState(() {
                    _services.add({
                      "title": newServiceTitle,
                      "description": newServiceDescription,
                      "category": newServiceCategory,
                      "subServices": []
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showSubServicesDialog(List subServices, String serviceTitle) {
    // Implementation for showing sub-services dialog.
  }
}
